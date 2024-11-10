#!/bin/bash

sudo pacman -S sddm sway wayland wlroots xorg-xwayland \
    xdg-desktop-portal-wlr swaybg wofi alacritty \
    grim slurp wl-clipboard brightnessctl \
    pipewire pipewire-pulse wireplumber pavucontrol \
    noto-fonts noto-fonts-emoji noto-fonts-cjk

mkdir -p ~/.config/sway

# TODO: remove the default coniguration an replace it with my configuration:
cp /etc/sway/config ~/.config/sway/

# Append to zsh env
echo "" >> ~/.zshenv
echo export XDG_SESSION_TYPE=wayland >> ~/.zshenv
echo export XDG_CURRENT_DESKTOP=sway >> ~/.zshenv
echo export MOZ_ENABLE_WAYLAND=1 >> ~/.zshenv
echo export QT_QPA_PLATFORM=wayland >> ~/.zshenv

# Enable services
sudo systemctl enable --now NetworkManager
sudo systemctl enable sddm
