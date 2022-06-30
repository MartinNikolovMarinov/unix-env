export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export EDITOR=micro
export VISUAL=micro

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export HISTFILE="$ZDOTDIR/.zhistory"    # History filepath
export HISTSIZE=100000                  # Maximum events for internal history
export SAVEHIST=100000                  # Maximum events in history file

setopt HIST_IGNORE_ALL_DUPS      # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS         # do not save duplicated command
setopt HIST_REDUCE_BLANKS        # remove unnecessary blanks
# setopt INC_APPEND_HISTORY_TIME # append command to history file immediately after execution
# setopt EXTENDED_HISTORY        # record command start time

export PYTHONSTARTUP=~/.config/zsh/pythonrc # Place pythonrc here
