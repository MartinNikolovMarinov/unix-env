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

# Install YaY from a verified source checkout
if prompt_user_confirm "Do you want to install yay from source?"; then
    log_info "Installing AUR yay from a pinned commit"

    : "${YAY_REPOSITORY_URL:=https://aur.archlinux.org/yay.git}"
    if [[ -z "${YAY_VERIFIED_COMMIT:-}" ]]; then
        log_err "YAY_VERIFIED_COMMIT environment variable must be set to a reviewed commit hash before installing yay." "error"
        log_info "Review the upstream PKGBUILD and export YAY_VERIFIED_COMMIT=<trusted commit hash> before re-running this step."
        exit 1
    fi

    yay_temp_dir=$(mktemp -d)
    trap 'rm -rf "${yay_temp_dir}"' EXIT

    if ! git -C "${yay_temp_dir}" init >/dev/null; then
        log_err "Failed to initialise temporary git repository for yay." "error"
        exit 1
    fi

    git -C "${yay_temp_dir}" remote add origin "${YAY_REPOSITORY_URL}" >/dev/null
    if ! git -C "${yay_temp_dir}" fetch --depth 1 origin "${YAY_VERIFIED_COMMIT}"; then
        log_err "Unable to fetch yay commit ${YAY_VERIFIED_COMMIT}. Verify the commit hash and network connectivity." "error"
        exit 1
    fi

    if ! git -C "${yay_temp_dir}" checkout --detach "${YAY_VERIFIED_COMMIT}" >/dev/null; then
        log_err "Unable to checkout yay commit ${YAY_VERIFIED_COMMIT}." "error"
        exit 1
    fi

    resolved_commit=$(git -C "${yay_temp_dir}" rev-parse HEAD)
    if [[ "${resolved_commit}" != "${YAY_VERIFIED_COMMIT}" ]]; then
        log_err "Resolved yay commit ${resolved_commit} does not match expected ${YAY_VERIFIED_COMMIT}. Aborting." "error"
        exit 1
    fi

    pushd "${yay_temp_dir}" >/dev/null
        if ! makepkg --syncdeps --needed --clean --verifysource; then
            log_err "yay source verification failed." "error"
            exit 1
        fi

        if ! makepkg --syncdeps --needed --clean --install --noconfirm; then
            log_err "Failed to build and install yay." "error"
            exit 1
        fi
    popd >/dev/null
    rm -rf "${yay_temp_dir}"
    trap - EXIT
fi

# Install Desktop envoronment
available_desktop_environments=(
    "sway"
    "kde"
    "gnome"
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
    2)
        # Gnome
        source $BASE_DIR/scripts/arch-wayland/install_gnome.sh
        ;;
    *)
        log_info "No desktop environment selected"
        exit 1
        ;;
esac
