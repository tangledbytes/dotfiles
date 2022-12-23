#!/bin/bash

dependencies=("make" "nvim" "tmux")
exit_code=0

function check_deps() {

    echo "Checking Dependencies..."

    for dep in "${dependencies[@]}"; do
        if ! command -v $dep &> /dev/null; then
            echo "$dep - dependency not found"
            exit_code=1
        else
            echo "$dep - dependency found"
        fi
    done
}

check_deps
exit $exit_code
