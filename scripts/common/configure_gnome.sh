#!/bin/bash

# Modify the settings for Alt+Tab behavior:
gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"

# Add a minimize and maximize buttons to windows:
gsettings set org.gnome.desktop.wm.preferences button-layout :minimize,maximize,close
