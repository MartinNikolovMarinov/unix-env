#!/bin/bash

set +e +u +o pipefail # Some of the commands in install packages are allowed to fail:
source $BASE_DIR/scripts/debian/install_apt_packages.sh
set -euo pipefail

source $BASE_DIR/scripts/debian/install_gnome.sh
source $BASE_DIR/scripts/debian/setup_debian_env.sh
