#!/bin/bash

set -euo pipefail

export OUTPUT_DIRECTORY=$HOME
export BASE_DIR=$(echo "$PWD")
source $BASE_DIR/scripts/common/utils.sh

[ -z "${OUTPUT_DIRECTORY}" ] && { log_err "failed to set the OUTPUT_DIRECTORY"; exit 1; }

if command -v pacman >/dev/null 2>&1; then
    package_manager="pacman"
elif command -v apt >/dev/null 2>&1; then
    package_manager="apt"
else
    log_err "No packman or apt detected. Unsupported package manager!"
    exit 1
fi

prompt_user_to_continue "Are you sure you want to start the installation script from '${BASE_DIR}'?"

# Example usage:
if [[ "$package_manager" == "pacman" ]]; then
    source $BASE_DIR/scripts/arch/install.arch.sh
elif [[ "$package_manager" == "apt" ]]; then
    source $BASE_DIR/scripts/debian/install.debian.sh
fi
