
DOTFILES=$HOME/.dotfiles

# IS_DARWIN=[ "$(uname)" == "Darwin" ]

section-title() {
    local text="$1"
    echo "            "
    echo "🚩 ➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖ 🚩"
    echo "✨    ${text}   ✨"    
    echo "🚩 ➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖ 🚩"
}

brew-ensure() {
    local formula="$1"
    local formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed... skipping."
    else
        brew install "$formula"
    fi    
}

brew-ensure-list() {
    local formulas=("$@")
    for formula in "${formulas[@]}"; do
        brew-ensure "$formula"
    done
}

brew-cask-ensure() {
    local formula="$1"
    local formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew cask list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed... skipping."
    else
        brew cask install "$formula"
    fi
}

brew-cask-ensure-list() {
    local formulas=("$@")
    for formula in "${formulas[@]}"; do
        brew-cask-ensure "$formula"
    done
}

symlink-ensure() {
    local file="$DOTFILES/$1.symlink"
    local target="$HOME/.$( basename "$file" '.symlink' )"
    if [ -e "$target" ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for ~${target#$HOME}"
        ln -s "$file" "$target"
    fi
}

link-ensure() {
    local file="$1"
    local target="$2"
    if [ -e "${target}" ]; then
        echo "${target} already exists... Skipping."
    else
        echo "Creating symlink for $target"
        ln -s "$file" "$target"
    fi
}

customize-gitconfig() {
  defaultName=$( git config --global user.name )
  defaultEmail=$( git config --global user.email )
  defaultGithub=$( git config --global github.user )

  read -rp "Name [$defaultName] " name
  read -rp "Email [$defaultEmail] " email
  read -rp "Github username [$defaultGithub] " github

  git config --global user.name "${name:-$defaultName}"
  git config --global user.email "${email:-$defaultEmail}"
  git config --global github.user "${github:-$defaultGithub}"

  if [[ "$( uname )" == "Darwin" ]]; then
      git config --global credential.helper "osxkeychain"
  else
      read -rn 1 -p "Save user and password to an unencrypted file to avoid writing? [y/N] " save
      if [[ $save =~ ^([Yy])$ ]]; then
          git config --global credential.helper "store"
      else
          git config --global credential.helper "cache --timeout 3600"
      fi
  fi  
}