#!/bin/bash

read -r -p "Are you sure you want to start the installation script for \"debian\" ? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) ;;
    *) echo "Aborted."; exit 1 ;;
esac

export BASE_DIR=$(echo "$PWD")
export TARGET_UNIX="linux-gnu"

git submodule init
git submodule update

source $BASE_DIR/scripts/common/utils.sh

bash $BASE_DIR/scripts/debian/install.sh
