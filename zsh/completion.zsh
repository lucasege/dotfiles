

# Add Completions from zsh packages (git, brew & others)
# From https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
    fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

# initialize autocomplete
autoload -U compinit add-zsh-hook
compinit

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate



