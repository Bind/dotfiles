#!/bin/bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main installation function
main() {
    log "Starting dotfiles installation..."
    
    # Get current directory
    DOTFILES_DIR=$(pwd)
    log "Dotfiles directory: $DOTFILES_DIR"
    
    # Check if we're in the right directory
    if [[ ! -f "$(pwd)/zshrc.tmpl.sh" ]]; then
        error "Please run this script from the dotfiles directory"
        exit 1
    fi
    
    # 1. Setup Zsh configuration (existing functionality from setup_zsh.sh)
    log "Setting up Zsh configuration..."
    setup_zsh
    
    # 2. Check for stow
    if ! command_exists stow; then
        warning "stow not found. Install it with: brew install stow"
        warning "Skipping stow package installation"
    else
        # 3. Setup stow packages
        log "Setting up configuration files with stow..."
        setup_stow_packages
    fi
    
    # 4. Optional: Install Brew packages
    if command_exists brew; then
        read -p "Install Brew packages from Brewfile? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log "Installing Brew packages..."
            brew bundle
            success "Brew packages installed"
        fi
    else
        warning "Homebrew not found. Install it first to use Brewfile"
    fi
    
    success "Dotfiles installation complete!"
    success "Restart your terminal or run 'source ~/.zshrc' to apply changes"
}

# Setup Zsh configuration (from setup_zsh.sh)
setup_zsh() {
    RAW_DIR=$(pwd)
    DOTFILES_DIR_ESCAPED="${RAW_DIR//\//\\/}"
    TMPL_STRING="\[\[DOTFILES_DIR\]\]"
    
    log "Generating ~/.zshrc from template..."
    sed "s/${TMPL_STRING}/${DOTFILES_DIR_ESCAPED}/g" ./zshrc.tmpl.sh > ~/.zshrc
    
    log "Creating symlink for live zshrc..."
    ln -sf ~/.zshrc ./live-zshrc-symlink
    
    success "Zsh configuration setup complete"
}

# Setup stow packages for configuration files
setup_stow_packages() {
    cd stow
    
    # Available packages
    PACKAGES=("nvim" "ghostty" "tmux")
    
    for package in "${PACKAGES[@]}"; do
        if [[ -d "$package" ]]; then
            log "Installing $package configuration..."
            
            # Check for existing config and back it up
            config_path="$HOME/.config/$package"
            if [[ -e "$config_path" ]] && [[ ! -L "$config_path" ]]; then
                warning "Existing $package config found, backing up to ${config_path}.bak"
                mv "$config_path" "${config_path}.bak"
            fi
            
            # Apply stow package
            if stow -t "$HOME" "$package"; then
                success "$package configuration linked"
            else
                error "Failed to link $package configuration"
            fi
        else
            warning "Package directory '$package' not found, skipping"
        fi
    done
    
    cd ..
    success "Stow packages installation complete"
}

# Run main function
main "$@"