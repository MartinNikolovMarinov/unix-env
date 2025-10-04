#!/bin/bash

sudo pacman -S gnome gnome-shell gnome-session gdm

# Enable services
sudo systemctl enable --now NetworkManager
sudo systemctl enable gdm

# Modify the settings for Alt+Tab behaviour
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
