# Arch specific
alias bat="bat --style=numbers --color=always --line-range :500"
alias neofetch="fastfetch"
alias pacman_clean_cache="paccache -ruk0 && paccache -rk3" # keep at most 3 versions and clear cache for unistalled packages.
alias pacman_autoremove="sudo pacman -Rns $(pacman -Qdtq)" # delete orphans
