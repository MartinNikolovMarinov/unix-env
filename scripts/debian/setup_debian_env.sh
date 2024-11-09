#!/bin/bash

source $BASE_DIR/scripts/common/setup_env.sh

copy_or_append_files $BASE_DIR/fs/linux/.config ~/.config
copy_or_append_files $BASE_DIR/fs/debian/.config ~/.config

log_info "Setting kitty as default terminal emulator"
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty

log_info "Setting zsh as default shell"
chsh -s $(which zsh)

log_info "Environment setup done"