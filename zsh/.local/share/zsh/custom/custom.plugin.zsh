# Cutom aliases =====
alias c="code ."
alias gc="git commit -v -s"
alias lg="lazygit"
alias rnd="alacritty msg create-window -e ssh -t utkarsh@rnd"
alias n="nvim ."

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

# SETUP ITERM2 INTEGRATION ===================================================================
# if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
#   source "${HOME}/.iterm2_shell_integration.zsh"
# fi
