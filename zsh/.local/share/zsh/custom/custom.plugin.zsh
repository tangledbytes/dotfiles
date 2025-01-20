# Cutom aliases =====
alias c="code ."
alias gc="git commit -v -s"
alias lg="lazygit"
alias rnd="alacritty msg create-window -e ssh -t utkarsh@rnd"
alias n="nvim ."
alias xssh="alacritty msg create-window -e ssh -t"

# Alias overrides for mac
if [ "$(uname)" == "Darwin" ]; then
	alias rnd="open -n -a Ghostty --args -e 'ssh -t utkarsh@rnd tmux -u new-session -s home -A -c ~'"
	alias xssh="open -n -a Ghostty --args -e 'ssh -t"
fi

# Custom functions =====
function ccd() {
  mkdir -p $1 && cd $1
}

function uexp() {
  local cmd=$1
  local typ=$(whence -w $cmd | cut -d' ' -f2)

  if [ "$typ" = "alias" ]; then cmd="$(alias $cmd | cut -d\' -f2)"; fi
  shift
  
  local final="$cmd $@"
  echo $final
}

function w() {
  local cmd="$(uexp "$@")"

  watch -c "$cmd"
}

function ucls () {
  printf '\033[2J\033[3J\033[1;1H'
}

function vmc() {
	local target_path="$1"
	local linux_home="/home/$USER.linux"
	local full_path="$(cd "$target_path" && pwd)"
	local linux_path="${linux_home}${full_path/#$HOME}"

	echo "Opening $linux_path in VSCode on Linux"
	code --remote ssh-remote+localhost "$linux_path"
}

function rndc() {
	local target_path="$1"
	local rnd_home="/home/utkarsh"
	local rnd_path="$target_path"

	if [ -d "$target_path" ]; then
		local full_path="$(cd "$target_path" && pwd)"
		rnd_path="${rnd_home}${full_path/#$HOME}"
	fi

	echo "Opening $rnd_path in VSCode in RnD"
	code --remote ssh-remote+rnd "$rnd_path"
}

function nf() {
	local opt="$1"
	if [ -z "$opt" ]; then
		opt="$(fzf --preview='bat -f {}' --preview-window=right --layout=reverse --height=50%)"
	fi

	if [ "$?" -eq 0 ]; then
		nvim "$opt"
	fi
}

function drnd() {
	local docker_pth="$(which docker)"
	local container_name="ide-x86"

	if [[ $(docker ps -a --filter="name=$container_name" --filter "status=exited" | grep -w "$container_name") ]]; then
		echo "Container exists but exited - Restarting ..."
		"$docker_pth" start "$container_name"
	elif [[ $(docker ps -a --filter="name=$container_name" --filter "status=running" | grep -w "$container_name") ]]; then
	else
		echo "Container doesn't exists - Creating..."
		"$docker_pth" run -d \
			--privileged \
			--rm \
			--name ide-x86 \
			--hostname "$container_name" \
			-v "$HOME/dev":/root/dev \
			--platform linux/amd64 \
			utkarsh23/uide
	fi

	alacritty msg create-window -e \
		"$docker_pth" exec -it \
			--detach-keys 'ctrl-e,e' "$container_name" \
				zsh -c "exec tmux new-session -A -D -c ~ -s $container_name-home"
}

# SETUP ITERM2 INTEGRATION ===================================================================
# if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
#   source "${HOME}/.iterm2_shell_integration.zsh"
# fi
