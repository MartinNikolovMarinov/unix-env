# order matters !
export ZSH_HOME=~/.config/zsh

export PATH="$PATH:/Users/mamarinov/bin"
export PATH="$PATH:/usr/local/opt/util-linux/bin"
export PATH="$PATH:/Applications/Sublime Text.app/Contents/MacOS"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

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

# Load fzf (can't find much use for fzf auto-completion but this can turn it on):
# Auto-completion
# ---------------
# [[ $- == *i* ]] && source "/usr/local/Cellar/fzf/0.27.2/shell/completion.zsh" 2> /dev/null
# Key bindings
# ------------
# source "/usr/local/Cellar/fzf/0.27.2/shell/key-bindings.zsh"

# Load different completion zsh scripts:
[ -f $ZSH_HOME/.docker_completion.zsh ] && . $ZSH_HOME/.docker_completion.zsh 
# [ -x "$(command -v kubectl)" ] && source <(kubectl completion zsh)

# Bind Ctrl + left/right to move left and right
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey "^[[1;9D" beginning-of-line
bindkey "^[[1;9C" end-of-line

# Setup zsh history options
setopt share_history		# Allows multiple shell sessions to write to the same zsh history file and appends commands immediately before execution.
setopt histignorealldups	# Do not save duplicate commands in the zsh history file

# Setup Directory stack:
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index
