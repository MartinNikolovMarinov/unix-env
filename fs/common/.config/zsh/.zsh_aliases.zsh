#!/bin/bash

## ALIASES

# htop specifics :
alias htop_cpu="htop -s PERCENT_CPU"
alias htop_io="htop -s IO_RATE"
alias htop_mem="htop -s PERCENT_MEM"

alias py="python3"
alias python="python3"
alias dir_size="du -sh"
alias ls='ls --color -h --group-directories-first'
alias ll="ls -s -h"
alias la="ls -la"
alias grep="grep --color=auto"
alias subl="setsid sublime_text"
alias bat="batcat --style=numbers --color=always --line-range :500"
alias neofetch="fastfetch"

alias strip_ansi="sed 's/\x1B\[[0-9;]\{1,\}[A-Za-z]//g'"
alias get_ipv4="ip addr show enp0s31f6 | grep -w inet | awk '{print $2}' | cut -f1 -d'/' | head -n 1"
alias filter_unique="awk !seen[$0]++ {print}"

alias kdiff="kitty +kitten diff"
alias kcat="kitty +kitten icat"
alias fzf="fzf -m"
alias trim="sed 's/^[ \t]*//;s/[ \t]*$//'"

alias op="xdg-open"
alias explorer="xdg-open"

alias objdump="objdump -M intel"

# Wayland specific
alias setclip="wl-copy"
alias pasteclip="wl-paste"
alias git_apply_from_clipboard='wl-paste | git apply --index -'
