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

# Iterate over files in scripts dir
SCRIPTS_DIR="${DOTFILES_DIR}/scripts"
for f in "$SCRIPTS_DIR"/*
do 
  alias $(basename $f | cut -f 1 -d '.')=$f
done

export E="/volumes/External"
export EHOME=$E/$HOME
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
