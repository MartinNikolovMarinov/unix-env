#!/bin/bash

set +e +u +o pipefail # Some of the commands in install packages are allowed to fail:
source $BASE_DIR/scripts/arch/install_arch_packages.sh
set -euo pipefail

# Install Desktop envoronment
available_desktop_environments=(
    "sway"
    "kde"
    "gnome"
)
export SELECTED_DESKTOP_ENVIRONMENT=1
prompt_user_radio_select_dialog "Select a desktop environment:" SELECTED_DESKTOP_ENVIRONMENT available_desktop_environments
case $SELECTED_DESKTOP_ENVIRONMENT in
    0)
        # Sway
        source $BASE_DIR/scripts/arch/install_sway.sh
        ;;
    1)
        # Kde
        source $BASE_DIR/scripts/arch/install_kde.sh
        ;;
    2)
        # Gnome
        source $BASE_DIR/scripts/arch/install_gnome.sh
        ;;
    *)
        log_info "No desktop environment selected"
        exit 1
        ;;
esac

source $BASE_DIR/scripts/arch/setup_arch_env.sh
