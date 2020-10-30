# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#####################################################################################################################
# Changes made by Utkarsh Srivastava
# Custom functions ========

ccd() {
  mkdir $1 && cd $1
}

# Custom Aliases ==========
alias vim="nvim"
alias c="code ."
alias rrc="~/.conky/conky-startup.sh --sleep=0s"

# Custom exports ==========
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:$HOME/bin
export GOPATH=$HOME/go

export EDITOR=/usr/bin/nvim
export BROWSER='google-chrome-stable'

export UPLUGINS=$HOME/.zsh-plugins

# Enable custom plugins ==========
source $UPLUGINS/git.plugin.zsh
source $UPLUGINS/common-aliases.plugin.zsh

# Add paths
export PATH=$PATH:$GOPATH/bin
