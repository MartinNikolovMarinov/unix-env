#!/bin/bash

function install_brew_pkg() {
    if [[ -n $1 ]]; then
        brew install $1
        local resp_code=$(echo $?)
        if [[ $resp_code != 0 ]]; then
            log_err "Install of $1 brew package failed with exit code: $resp_code" "error"
            return -1
        fi
    fi

    return 0
}

which brew
resp_code=$(echo $?)
if [[ $resp_code != 0 ]]; then
    log_info "Brew is missing installing"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

log_info "Packages that will be installed"
brew_packages_basic=(
    "tree"
    "mdcat"
    "wget"
    "htop"
    "git"
    "glib"
    "watch"
    "neofetch"
    "bat"
    "fd"
    "bat"
    "micro"
    "fzf"
    "coreutils"
    "findutils"
    "gnu-tar"
    "gnu-sed"
    "gawk"
    "gnutls"
    "gnu-indent"
    "gnu-getopt"
    "grep"
)
brew_casks=( 
    "kitty"
)

log_info "brew_packages_basic:\n\t${brew_packages_basic[@]}"
log_info "brew_casks:\n\t${brew_casks[@]}"

echo -n "Start install"
prompt_user_yes_no

for pkg in "${brew_packages_basic[@]}"
do
    brew ls --versions $pkg
    resp_code=$(echo $?)
    if [[ $resp_code != 0 ]]; then
	    install_brew_pkg $pkg
    fi
done

for cc in "${brew_casks[@]}"
do
    brew info $cc > /dev/null
    resp_code=$(echo $?)
    if [[ $resp_code != 0 ]]; then
	    brew install --cask $cc
    fi
done


which pip3
resp_code=$(echo $?)
if [[ $resp_code != 0 ]]; then
    log_info "Installing python pip"
    python3 -m pip install pip
fi