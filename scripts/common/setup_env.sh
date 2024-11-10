#!/bin/bash

echo
echo -n "Start setting up environment"
prompt_user_to_continue

mkdir -p ~/notes
mkdir -p ~/.config/zsh/plugins

cp     $BASE_DIR/fs/common/.gitconfig ~/.gitconfig
cp     $BASE_DIR/fs/common/.zshenv ~/.zshenv
cp -rf $BASE_DIR/fs/common/.config ~/.config

cp -rf $BASE_DIR/submodules/zsh-syntax-highlighting ~/.config/zsh/plugins
