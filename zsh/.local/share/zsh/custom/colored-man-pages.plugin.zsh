# Requires colors autoload.
# See termcap(5).

# Set up once, and then reuse. This way it supports user overrides after the
# plugin is loaded.
typeset -AHg less_termcap

# bold & blinking mode
less_termcap[mb]=$(printf "\e[1;32m")
less_termcap[md]=$(printf "\e[1;32m")
less_termcap[me]=$(printf "\e[0m")
# standout mode
less_termcap[se]=$(printf "\e[01;33m")
less_termcap[so]=$(printf "\e[0m")
# underlining
less_termcap[ue]=$(printf "\e[0m")
less_termcap[us]=$(printf "\e[1;4;31m")

# Absolute path to this file's directory.
typeset __colored_man_pages_dir="${0:A:h}"

function colored() {
  local -a environment

  # Convert associative array to plain array of NAME=VALUE items.
  local k v
  for k v in "${(@kv)less_termcap}"; do
    environment+=( "LESS_TERMCAP_${k}=${v}" )
  done

  # Prefer `less` whenever available, since we specifically configured
  # environment for it.
  environment+=( PAGER="${commands[less]:-$PAGER}" )

  command env $environment "$@"
}

# Colorize man and dman/debman (from debian-goodies)
function man \
  dman \
  debman {
  colored $0 "$@"
}
