#!/bin/bash

export BASE_DIR=$(echo "$PWD")
export TARGET_UNIX="linux-arch"

source $BASE_DIR/common/common_scripts.sh

git submodule init
git submodule update

prompt_user_choice "Choose window manager" "Wayland" "X11"
export WMGR=$?

case $WMGR in
    1)
        # Wayland
        source $BASE_DIR/linux-arch/scripts/install.sh
        ;;
    2)
        # X11
        log_err "X11 not supported  yet"
        ;;
esac

