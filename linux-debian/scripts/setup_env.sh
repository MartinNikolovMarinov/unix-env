#!/bin/bash

echo -n "Start setting up environment"
prompt_user_yes_no

cp -rf $BASE_DIR/linux-debian/.zshenv ~/.zshenv
cp -rf $BASE_DIR/linux-debian/.gitconfig ~/.gitconfig
cp -rf $BASE_DIR/linux-debian/.config/* ~/.config

mkdir -p ~/.config/zsh/plugins
cp -rf $BASE_DIR/submodules/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting

mkdir -p ~/notes

log_info "Setting kitty as default terminal emulator"
sudo update-alternatives --set x-terminal-emulator /usr/bin/kitty

log_info "Setting zsh as default shell"
chsh -s $(which zsh)