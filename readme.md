# Setup Dotfiles on a new machine

## Quick Install
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What the install script does:
1. **Zsh Configuration** - Sets up ~/.zshrc with dynamic paths
2. **Config Management** - Uses stow to link configuration files:
   - nvim → ~/.config/nvim
   - ghostty → ~/.config/ghostty  
   - tmux → ~/.config/tmux
3. **Brew Packages** - Optionally installs packages from Brewfile

## Dependencies
- **stow** - For configuration management (`brew install stow`)
- **homebrew** - For package management (optional)

## Manual Management
```bash
cd ~/dotfiles/stow

# Link all configs
stow -t ~ nvim ghostty tmux

# Link individual config
stow -t ~ nvim

# Unlink config
stow -t ~ -D nvim
```
