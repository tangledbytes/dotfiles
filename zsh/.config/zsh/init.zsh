#!/usr/bin/env zsh

# ============================================================================
# PLUGIN MANAGEMENT CODE
# 
# NOTE: THIS IS JUST A TEMPORARY FIX
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SHARE_PATH="$HOME/.local/share"
ZSH_PLUGIN_PATH="$SHARE_PATH/zsh/plugins"
ZSH_PLUGIN_CUSTOM_PATH="$SHARE_PATH/zsh/custom"

# Setup the zsh plugins paths
mkdir -p "$ZSH_PLUGIN_PATH"

# uzsh_remote_plugin takes name of a plugin in the format <username>/<repo>
# and expects the plugin to be on github
#
# NOTE: git must be installed on the system
function uzsh_remote_plugin() {
  local name="$1"
  local parsed=("${(@s|/|)name}")
  local owner=${parsed[@]:0:1}
  local repo=${parsed[@]:1:1}
  local lpath="$ZSH_PLUGIN_PATH/$repo"

  if [[ -z "$name" ]]; then
    echo "plugin(): name cannot be empty"
    exit 1
  fi

  if [ ! -d "$lpath" ]; then
    echo "Installing \"$name\" ..."
    git clone --depth=1 https://github.com/$name $lpath
  fi

  # Finally source the file
  source "$ZSH_PLUGIN_PATH/$repo/$repo.plugin.zsh"
}

# uzsh_local_plugin takes in path to a local 
function uzsh_local_plugin() {
  local lpath="$1"

  if [[ -z "$lpath" ]]; then
    echo "plugin(): path cannot be empty"
    exit 1
  fi

  source "$lpath"
}

# uzsh_plugin_update_all tries to update all of the remote plugins
function uzsh_plugin_update_all() {
  for d in $ZSH_PLUGIN_PATH/*/
  do
    pushd "$d"
    git pull
    popd
  done
}

function uzsh_plugin_cleanup_all() {
  for d in $ZSH_PLUGIN_PATH/*/
  do
    rm -rf $d
  done
} 


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# PLUGIN MANAGEMENT CODE ENDS
# ============================================================================
# UTILITY FUNCTIONS BEGINS HERE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# shutup is a util function that redirects the given
# command stdout and stderr into /dev/null
function shutup() {
  "$@" &> /dev/null
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# UTILITY FUNCTIONS ENDS HERE
# ============================================================================

# Setup remote plugins
remote_plugins=(
  "jeffreytse/zsh-vi-mode"
  "zsh-users/zsh-autosuggestions"
  "zdharma-continuum/fast-syntax-highlighting"
  "zsh-users/zsh-history-substring-search"
)
for rp in ${remote_plugins[@]}
do
  shutup uzsh_remote_plugin "$rp"
done

# Setup local plugins
if [ -d "$ZSH_PLUGIN_CUSTOM_PATH" ]; then
  local cur="$ZSH_PLUGIN_CUSTOM_PATH"
  local pre="$cur/pre"
  local post="$cur/post"

  if [ -d "$pre" ]; then
    for f in $pre/*(.)zsh
    do
      source "$f"
    done
  fi

  for f in $cur/*(.)zsh
  do
    source "$f"
  done

  if [ -d "$post" ]; then
    for f in $post/*(.)zsh
    do
      source "$f"
    done
  fi
fi
