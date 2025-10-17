#!/bin/bash

sudo pacman -S sddm sway wayland wlroots xorg-xwayland \
    xdg-desktop-portal-wlr swaybg wofi waybar polkit \
    wireplumber pavucontrol \
    grim slurp wl-clipboard brightnessctl \
    noto-fonts noto-fonts-emoji noto-fonts-cjk

mkdir -p ~/.config/sway

# Enable services
sudo systemctl enable --now NetworkManager
sudo systemctl enable sddm
