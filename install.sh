#!/bin/bash

export BASE_DIR=$(echo "$PWD")

git submodule init
git submodule update

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export TARGET_UNIX="linux-gnu"
    bash $BASE_DIR/linux-debian/scripts/install.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export TARGET_UNIX="darwin"
    bash $BASE_DIR/mac/scripts/install.sh
else
    echo "OS not supported."
    exit 1
fi

# TODO: I need to create options for the package manager (e.g. apt, or pacman)
# TODO: I neet to create options for wayland and x11
