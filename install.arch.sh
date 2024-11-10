#!/bin/bash

export BASE_DIR=$(echo "$PWD")
export TARGET_UNIX="linux-arch"

git submodule init
git submodule update

source $BASE_DIR/scripts/common/utils.sh

prompt_user_choice "Choose window manager" "Wayland" "X11"
export WMGR=$?

case $WMGR in
    1)
        # Wayland
        source $BASE_DIR/scripts/arch-wayland/install.sh
        ;;
    2)
        # X11
        log_err "X11 not supported  yet. Probably never will."
        ;;
esac

