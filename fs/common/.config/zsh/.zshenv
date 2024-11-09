export EDITOR=micro
export VISUAL=micro

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export ZDOTDIR="$HOME/.config/zsh"

export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

export LESSHISTSIZE=0 # No need to store history for less
export PYTHONSTARTUP=~/.config/python/pythonrc # Place pythonrc here

setopt HIST_IGNORE_ALL_DUPS      # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS         # do not save duplicated command
setopt HIST_REDUCE_BLANKS        # remove unnecessary blanks
# setopt INC_APPEND_HISTORY_TIME # append command to history file immediately after execution
# setopt EXTENDED_HISTORY        # record command start time
