# order matters !
export ZSH_HOME=~/.config/zsh

export PATH="$PATH:$(realpath ~)/.fzf/bin"
export PATH="$PATH:$(realpath ~)/.local/bin"
export PATH="$PATH:$(realpath ~)/bin"

# Load auto completion.
# autoload works like a lazy loader and loads copinit only when it is needed.
# It -U does not load aliases and also avoids name conflicts with other binaries.
autoload -Uz compinit; compinit -i

# load bash aliases :
[ -f $ZSH_HOME/.zsh_aliases.zsh ] && source $ZSH_HOME/.zsh_aliases.zsh
# load bash functions :
[ -f $ZSH_HOME/.zsh_functions.zsh ] && . $ZSH_HOME/.zsh_functions.zsh

# Setup a script that runs every time on exit.
trap "source \"$ZSH_HOME/.zshonexit.zsh\"" EXIT

# Auto complete dot files:
_comp_options+=(globdots) # With hidden files

# Load command coompletion:
[ -f $ZSH_HOME/.completion.zsh ] && source $ZSH_HOME/.completion.zsh
# Load prompt config:
[ -f $ZSH_HOME/.promptinit.zsh ] && source $ZSH_HOME/.promptinit.zsh
# Load syntax highlighting:
[ -f $ZSH_HOME/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source $ZSH_HOME/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load different completion zsh scripts:
[ -f $ZSH_HOME/.docker_completion.zsh ] && . $ZSH_HOME/.docker_completion.zsh

# Bind Ctrl + left/right to move left and right
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[3;5~" kill-word
bindkey "^H" backward-kill-word
