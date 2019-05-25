#!/usr/bin/env bash

if test ! "$( command -v brew )"; then
    echo "Installing homebrew"
    ruby -e "$( curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install )"
fi

echo -e "\\n\\nInstalling homebrew CASK packages..."
echo "=============================="

caskformula=(
    1password6 
    google-chrome 
    spotify 
    iterm2 
    visual-studio-code 
    # virtualbox
    adoptopenjdk8
    android-sdk 
    android-platform-tools 
    google-cloud-sdk 
)

brew tap caskroom/versions
for formula in "${caskformula[@]}"; do
    formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew cask list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed... skipping."
    else
        brew cask install "$formula"
    fi
done