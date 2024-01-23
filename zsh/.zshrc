source ~/.config/zsh/init.zsh

alias vdssh="limactl shell --workdir /home/$USER.linux devenv"

function vmc() {
	local target_path="$1"
	local linux_home="/home/$USER.linux"
	local full_path=$(cd "$target_path" && pwd)
	local linux_path="${linux_home}${full_path/#$HOME}"

	echo "Opening $linux_path in VSCode on Linux"
	code --remote ssh-remote+localhost "$linux_path"
}
