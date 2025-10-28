# SETUP TOOL DEPENDENT ENVIRONMENT VARIABLES

# No need to setup anything for Rust because rustup does it for us in .zshenv file

# For Golang
if command -v go &>/dev/null
then
  export GOPATH=$(go env GOPATH)
  export GOROOT=$(go env GOROOT)
  path+=("$GOPATH/bin")
  path+=("$GOROOT/bin")
fi

# For Zig
# if command -v zig &>/dev/null
# then
# fi

# For Node (NVM)
if [ -f "$HOME/.nvm/nvm.sh" ]
then
  export NVM_DIR="$HOME/.nvm"
  lazysource nvm "$NVM_DIR/nvm.sh"
fi

export PATH

