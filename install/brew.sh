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
brew-ensure "neovim"
brew-ensure "vim"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.vim-tmp"
link-ensure "$DOTFILES/nvim" "$HOME/.config/nvim"
link-ensure "$DOTFILES/nvim" "$HOME/.vim"  
link-ensure "$DOTFILES/nvim/init.vim" "$HOME/.vimrc"  
pip2 install --user neovim
pip3 install --user neovim

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


section-title "GO Development Packages"
go_formulas=(
    go
)
brew-ensure-list "${go_formulas[@]}" 

section-title "Installing Fonts"
brew-cask-ensure font-fira-code          # We use this for vscode w/ligatures
brew-cask-ensure font-firamono-nerd-font # We use this for iterm2

section-title "Installing Everyday Apps"
brew-cask-ensure google-chrome
brew-cask-ensure spotify
brew-cask-ensure iterm2
brew-cask-ensure visual-studio-code

section-title "Installing Android Development Apps"
brew-cask-ensure adoptopenjdk8
brew-cask-ensure android-sdk
brew-cask-ensure android-platform-tools
brew-cask-ensure android-studio

section-title "Installing GCloud Apps"
brew-cask-ensure google-cloud-sdk