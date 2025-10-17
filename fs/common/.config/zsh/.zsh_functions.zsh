#!/bin/bash

# load last directory location and store it in lastdir variable:
[ -f ~/.config/zsh/.bash_lastdir ] && [ -e "$(cat ~/.config/zsh/.bash_lastdir)" ] && lastdir=$(cat ~/.config/zsh/.bash_lastdir)

## FUNCTIONS :

# save pwd on change directory :
function cd() {
    lastdir=$(pwd)
    builtin cd $@ && echo $(pwd) > ~/.config/zsh/.bash_lastdir && ls
}

function path_print() {
    tmpPath=$PATH
    buffer=$(echo $tmpPath | tr ":" "\n")
    for i in "${buffer[@]}"
    do
        echo $i
    done
}

function path_sorted() {
    tmpPath=$(path_print)
    echo "${tmpPath}" | sort
}

# smart cat:
function cat() {
    if [[ "$#" -eq 1 ]]; then
        local extToLower=$(echo $1 | awk -F . '{if (NF>1) {print }}')
        if [[ ( $extToLower == *.png ) || ( $extToLower == *.jpg ) || ( $extToLower == *.jpeg ) || ( $extToLower == *.bmp ) || ( $extToLower == *.svg ) ]]; then
            command kitty +kitten icat "$@"
            return
        elif [[ ( $extToLower == *.md ) ]]; then
            bat "$@"
            return
        fi
    fi

    command cat "$@"
}

# git :
function git() {
    if [[ ( $# == 1 ) && ( $1 == "log" ) ]]; then
        command git log --graph --pretty=oneline --abbrev-commit --color=always
    else
        command git "$@"
    fi
}

function check_exit_code() {
    if [ $? -ne 0 ]; then
        echo "[FAILED]"
        exit 1
    fi
}

function remove_git_submodule() {
    if [ $# -ne 1 ]; then
        echo "Usage: remove_git_submodule.sh <submodule_path>"
        exit 1
    fi

    # Check if the .gitmodules file exists
    if [ ! -f .gitmodules ]; then
        echo "No .gitmodules file found"
        exit 1
    fi

    # Remove from .gitmodules
    git config -f .gitmodules --remove-section submodule.$1
    check_exit_code

    # Stage the .gitmodules changes
    git add .gitmodules
    check_exit_code

    # Remove from .git/config
    git config -f .git/config --remove-section submodule.$1
    check_exit_code

    # Remove the submodule files from the working tree and index
    git rm --cached $1
    check_exit_code

    # Remove the submodule's .git directory
    rm -rf ./git/modules/$1
    check_exit_code

    # Commit the changes
    git commit -m "Removed submodule $1"
    check_exit_code

    # Delete the now untracked submodule files
    rm -rf $1
    check_exit_code
}

# Encrypt and compress with password using 7z:
function encrypt_with_pass_7z() {
    # $1 -> source folder/file
    # $2 -> destination 7z file
    7z a -mhe=on -p "$2" "$1"
    # prompts for password
}

# Decrypt and decompress with 7z:
function decrypt_7z() {
    # $1 -> source 7z file
    # $2 -> destination folder
    7z x "$1" -o"$2"
    # prompts for password
}

# Generate random data
function generate_random_data() {
    if [ -z "$1" ]; then
        echo "Error: Size in MB must be specified"
        return 1
    fi

    local size_mb=$1
    local size_bytes=$((size_mb * 1024 * 1024))

    if (( size_bytes < 64 * 1024 * 1024 )); then
        # For sizes less than 64MB, use a smaller block size
        dd if=/dev/urandom bs=1M count=$((size_bytes / (1024 * 1024))) | base64 | tr -dc 'a-zA-Z' | head -c "$size_bytes"
    else
        # For sizes 64MB and larger
        dd if=/dev/urandom bs=64M count=$((size_bytes / (64 * 1024 * 1024))) | base64 | tr -dc 'a-zA-Z' | head -c "$size_bytes"
    fi
}

# Clean zsh history file
function clean_history () {
    local tmp_hist_file=$(printf "$HISTFILE"_tmp)
    cat $HISTFILE | sed '/Microsoft-MIEngine/d' | awk '!x[$0]++' > tmp_hist_file && cat tmp_hist_file > $HISTFILE && rm tmp_hist_file
}

function repeat_if_no_error() {
    local count=$1
    shift
    for i in {1..$count}; do
        eval $@
        if [ $? -ne 0 ]; then
            echo "\033[31mError: Command failed\033[0m"
            return 1
        fi
    done
}

function codec_detect() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: detect_codec <input_file>"
        return 1
    fi

    local input="$1"

    if [[ ! -f "$input" ]]; then
        echo "❌ Error: '$input' not found."
        return 1
    fi

    local codec
    codec=$(ffprobe -v error -select_streams v:0 \
            -show_entries stream=codec_name \
            -of default=noprint_wrappers=1:nokey=1 "$input")

    if [[ -n "$codec" ]]; then
        echo "Video codec for '$input': $codec"
    else
        echo "⚠️  No video stream detected in '$input'"
    fi
}

function codec_convert_to_h264() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: convert_to_h264 <input_file> [crf (default 20)]"
        return 1
    fi

    local input="$1"
    local crf="${2:-20}"
    local base="${input%.*}"
    local output="${base}_h264.mp4"

    if [[ ! -f "$input" ]]; then
        echo "❌ Error: '$input' not found."
        return 1
    fi

    # Detect codec
    local codec
    codec=$(ffprobe -v error -select_streams v:0 \
            -show_entries stream=codec_name \
            -of default=noprint_wrappers=1:nokey=1 "$input")

    echo "Detected video codec: $codec"

    # Skip if already H.264
    if [[ "$codec" == "h264" ]]; then
        echo "✅ '$input' is already H.264 — skipping conversion."
        return 0
    fi

    echo "Converting '$input' → '$output' (CRF=$crf)..."
    ffmpeg -i "$input" -map 0 -c:v libx264 -preset slow -crf "$crf" \
           -c:a aac -b:a 192k -movflags +faststart -c:s copy "$output"

    if [[ $? -eq 0 ]]; then
        echo "✅ Conversion complete: $output"
    else
        echo "❌ Conversion failed for: $input"
    fi
}

# FZF functionality
[ -f ~/.config/zsh/.fzf_functionality.zsh ] && source ~/.config/zsh/.fzf_functionality.zsh
