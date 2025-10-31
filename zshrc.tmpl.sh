export USER=$(whoami)
export ZSH="/Users/${USER}/.oh-my-zsh"
export MAILCHECK=0

ZSH_THEME="robbyrussell"

plugins=(
  git # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
  z
)

DOTFILES_DIR=[[DOTFILES_DIR]]

# Iterate over files in aliases dir
ALIAS_DIR="${DOTFILES_DIR}/aliases"
source $ZSH/oh-my-zsh.sh
for f in "$ALIAS_DIR"/*
do 
  source $f
done

# Add scripts directory to PATH for direct execution
export PATH="${DOTFILES_DIR}/scripts:$HOME/.local/bin:$PATH"

export E="/volumes/External"
export EHOME=$E/$HOME
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"
