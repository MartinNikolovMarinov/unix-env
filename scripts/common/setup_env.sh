#!/bin/bash

echo
echo -n "Start setting up environment"
prompt_user_yes_no

cp     $BASE_DIR/fs/common/.gitconfig ~/.gitconfig
cp     $BASE_DIR/fs/common/.zshenv ~/.zshenv
cp -rf $BASE_DIR/fs/common/.config/* ~/.config

mkdir -p ~/notes

mkdir -p ~/.config/zsh/plugins
rm -rf ~/.config/zsh/plugins/zsh-syntax-highlighting
cp -rf $BASE_DIR/submodules/zsh-syntax-highlighting ~/.config/zsh/plugins
