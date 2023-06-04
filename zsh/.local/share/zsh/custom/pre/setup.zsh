# SETUP ENVIRONMENT VARIABLES 
path+=("$(go env GOPATH)/bin")
path+=("$HOME/bin")
path+=("$HOME/.local/bin")
export PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export GPG_TTY=$(tty)
export EDITOR=nvim
export CLICOLOR=1 # Force color is ls output

export GOPATH=$(go env GOPATH)
export GOROOT=$(go env GOROOT)

# SETUP ZSH OPTIONS
setopt autocd
## ZSH HISTORY OPTIONS
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt appendhistory

# SETUP FPATH AUTOCOMPLETE
if type brew &>/dev/null # Do it for brew here -- linux can be handled seperately
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

autoload -Uz compinit # Load compinit as a function
compinit

# NOTE: Setup for history substring search with vim mode -- won't work if the plugins are not
# installed beforehand
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
