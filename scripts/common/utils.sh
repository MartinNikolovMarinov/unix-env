#!/bin/bash

function log_err() {
    if [[ -n $1 ]]; then
        echo
        echo -e "[ERROR] $@"
        echo
    fi
}

function log_info() {
    if [[ -n $1 ]]; then
        echo
        echo -e "[INFO] $@"
        echo
    fi
}

function write_or_append_to_file() {
    local file="$1"
    local content="$2"

    if [[ -e "$file" ]]; then
        echo "$content" >> "$file"  # Append if file exists
    else
        echo "$content" > "$file"   # Write if file does not exist
    fi
}

function copy_or_append_files {
    local src_dir="$1"
    local dest_dir="$2"

    # Ensure the destination directory exists
    mkdir -p "$dest_dir"

    for src_file in "$src_dir"/*; do
        local dest_file="$dest_dir/$(basename "$src_file")"

        if [[ -d "$src_file" ]]; then
            echo "Processing directory $src_file -> $dest_file"
            copy_or_append_files "$src_file" "$dest_file"  # Recurse into subdirectory
        else
            echo "Processing file $src_file -> $dest_file"
            write_or_append_to_file "$dest_file" "$(cat "$src_file")"
        fi
    done
}

function prompt_user_yes_no {
    while true; do
        read -p "$* [y/n]: " yn
        case $yn in
            [Yy]*) return 0  ;;
            [Nn]*) log_err "Aborted" ; exit 0 ;;
        esac
    done
}

function prompt_user_choice {
    local choice
    local i=1
    local title="$1"

    shift  # Shift arguments to remove the title from $@

    log_info "$title"
    for opt in "$@"; do
        echo "  $i) $opt"
        ((i++))
    done

    echo

    while true; do
        read -p "Enter your choice [1-$#]: " choice
        if [[ $choice -ge 1 && $choice -le $# ]]; then
            log_info "You selected: ${!choice}"
            return $choice
        else
            log_err "Invalid choice. Please select a number between 1 and $#."
        fi
    done
}
