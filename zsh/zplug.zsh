export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Define TERMINAL colors w/ a script (and fix them)
zplug 'chriskempson/base16-shell'

# https://github.com/zdharma/fast-syntax-highlighting
# Syntax-highlighting for Zshell (similar to what fish does)
zplug 'zdharma/fast-syntax-highlighting', defer:2

zplug 'zsh-users/zsh-autosuggestions'
zplug "zsh-users/zsh-completions"

# Change iTerm Tab colors based on current directoy
zplug "tysonwolker/iterm-tab-colors"

export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
# export NVM_NO_USE=true
zplug 'lukechilds/zsh-nvm'   # LOADS nvm


# https://github.com/iam4x/zsh-iterm-touchbar
# Display feedback of the terminal in the Touchbar
# export TOUCHBAR_GIT_ENABLED=true
# export YARN_ENABLED=true
# zplug 'iam4x/zsh-iterm-touchbar'

# https://github.com/changyuheng/fz
zplug "changyuheng/fz"

# https://github.com/urbainvaes/fzf-marks
# Set bookmarks on directory to easy cd to them later (uses fzf)
zplug "urbainvaes/fzf-marks"

############################################
# Themes
############################################

# Local one: Works ok, but is slow
# zplug "${ZSH}", use:'prompt.zsh', from:local

# Spaceship: Feature bloated, really slow
# https://denysdovhan.com/spaceship-prompt/
# zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

# Pure Theme: Really Fast, minimalist (i wanted more colors :S)
# zplug mafredri/zsh-async, from:github
# zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

# Powerlevel10k (fork from Powerlevel9k).
# Lot of configuration options, but quite fast
# Using purepower theme (https://raw.githubusercontent.com/romkatv/dotfiles-public/master/.purepower)
zplug "romkatv/powerlevel10k", use:powerlevel10k.zsh-theme, hook-load:"source $ZSH/powerlevel10k-setup.zsh"


if ! zplug check; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
