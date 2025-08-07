#!/bin/bash

# load last directory location and cd into it :
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

# Compress and encrypt with password using zip:
function zip_with_pass() {
    # $1 -> destination zip file
    # $2 -> source folder
    zip -re $2 $1
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

# Note management:
function note_create() {
    # command 1 search for all directories in ~/notes. If there are no directories print "",which is a hack to make the next command work.
    # command 2 add an option for new notes directory
    # command 3 actual fzf command
    local result=$(fd --type=directory . ~/notes | (grep . || echo "") | awk 'NR==1{print "new directory"}1' | fzf -m)

    if [[ -z $result ]]; then
        echo Canceled
        return
    fi

    local note_dir=""
    local note_name=""
    local tmp=""

    if [[ "$result" == "new directory" ]]; then
        vared -p "Enter directory name: " -c tmp
        note_dir=$(echo ~/notes/$tmp)
        echo Creating directory: $note_dir
        mkdir -p $note_dir
    else
        note_dir=$result
    fi

    tmp=""
    vared -p "Enter note name: " -c tmp
    note_name=$(echo $tmp)
    echo Creating note file: $note_dir/$note_name
    micro $note_dir/$note_name
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

# FZF functionality
[ -f ~/.config/zsh/.fzf_functionality.zsh ] && source ~/.config/zsh/.fzf_functionality.zsh
