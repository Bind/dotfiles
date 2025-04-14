#!/bin/sh
RAW_DIR=$(pwd)
DOTFILES_DIR="${RAW_DIR//\//\\/}"
TMPL_STRING="\[\[DOTFILES_DIR\]\]"
sed "s/${TMPL_STRING}/${DOTFILES_DIR}/g" ./zshrc.tmpl.sh | tee ~/.zshrc
ln -f ~/.zshrc ./live-zshrc-symlink