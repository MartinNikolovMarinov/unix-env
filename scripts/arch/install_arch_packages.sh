#!/bin/bash

function install_arch_pkg() {
    if [[ -n $1 ]]; then
        sudo pacman -S $1
        local resp_code=$(echo $?)
        if [[ $resp_code != 0 ]]; then
            log_err "Install of $1 apt package failed with exit code: $resp_code" "error"
            return -1
        fi
    fi

    return 0
}

sudo pacman -Syu
sudo pacman -S dialog # Will need this for the next step

if ! prompt_user_confirm_dialog "Continue with Pacman installation"; then
    # Option to exit early if packages are already installed
    return 0
fi

# Install packages
available_packages=(
    "wl-clipboard"
    "pacman-contrib"
    "base-devel"
    "linux-headers"
    "libsecret"
    "pipewire"
    "pipewire-alsa"
    "pipewire-jack"
    "pipewire-pulse"
    "fd"
    "fzf"
    "less"
    "tree"
    "htop"
    "neofetch"
    "zsh"
    "wget"
    "curl"
    "xdg-utils"
    "ttf-fira-code"
    "noto-fonts-emoji"
    "networkmanager"
    "kitty"
    "firefox"
    "nvidia"
    "nvidia-utils"
    "nvidia-settings"
)

selected_packages=()
prompt_user_for_packages_dialog "Select packages to install:" available_packages selected_packages
log_info "Selected packages: ${selected_packages[@]}"

# Install packages one-by-one to pay close attention to what fails.
for pkg in "${selected_packages[@]}"
do
    install_arch_pkg $pkg
done

source $BASE_DIR/scripts/arch/install_yay.sh
