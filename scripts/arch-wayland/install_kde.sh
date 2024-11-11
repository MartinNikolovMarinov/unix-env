#!/bin/bash

sudo pacman -S sddm wl-clipboard plasma-desktop \
               xorg-xwayland plasma-wayland-protocols \
               dolphin spectacle

# Enable services
sudo systemctl enable --now NetworkManager
sudo systemctl enable sddm
