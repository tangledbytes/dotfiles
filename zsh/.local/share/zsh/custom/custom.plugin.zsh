# Cutom aliases =====
alias vim="nvim"
alias c="code ."
alias cls="clear"
alias gc="git commit -v -s"

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
