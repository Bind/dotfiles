# Agent Guidelines for Dotfiles Repository

## Project Structure
- **Dotfiles management**: Uses `stow` for symlinking configs to `~/.config/`
- **Shell setup**: Zsh with oh-my-zsh, custom aliases in `aliases/` directory
- **Config directories**: `config/nvim/`, `config/ghostty/`, `config/tmux/`, `config/opencode/`

## Build/Test/Lint Commands
- **Setup**: `./install.sh` - Full dotfiles installation and configuration
- **Restow configs**: `./restow.sh` - Re-link all configuration packages
- **Update zsh**: `./setup_zsh.sh` - Generate ~/.zshrc from template
- **Package management**: `brew bundle` - Install Brewfile packages

## Code Style & Conventions
- **Shell scripts**: Use `set -e` for error handling, descriptive function names
- **Bash**: 2-space indentation, double-quote variables, use `$()` over backticks
- **Lua (nvim)**: 2-space indentation, use snake_case for variables, kebab-case for keymaps
- **File organization**: Group related configs in directories, use descriptive filenames
- **Comments**: Include header comments for script purpose, inline for complex logic
- **Error handling**: Check command existence with `command_exists()` pattern
- **Path handling**: Use absolute paths, escape special characters in sed expressions

## Key Patterns
- Template substitution: `[[DOTFILES_DIR]]` placeholder in `zshrc.tmpl.sh`
- YAML-driven config: `stow-packages.yml` defines package-to-target mappings
- Modular aliases: Separate files in `aliases/` for different tools/domains