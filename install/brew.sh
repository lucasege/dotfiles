#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles
source "${DOTFILES}/install/library.sh"

section-title "Check homebrew"
if ! command -v brew > /dev/null 2>&1; then
    echo "Installing homebrew"
    ruby -e "$( curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install )"
else
    echo "Homebrew already installed!"
fi

# Tap for OS X Applications
brew tap caskroom/versions
# Tap for fonts
brew tap homebrew/cask-fonts

section-title "Install & Setup ZSH as user's shell"
brew-ensure "zsh"
brew-ensure "zplug"
symlink-ensure "zsh/zshrc"

# Change the default shell to zsh
zsh_path="$( command -v zsh )"
if ! grep "$zsh_path" /etc/shells; then
    echo "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    echo "default shell changed to $zsh_path"
fi

section-title "Setup GIT"
brew-ensure "git"
brew-ensure "hub"
brew-ensure "diff-so-fancy"
symlink-ensure "git/gitconfig"
symlink-ensure "git/gitignore_global"
customize-gitconfig


section-title "Ensure Install fzf"
brew-ensure "ripgrep"   # We use ripgrep for fzf
brew-ensure "fzf"
/usr/local/opt/fzf/install --all --no-bash --no-fish
symlink-ensure "rgrc"


section-title "Setup Vim/NeoVim"
brew-ensure "python"
mkdir -p "$HOME/.config"

section-title "Everyday Dev Packages"
dev_formulas=(
    # cat with syntax highlight
    bat
    dnsmasq    
    highlight
    markdown
    mas
    trash
    tree
    wget
    # replacement for find (https://github.com/sharkdp/fd)
    fd 
    git-standup
    entr
    jq
)
brew-ensure-list "${dev_formulas[@]}"

section-title "Node Development Packages"
node_formulas=(
    # nvm  #  NVM is installed by zplug plugin lukechilds/zsh-nvm
    yarn 
    watchman
)
brew-ensure-list "${node_formulas[@]}"
symlink-ensure "node/eslintrc"


section-title "Installing Fonts"
brew-cask-ensure font-firamono-nerd-font # We use this for iterm2
