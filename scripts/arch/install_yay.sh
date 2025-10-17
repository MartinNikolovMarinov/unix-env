#!/bin/bash

# Install YaY from a verified source checkout
if prompt_user_confirm_dialog "Do you want to install yay from source?"; then
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
