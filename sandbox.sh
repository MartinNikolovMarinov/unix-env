#!/bin/bash

# File for writing experimental scripts

function write_or_append_to_file() {
    local file="$1"
    local content="$2"

    if [[ -e "$file" ]]; then
        echo "$content" >> "$file"  # Append if file exists
    else
        echo "$content" > "$file"   # Write if file does not exist
    fi
}

function sync_fs_tree() {
    local src_dir="$1"
    local dest_dir="$2"

    if [[ ! -d "$src_dir" ]]; then
        echo "Error: $src_dir is not a valid directory."
        return 1
    fi

    # Ensure the destination directory exists
    mkdir -p "$dest_dir"

    find "$src_dir" -print0 | while IFS= read -r -d '' item; do
        local dest_item="$dest_dir/$item"
        if [[ -d "$item" ]]; then
            echo "Creating Directory: $item -> $dest_item"
            mkdir -p "$dest_item"
        elif [[ -f "$item" ]]; then
            echo "Creating File: $item -> $dest_item"
            write_or_append_to_file "$dest_item" "$(cat $item)"
        fi
    done
}


pushd "./fs/sway"
sync_fs_tree ".config" "../../fs2"
popd
