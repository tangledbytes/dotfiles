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

# SETUP ITERM2 INTEGRATION ===================================================================
# if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
#   source "${HOME}/.iterm2_shell_integration.zsh"
# fi
