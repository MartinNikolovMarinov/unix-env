#!/bin/bash

export BASE_DIR=$(echo "$PWD")

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export TARGET_UNIX="linux-gnu"
    bash $BASE_DIR/linux-debian/scripts/install.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export TARGET_UNIX="darwin"
    echo "Not supported yet."
    exit 1
else
    echo "OS not supported."
    exit 1
fi