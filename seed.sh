#!/bin/bash

function exists() {
    local pre="$1"
    shift;

    local list=("$@")

    echo "$pre"

    for item in "${list[@]}"; do
        if ! command -v $item &> /dev/null; then
            echo "$item - item not found"
        else
            echo "$item - item found"
        fi
    done
}

dependencies=("nvim" "vim" "stow" "tmux" "make")

exists "Checking dependencies..." "${dependencies[@]}"
