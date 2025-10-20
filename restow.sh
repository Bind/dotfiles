#!/bin/bash

set -e

echo "Restowing all config packages..."

cd config

stow -t ~/.config/nvim -R nvim
stow -t ~/.config/ghostty -R ghostty
stow -t ~/.config/tmux -R tmux

echo "Done!"