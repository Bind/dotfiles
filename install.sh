#!/bin/sh
#Needs to be refactored

if [[ $(command -v brew) == "" ]]; then 
    echo "Install Homebrew before running install.sh"
    echo 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
else

source ./config.sh
echo $DOTFILES_DIR
mkdir $DOTFILES_DIR


FILES=~/dotfiles/aliases/*.sh
for f in $FILES
do
  echo "Processing $f file..."
  # take action on each file. $f store current file name
  filename=$(basename -- $f)
  ln $f $DOTFILES_DIR/$filename
done

# sed 's/[[DOTFILES_DIR]]/${DOTFILES_DIR}/g' ./zshrc.tmpl.sh | tee ~/.zshrc

# ln .profile.sh ~/.dotfiles/.profile.sh
# ln .prompt.sh ~/.dotfiles/.prompt.sh
# ln .python.sh ~/.dotfiles/.python.sh
# ln .zshrc ~/.zshrc
