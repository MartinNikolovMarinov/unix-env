#!/bin/bash

[ -z "${OUTPUT_DIRECTORY}" ] && { log_err "OUTPUT_DIRECTORY not set, environment setup failed"; exit 1; }

mkdir -p $OUTPUT_DIRECTORY

mkdir -p $OUTPUT_DIRECTORY/notes
mkdir -p $OUTPUT_DIRECTORY/.config/zsh/plugins

cp       $BASE_DIR/fs/common/.gitconfig $OUTPUT_DIRECTORY/.gitconfig
cp       $BASE_DIR/fs/common/.zshenv    $OUTPUT_DIRECTORY/.zshenv

# Sync common .config
sync_fs_tree     $BASE_DIR/fs/common/.config                  "$OUTPUT_DIRECTORY/.config"
cp           -rf $BASE_DIR/submodules/zsh-syntax-highlighting $OUTPUT_DIRECTORY/.config/zsh/plugins

case $SELECTED_DESKTOP_ENVIRONMENT in
    0)
        echo Copy the SWAY specific configurations
        sync_fs_tree     $BASE_DIR/fs/arch-sway/.config    "$OUTPUT_DIRECTORY/.config"
        ;;
    1)
        echo TODO: Copy the KDE specific configurations
        echo "exec startplasma-wayland" >> $OUTPUT_DIRECTORY/.xinitrc
        ;;
    2)
        echo Copy the GNOME specific configurations
        sync_fs_tree     $BASE_DIR/fs/arch-gnome/.config    "$OUTPUT_DIRECTORY/.config"
        ;;
esac

log_info "Setting zsh as default shell"
chsh -s $(which zsh)

log_info "Environment setup done"
