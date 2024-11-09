#!/bin/bash

export BASE_DIR=$(echo "$PWD")

git submodule init
git submodule update

export TARGET_UNIX="linux-gnu"
bash $BASE_DIR/scripts/debian/install.sh
