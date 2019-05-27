setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
#setopt IGNORE_EOF
setopt PROMPT_SUBST

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# history
setopt HIST_VERIFY
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS

setopt    extended_history       # record timestamp of command in HISTFILE
setopt    sharehistory      #Share history across terminals
setopt    hist_ignore_space      # ignore commands that start with space

setopt COMPLETE_ALIASES