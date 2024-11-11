#!/bin/bash

echo
echo -n "Start setting up environment"
prompt_user_to_continue

mkdir -p ~/notes
mkdir -p ~/.config/zsh/plugins

cp     $BASE_DIR/fs/common/.gitconfig ~/.gitconfig
cp     $BASE_DIR/fs/common/.zshenv ~/.zshenv

# Sync the .config don't override it!
pushd $BASE_DIR/fs/common
    sync_fs_tree .config ~
popd

cp -rf $BASE_DIR/submodules/zsh-syntax-highlighting ~/.config/zsh/plugins
