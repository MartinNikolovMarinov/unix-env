#!/bin/bash

export BASE_DIR=$(echo "$PWD")
export TARGET_UNIX="linux-gnu"

git submodule init
git submodule update

source $BASE_DIR/scripts/common/utils.sh

bash $BASE_DIR/scripts/debian/install.sh
