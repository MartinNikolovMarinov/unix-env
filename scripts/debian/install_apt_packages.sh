#!/bin/bash

function install_apt_pkg() {
    if [[ -n $1 ]]; then
        sudo apt-get install $1
        local resp_code=$(echo $?)
        if [[ $resp_code != 0 ]]; then
            log_err "Install of $1 apt package failed with exit code: $resp_code" "error"
            return -1
        fi
    fi

    return 0
}

sudo apt-get update
sudo apt-get install dialog # Will need this for the next step

if ! prompt_user_confirm_dialog "Continue with APT installation"; then
    # Option to exit early if packages are already installed
    return 0
fi

available_packages=(
    "net-tools"                     # needed for ifconfig
    "tree"
    "which"
    "htop"
    "zsh"
    "kitty"
    "git"
    "build-essential"
    "bat"
    "python3"
    "python3-pip"
    "cargo"
    "locate"
    "apt-transport-https"
    "fd-find"
    "bat"
    "micro"
    "vim"
    "fzf"
    "xdg-utils"

    "texlive-full"
    "texlive-xetex"
    "latexmk"
    "biber"
    "entr"
    "fastfetch"
)

selected_packages=()
prompt_user_for_packages_dialog "Select packages to install:" available_packages selected_packages
log_info "Selected packages: ${selected_packages[@]}"

# Install packages one-by-one to pay close attention to what fails.
for pkg in "${selected_packages[@]}"
do
    install_apt_pkg $pkg
done

# Install Fira-Code fonts
dpkg-query -l fonts-firacode > /dev/null
resp_code=$(echo $?)
if [[ $resp_code != 0 ]]; then
    log_info "Install Fira Code font"
    sudo add-apt-repository universe
    sudo apt update
    sudo apt-get install fonts-firacode
fi
