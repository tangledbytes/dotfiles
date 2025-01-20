#!/bin/bash

# color_log function is used to print colored log
function color_log() {
    local color=$1
    local log=$2
    case $color in
        red)
            echo -e "\033[31m$log\033[0m"
            ;;
        green)
            echo -e "\033[32m$log\033[0m"
            ;;
        yellow)
            echo -e "\033[33m$log\033[0m"
            ;;
        blue)
            echo -e "\033[34m$log\033[0m"
            ;;
        *)
            echo -e "\033[31m$log\033[0m"
            ;;
    esac
}

function exists() {
    local pre="$1"
    shift;

    local list=("$@")

    color_log blue "${pre}"

    for item in "${list[@]}"; do
        if ! command -v $item &> /dev/null; then
            color_log red "$item - not found"
        else
            color_log green "$item - found"
        fi
    done
}

function exists_brew_based() {
    local pre="$1"
    shift;

    local list=("$@")

    color_log blue "${pre}"

    for item in "${list[@]}"; do
        if ! brew list $item &> /dev/null; then
            color_log red "$item - not found"
        else
            color_log green "$item - found"
        fi
    done
}

dependencies=("nvim" "vim" "stow" "tmux" "make" "git" "starship" "fzf" "rg" "zsh" "sqlite3" "fd" "ghostty")
suggested=("neovide")
macos_dependencies=("brew")
macos_dependencies_brew=("karabiner-elements" "hammerspoon")

exists "Checking dependencies..." "${dependencies[@]}"
exists "Checking suggested dependencies..." "${suggested[@]}"

# If MacOS is used, check if Homebrew is installed
OSTYPE=$(uname)
if [[ "$OSTYPE" == "Darwin" ]]; then
    exists "Checking MacOS specific dependencies..." "${macos_dependencies[@]}"
    exists_brew_based "Checking MacOS specific dependencies (brew)..." "${macos_dependencies_brew[@]}"
fi

echo "====================================================================================="
echo "NOTE: If there are any missing dependencies, please install them before proceeding."
echo "====================================================================================="
color_log green "To setup the dotfiles, run 'make setup' in the root directory of the repository."
