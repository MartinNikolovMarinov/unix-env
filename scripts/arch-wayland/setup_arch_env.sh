#!/bin/bash

source $BASE_DIR/scripts/common/setup_env.sh

pushd $BASE_DIR/fs/linux
    sync_fs_tree .config ~
popd

case $SELECTED_DESKTOP_ENVIRONMENT in
    0)
        echo Copy the sway specific configurations
        pushd $BASE_DIR/fs/sway
            sync_fs_tree .config ~
        popd
        ;;
esac

log_info "Setting zsh as default shell"
chsh -s $(which zsh)

log_info "Environment setup done"


