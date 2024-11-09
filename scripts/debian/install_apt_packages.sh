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

sudo update
sudo apt-get install dialog # Will need this for the next step

available_packages=(
    "net-tools"                     # needed for ifconfig
    "tree"
    "htop"
    "zsh"
    "kitty"
    "git"
    "build-essential"
    "bat"
    "python3"
    "cargo"
    "locate"
    "apt-transport-https"
    "fd-find"
    "bat"
    "micro"
    "fzf"
    "xdg-utils"

    "texlive-full"
    "texlive-xetex"
    "latexmk"
    "biber"
    "entr"
)

selected_packages=()
prompt_user_for_packages "Select packages to install:" available_packages selected_packages
log_info "Selected packages: ${selected_packages[@]}"

echo -n "Start install"
prompt_user_yes_no

for pkg in "${selected_packages[@]}"
do
    install_apt_pkg $pkg
done

which pip
resp_code=$(echo $?)
if [[ $resp_code != 0 ]]; then
    log_info "Installing python pip"
    python3 -m pip install pip
fi

dpkg-query -l fonts-firacode > /dev/null
resp_code=$(echo $?)
if [[ $resp_code != 0 ]]; then
    log_info "Install Fira Code font"
    sudo add-apt-repository universe
    sudo apt update
    sudo apt-get install fonts-firacode
fi

dpkg-query -l sublime-text > /dev/null
resp_code=$(echo $?)
if [[ $resp_code != 0 ]]; then
    log_info "Install sublime text"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    install_apt_pkg sublime-text
fi
