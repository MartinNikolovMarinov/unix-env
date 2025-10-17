#!/bin/bash

# Install YaY from a verified source checkout
if prompt_user_confirm_dialog "Do you want to install yay from source?"; then
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT

    git clone https://aur.archlinux.org/yay.git "$tmpdir"
    cd "$tmpdir"
    makepkg -si --noconfirm

    rm -rf "$tmpdir"
    trap - EXIT
fi
