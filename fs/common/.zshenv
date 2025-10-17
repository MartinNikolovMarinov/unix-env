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

# Define History Behavior
setopt HIST_IGNORE_ALL_DUPS      # remove older duplicates
setopt HIST_SAVE_NO_DUPS         # don’t write duplicates to file
setopt HIST_REDUCE_BLANKS        # strip extra spaces
setopt HIST_IGNORE_SPACE         # skip commands starting with space
setopt APPEND_HISTORY            # append instead of overwrite
unsetopt SHARE_HISTORY           # prevent live merging (avoid race)
unsetopt INC_APPEND_HISTORY_TIME # no timestamps
unsetopt EXTENDED_HISTORY        # no timestamps
