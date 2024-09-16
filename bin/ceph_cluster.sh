#!/bin/bash

VM_BASE_NAME="${VM_BASE_NAME:-ceph}"
CEPH_FS_NAME="${CEPH_FS_NAME:-newFS}"
CEPH_MOUNT_LOC="${CEPH_MOUNT_LOC:-/mnt/mycephfs/}"
TOTAL_NODES=${TOTAL_NODES:-3}
DISK_PER_NODE_SIZE_GB=${DISK_PER_NODE_SIZE_GB:-4}

LAST_NODE_INDEX=$((TOTAL_NODES - 1))

fatal_failure=false

function check_and_report_fatal() {
	if [ "$fatal_failure" = true ];
	then
		if [ -z "$1" ];
		then
			echo "[FATAL FAILURE]"
		else
			echo "[FATAL FAILURE]: $1"
		fi
		exit 1
	fi
}

function prereqs_check() {
	if [[ $(uname) != "Darwin" ]];
	then
		echo "Only MacOs is supported"
		exit 1
	fi

	local prereq_bins=("limactl" "rsync" "ssh")
	for pb in "${prereq_bins[@]}";
	do
		if ! command -v "$pb" &> /dev/null
		then
			echo "$pb could not be found"
			exit 1
		fi
	done

	# Check if socket_vmnet exists
	local candidates=(
		"/opt/socket_vmnet/bin/socket_vmnet"
		"socket_vmnet"
		"/usr/local/opt/socket_vmnet/bin/socket_vmnet"
		"/opt/homebrew/opt/socket_vmnet/bin/socket_vmnet"
	)

	local found=0
	for c in "${candidates[@]}";
	do
		if command -v "$c" &> /dev/null
		then
			found=1
		fi
	done
	if [[ "$found" == "0" ]];
	then
		echo "socket_vmnet could not be found"
		exit 1
	fi
}

function sanity_check() {
	if (( TOTAL_NODES < 3 ));
	then
		echo "TOTAL_NODES cannot be less than 3"
		exit 1
	fi

	if (( DISK_PER_NODE_SIZE_GB < 4 ));
	then
		echo "DISK_PER_NODE_SIZE_GB cannot be less than 4"
		exit 1
	fi
}

function cluster_exists() {
	for i in $(seq 0 "$LAST_NODE_INDEX");
	do
		if ! limactl ls -q | grep -q "$VM_BASE_NAME-$i"; then
			return 1
		fi
	done

	return 0
}

function start_vm() {
	limactl --tty=false start --name="$VM_BASE_NAME-$1" --network=lima:shared --plain template://default || fatal_failure=true
}

function run_cmd_in_vm () {
	ssh -F "$HOME/.lima/$VM_BASE_NAME-$1/ssh.config" "lima-$VM_BASE_NAME-$1" "$2"
}

function fetch_ip() {
	run_cmd_in_vm "$1" "ip -4 -j addr show dev lima0 | jq -r '.[0].addr_info.[0].local'"
}

function install_vm_deps () {
	run_cmd_in_vm "$1" "sudo snap install microceph && sudo snap refresh --hold microceph" || fatal_failure=true
}

function setup() {
	if cluster_exists;
	then
		echo "Cluster already exists"
		exit
	fi

	local ips=()

	# Start VMs
	for i in $(seq 0 "$LAST_NODE_INDEX");
	do
		start_vm "$i" &
	done

	# Wait for all the VMs to start
	wait

	check_and_report_fatal "Failed to start VMs"

	# Get IP addresses of each instance
	for i in $(seq 0 "$LAST_NODE_INDEX");
	do
		local ip
		ip=$(fetch_ip "$i" || fatal_failure=true)
		check_and_report_fatal "Failed to fetch IP"
		ips+=( "$ip" )
	done

	echo "Collected all the IPs: ${ips[*]}"

	# Install deps in all the clusters
	for i in $(seq 0 "$LAST_NODE_INDEX");
	do
		install_vm_deps "$i" &
	done

	# Wait for comman to finish in the VMs
	wait

	check_and_report_fatal "Failed to install required dependencies on the VMs"

	# Bootstrap cluster in the first VM
	echo "Completed dependency installation - starting cluster bootstrap"
	run_cmd_in_vm 0 "sudo microceph cluster bootstrap --mon-ip ${ips[0]} --microceph-ip ${ips[0]}" || fatal_failure=true

	check_and_report_fatal "Failed to bootstrap cluster"

	# Join the nodes into the cluster
	echo "Complete cluster bootstrap - Joining nodes"
	for i in $(seq 1 "$LAST_NODE_INDEX");
	do
		local join_token
		join_token="$(run_cmd_in_vm 0 "sudo microceph cluster add ceph-$1" || fatal_failure=true)"

		check_and_report_fatal "Failed to bootstrap cluster - join token generation failure"

		run_cmd_in_vm "$i" "sudo microceph cluster join --microceph-ip ${ips[$i]} $join_token" || fatal_failure=true

		check_and_report_fatal "Failed to bootstrap cluster - joining failure"

		echo "Node $VM_BASE_NAME-$i joined $VM_BASE_NAME-0 successfully"
	done

	run_cmd_in_vm 0 "sudo microceph.ceph -s"

	local disk_attach_cmd=""
	disk_attach_cmd+="loop_file=\"\$(sudo mktemp -p /mnt XXXX.img)\""
	disk_attach_cmd+=" && sudo truncate -s ${DISK_PER_NODE_SIZE_GB}G \"\${loop_file}\""
	disk_attach_cmd+=" && loop_dev=\"\$(sudo losetup --show -f \"\${loop_file}\")\""
	disk_attach_cmd+=" && minor=\"\${loop_dev##/dev/loop}\""
	disk_attach_cmd+=" && sudo mknod -m 0660 \"/dev/sdia\" b 7 \"\${minor}\""
	disk_attach_cmd+=" && sudo microceph disk add --wipe \"/dev/sdia\""
	for i in $(seq 0 "$LAST_NODE_INDEX");
	do
		run_cmd_in_vm "$i" "loop_file=\"\$(sudo mktemp -p /mnt XXXX.img)\" && \
			sudo truncate -s ${DISK_PER_NODE_SIZE_GB}G \"\${loop_file}\" && \
			loop_dev=\"\$(sudo losetup --show -f \"\${loop_file}\")\" && \
			minor=\"\${loop_dev##/dev/loop}\" && \
			sudo mknod -m 0660 \"/dev/sdia\" b 7 \"\${minor}\" && \
			sudo microceph disk add --wipe \"/dev/sdia\"" || fatal_failure=true &
	done

	# Wait for Disks to attach
	wait

	check_and_report_fatal "Failed to attach disks to the nodes"

	echo "Creating filesystem: $CEPH_FS_NAME"
	run_cmd_in_vm 0 "sudo ceph osd pool create cephfs_meta && sudo ceph osd pool create cephfs_data && sudo ceph fs new $CEPH_FS_NAME cephfs_meta cephfs_data && sudo ceph fs ls" || fatal_failure=true

	check_and_report_fatal "Failed to create $CEPH_FS_NAME CephFS"

	# Mount filesystem in the client VMs
	for i in $(seq 1 "$LAST_NODE_INDEX");
	do
		run_cmd_in_vm "$i" "sudo apt install -y ceph-common && \
			sudo ln -s /var/snap/microceph/current/conf/ceph.keyring /etc/ceph/ceph.keyring && \
			sudo ln -s /var/snap/microceph/current/conf/ceph.conf /etc/ceph/ceph.conf && \
			sudo mkdir $CEPH_MOUNT_LOC && sudo mount -t ceph :/ $CEPH_MOUNT_LOC -o name=admin,fs=$CEPH_FS_NAME" || fatal_failure=true &
	done

	# Wait for FS to be mounted
	wait

	check_and_report_fatal "Failed to mount filesystem on the client nodes"
}

function validate_node_name() {
	local regex="^$VM_BASE_NAME\-([0-9]+)$"

	local node="$1"
	if [[ "$node" =~ $regex ]];
	then
		local match="${BASH_REMATCH[1]}"

		if [ "$match" -ge "$2" ] && [ "$match" -le "$3" ];
		then
			echo "$match"
			return
		fi
	fi

	echo "Invalid node name specifid - options are:"
	for i in $(seq "$2" "$3");
	do
		echo "$i. $VM_BASE_NAME-$i"
	done

	exit 1
}

function shell() {
	local nodenum
	nodenum=$(validate_node_name "$1" 0 "$LAST_NODE_INDEX")
	local retVal="$?"
	if [ $retVal -ne 0 ];
	then
		echo "$nodenum"
		exit 1
	fi
	shift

	run_cmd_in_vm "$nodenum" "$*"
}

function ceph() {
	local node="${1:-$VM_BASE_NAME-0}";
	shift

	shell "$node" "sudo microceph.ceph $*"
}

function status() {
	ceph "${1:-$VM_BASE_NAME-0}" "-s"
}

function node_ips() {
	local ips=()
	for i in $(seq "$1" "$2");
	do
		ips+=("$VM_BASE_NAME-$i:$(fetch_ip "$i")")
	done

	for i in "${ips[@]}";
	do
		echo "$i"
	done
}

function cluster_node_ips() {
	node_ips 0 "$LAST_NODE_INDEX" "$1"
}

function nsfs_exists() {
	for i in $(seq 1 "$LAST_NODE_INDEX");
	do
		if ! run_cmd_in_vm "$i" "pgrep noobaa > /dev/null 2>&1";
		then
			return 1
		fi
	done

	return 0
}

function setup_nsfs_cluster () {
	local core_loc="$CEPH_MOUNT_LOC/noobaa-core"

	# Use first client to setup NSFS cluster
	run_cmd_in_vm 1 "sudo mkdir -p $core_loc && sudo chown -R $USER: $core_loc"
	rsync -aq -e "ssh -F $HOME/.lima/$VM_BASE_NAME-1/ssh.config" --exclude .git --exclude node_modules --exclude build "${1:-$(pwd)}" "lima-$VM_BASE_NAME-1:$core_loc" || fatal_failure=true &
	run_cmd_in_vm 1 "sudo apt update && sudo apt install -y build-essential nasm" || fatal_failure=true &
	wait

	check_and_report_fatal "Failed to setup prerequisite environment for NSFS"

	run_cmd_in_vm 1 "(! command -v node) && cd $core_loc && sudo chmod +x ./src/deploy/NVA_build/install_nodejs.sh && sudo ./src/deploy/NVA_build/install_nodejs.sh \"$(cat .nvmrc)\" && npm i && npm run build" || fatal_failure=true &

	for i in $(seq 2 "$LAST_NODE_INDEX");
	do
		run_cmd_in_vm "$i" "(! command -v node) && cd $core_loc && sudo chmod +x ./src/deploy/NVA_build/install_nodejs.sh && sudo ./src/deploy/NVA_build/install_nodejs.sh \"$(cat .nvmrc)\"" || fatal_failure=true &
	done

	wait

	check_and_report_fatal "Failed to setup NooBaa dependencies on the nodes"
}

function start_nsfs_cluster () {
	if nsfs_exists;
	then
		echo "NSFS cluster already exists and is running"
		exit 0
	fi

	run_cmd_in_vm 1 "[ -d \"$CEPH_MOUNT_LOC/noobaa-core\" ]" || fatal_failure=true
	check_and_report_fatal "NSFS cluster wasn't setup before attempting start NSFS processes"

	local config_loc="$CEPH_MOUNT_LOC/.nsfs"

	# Perform maintainance operations from node 1
	run_cmd_in_vm 1 "sudo mkdir -p $config_loc && sudo chown -R $USER: $config_loc && mkdir -p $config_loc/cfg && mkdir -p $config_loc/data"

	for i in $(seq 1 "$LAST_NODE_INDEX");
	do
		echo "Starting endpoint process on IP: $(fetch_ip "$i")"
		run_cmd_in_vm "$i" "nohup sh -c 'cd $CEPH_MOUNT_LOC/noobaa-core && sudo node src/cmd/nsfs/ --config_root $config_loc/cfg $*' >$config_loc/$VM_BASE_NAME-$i.nsfs.log 2>&1 &"
	done
}

function stop_nsfs_cluster () {
	if ! nsfs_exists;
	then
		echo "No running NSFS processes found in the cluster"
		exit 0
	fi

	for i in $(seq 1 "$LAST_NODE_INDEX");
	do
		run_cmd_in_vm "$i" "sudo pkill noobaa"
		echo "Stopped process in node $i"
	done
}

function logs_nsfs() {
	local nodenum
	nodenum=$(validate_node_name "$1" 1 "$LAST_NODE_INDEX")
	local retVal="$?"
	if [ $retVal -ne 0 ];
	then
		echo "$nodenum"
		exit 1
	fi
	shift

	run_cmd_in_vm "$nodenum" "tail $* $CEPH_MOUNT_LOC/.nsfs/$VM_BASE_NAME-$nodenum.nsfs.log"
}

function sync_nsfs() {
	rsync -aq -e "ssh -F $HOME/.lima/$VM_BASE_NAME-1/ssh.config" --exclude .git --exclude node_modules --exclude build "${1:-$(pwd)}" "lima-$VM_BASE_NAME-1:$CEPH_MOUNT_LOC/noobaa-core"
}

function manage_nsfs () {
	# Node 1 is the management node - shouldn't matter - this should touch the shared FS only
	run_cmd_in_vm 1 "cd $CEPH_MOUNT_LOC/noobaa-core && sudo node src/cmd/manage_nsfs $*"
}

function node_ips_nsfs() {
	node_ips 1 "$LAST_NODE_INDEX"
}

function setup_lb_nsfs() {
	# Setup load balancer for NSFS endpoints
	local servers=""
	for i in $(seq 1 "$LAST_NODE_INDEX");
	do
		if [ "$i" = "$LAST_NODE_INDEX" ];
		then
			servers+="        server $(fetch_ip "$i" || fatal_failure=true):${1:-6443};"
		else
			servers+="        server $(fetch_ip "$i" || fatal_failure=true):${1:-6443};\n"
		fi
	done

	check_and_report_fatal "Failed to setup LB - Couldn't find node IP addresses"

	local nginx_config="stream {
    upstream noobaa_server {
$servers
    }

    server {
        listen 6443;
        proxy_pass noobaa_server;
    }
}"

	run_cmd_in_vm 0 "sudo apt install -y nginx libnginx-mod-stream" || fatal_failure=true
	check_and_report_fatal "Failed to setup LB - Couldn't install prerequisites"

	run_cmd_in_vm 0 "grep -qxF 'include /etc/nginx/tcpconf.d/*;' /etc/nginx/nginx.conf || echo 'include /etc/nginx/tcpconf.d/*;' | sudo tee -a /etc/nginx/nginx.conf" || fatal_failure=true
	check_and_report_fatal "Failed to setup LB - Couldn't configure LB"

	run_cmd_in_vm 0 "sudo mkdir -p /etc/nginx/tcpconf.d && echo -e \"$nginx_config\" | sudo tee /etc/nginx/tcpconf.d/lb"
	check_and_report_fatal "Failed to setup LB - Couldn't configure LB"

	run_cmd_in_vm 0 "sudo nginx -t && sudo service nginx reload"
	check_and_report_fatal "Failed to setup LB - LB configuration test failed"
}

function destroy() {
	if ! cluster_exists;
	then
		echo "No cluster exists"
		exit
	fi

	for i in $(seq 0 "$LAST_NODE_INDEX");
	do
		limactl rm -f "$VM_BASE_NAME-$i"
	done
}

function main_nsfs() {
	local cmd="$1"
	shift

	if [[ "$cmd" == "setup" ]];
	then
		setup_nsfs_cluster "$@";
	elif [[ "$cmd" == "start" ]];
	then
		start_nsfs_cluster "$@";
	elif [[ "$cmd" == "stop" ]];
	then
		stop_nsfs_cluster "$@";
	elif [[ "$cmd" == "log" ]];
	then
		logs_nsfs "$@";
	elif [[ "$cmd" == "manage" ]];
	then
		manage_nsfs "$@";
	elif [[ "$cmd" == "sync" ]];
	then
		sync_nsfs "$@";
	elif [[ "$cmd" == "ips" ]];
	then
		node_ips_nsfs "$@";
	elif [[ "$cmd" == "setup-lb" ]];
	then
		setup_lb_nsfs "$@";
	else
		echo "Usage: [script] nsfs <setup | start | log | manage | sync | ips | setup-lb | help>"
	fi
}

function main() {
	sanity_check
	prereqs_check

	local cmd="$1"
	shift;

	if [[ "$cmd" == "setup" ]];
	then
		setup "$@";
	elif [[ "$cmd" == "destroy" ]];
	then
		destroy "$@";
	elif [[ "$cmd" == "nsfs" ]];
	then
		main_nsfs "$@"
	elif [[ "$cmd" =~ ^shell(\.(.+))? ]];
	then
		local match="${BASH_REMATCH[2]}"
		if [ -z "$match" ];
		then
			shell "$@"
		else
			shell "$match" "$@"
		fi
	elif [[ "$cmd" =~ status(\.(.+))? ]];
	then
		local match="${BASH_REMATCH[2]}"
		if [ -z "$match" ];
		then
			status "$@"
		else
			status "$match" "$@"
		fi
	elif [[ "$cmd" =~ ceph(\.(.+))? ]];
	then
		ceph "${BASH_REMATCH[2]}" "$@"
	elif [[ "$cmd" == "ips" ]];
	then
		cluster_node_ips "$@"
	else
		echo "Usage: [script] <setup | destroy | nsfs | ceph.[node] | status.[node] | shell.[node] | ips | help>";
	fi
}

main "$@"

