#!/bin/bash

sudo pacman -S gnome gnome-shell gnome-session gdm

# Enable services
sudo systemctl enable --now NetworkManager
sudo systemctl enable gdm