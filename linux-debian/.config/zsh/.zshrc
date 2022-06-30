# order matters !
export ZSH_HOME=~/.config/zsh

export PATH="$PATH:$(realpath ~)/.cargo/bin"
export PATH="$PATH:$(realpath ~)/.fzf/bin"
export PATH="$PATH:$(realpath ~)/.local/bin"
export PATH="$PATH:$(realpath ~)/bin"

# Load auto completion.
# autoload works like a lazy loader and loads copinit only when it is needed.
# It -U does not load aliases and also avoids name conflicts with other binaries.
autoload -Uz compinit; compinit -i

# load bash aliases :
[ -f $ZSH_HOME/.zsh_aliases ] && source $ZSH_HOME/.zsh_aliases
# load bash functions :
[ -f $ZSH_HOME/.zsh_functions ] && . $ZSH_HOME/.zsh_functions

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

# Setup Directory stack:
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
