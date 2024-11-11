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

# Install packages
available_packages=(
    "pipewire"
    "pipewire-alsa"
    "pipewire-jack"
    "pipewire-pulse"
    "base-devel"
    "less"
    "tree"
    "htop"
    "neofetch"
    "zsh"
    "wget"
    "curl"
    "xdg-utils"
    "networkmanager"
    "kitty"
    "firefox"
)

selected_packages=()
prompt_user_for_packages "Select packages to install:" available_packages selected_packages
log_info "Selected packages: ${selected_packages[@]}"

if prompt_user_confirm "Install packages one-by-one?"; then
    for pkg in "${selected_packages[@]}"
    do
        install_arch_pkg $pkg
    done
else
    sudo pacman -S "${selected_packages[@]}" || echo "Error: Installation failed for some packages" >&2
fi

# Install YaY
if prompt_user_confirm "Do you want to install yay from source?"; then
    log_info "Installing AUR yay"
    git clone https://aur.archlinux.org/yay.git
    pushd yay
        makepkg -si
    popd
    rm -rf yay
fi

# Install Desktop envoronment
available_desktop_environments=(
    "sway"
    "kde"
)
export SELECTED_DESKTOP_ENVIRONMENT=1
prompt_user_radio_select "Select a desktop environment:" SELECTED_DESKTOP_ENVIRONMENT available_desktop_environments
case $SELECTED_DESKTOP_ENVIRONMENT in
    0)
        # Sway
        source $BASE_DIR/scripts/arch-wayland/install_sway.sh
        ;;
    1)
        # Kde
        source $BASE_DIR/scripts/arch-wayland/install_kde.sh
        ;;
    *)
        log_info "No desktop environment selected"
        exit 1
        ;;
esac
