#!/bin/bash

echo
echo -n "Start setting up environment"
prompt_user_to_continue

cp -rf $BASE_DIR/common/.gitconfig ~/.gitconfig
cp -rf $BASE_DIR/common/.config/* ~/.config

cp -rf $BASE_DIR/mac/.zshenv ~/.zshenv
cp -rf $BASE_DIR/mac/.config/* ~/.config

mkdir -p ~/.config/zsh/plugins
rm -rf ~/.config/zsh/plugins/zsh-syntax-highlighting
cp -rf $BASE_DIR/submodules/zsh-syntax-highlighting ~/.config/zsh/plugins

mkdir -p ~/notes
