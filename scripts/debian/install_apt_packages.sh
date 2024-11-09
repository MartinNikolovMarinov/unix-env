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

log_info "Packages that will be installed"
apt_packages_basic_dev_deps=(
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
)
apt_packages_x_server_deps=(
    "xdg-utils"     # needed for xdg-open
)
apt_packages_latex=(
    "texlive-full"
    "texlive-xetex"
    "latexmk"
    "biber"
    "entr"
)
log_info "apt_packages_basic_dev_deps:\n\t${apt_packages_basic_dev_deps[@]}"
log_info "apt_packages_x_server_deps:\n\t${apt_packages_x_server_deps[@]}"
log_info "apt_packages_latex:\n\t${apt_packages_latex[@]}"

echo -n "Start install"
prompt_user_yes_no

for pkg in "${apt_packages_basic_dev_deps[@]}"
do
	install_apt_pkg $pkg
done
for pkg in "${apt_packages_x_server_deps[@]}"
do
	install_apt_pkg $pkg
done
for pkg in "${apt_packages_latex[@]}"
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
