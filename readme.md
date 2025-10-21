# Setup Dotfiles on a new machine

## Quick Install
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What the install script does:
1. **Zsh Configuration** - Sets up ~/.zshrc with dynamic paths
2. **Config Management** - Uses stow with YAML configuration (`stow-packages.yml`):
   - `config/nvim/` → `~/.config/nvim/`
   - `config/ghostty/` → `~/.config/ghostty/`  
   - `config/tmux/` → `~/.config/tmux/`
   - `config/opencode/` → `~/.config/opencode/`
3. **Brew Packages** - Optionally installs packages from Brewfile

## Dependencies
- **stow** - For configuration management (`brew install stow`)
- **yq** - For YAML parsing (`brew install yq`)
- **homebrew** - For package management (optional)

## Manual Management
```bash
cd ~/dotfiles/config

# Link individual configs to their target directories
stow -t ~/.config/nvim nvim
stow -t ~/.config/ghostty ghostty  
stow -t ~/.config/tmux tmux
stow -t ~/.config/opencode opencode

# Unlink configs
stow -t ~/.config/nvim -D nvim
stow -t ~/.config/ghostty -D ghostty
stow -t ~/.config/tmux -D tmux
stow -t ~/.config/opencode -D opencode
```

## File Structure
```
~/dotfiles/
├── config/              # Configuration packages (clean paths!)
│   ├── nvim/           # config/nvim/lua/plugins.lua
│   │   ├── init.lua
│   │   └── lua/
│   ├── ghostty/        # config/ghostty/config
│   │   └── config
│   ├── tmux/           # config/tmux/tmux.conf
│   │   ├── tmux.conf
│   │   └── plugins/
│   │       └── catppuccin/
│   └── opencode/       # config/opencode/opencode.json
│       ├── opencode.json
│       ├── package.json
│       ├── .gitignore
│       ├── command/        # Custom commands (/explore, /plan, /execute)
│       │   ├── explore.md
│       │   ├── plan.md
│       │   └── execute.md
│       └── providers/
├── aliases/            # Shell aliases
├── scripts/            # Utility functions  
├── stow-packages.yml   # Stow package configuration
└── Brewfile           # Package dependencies
```
