# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a personal dotfiles repository managed with GNU `stow` for symlink management. The repository contains configuration files for various shell environments and development tools:

- `bash/` - Bash shell configuration (.bashrc, .bash_aliases, .bash_prompt, .profile)
- `fish/` - Fish shell configuration with custom abbreviations and platform-specific paths
- `zsh/` - Zsh configuration using Oh My Zsh framework
- `nvim/` - Neovim configuration based on Kickstart.nvim template using lazy.nvim package manager
- `vim/` - Vim configuration files
- `tmux/` - Terminal multiplexer configuration
- `git/` - Git configuration files
- `fzf/` - Fuzzy finder configuration
- `omf/` - Oh My Fish framework configuration

## Installation and Setup

The dotfiles use GNU `stow` for symlink management:

```bash
cd ~/dotfiles
# Always test with simulation first to avoid issues
stow --simulate --verbose bash git vim zsh tmux fzf
# If simulation looks correct, then run individual packages:
stow bash git vim zsh tmux fzf
# For .config structure (be cautious of directory symlinks):
stow .config
```

**AVOID**: `stow .` (creates unwanted package directory symlinks in home directory)

**Important**: Always use `stow --simulate --verbose` before running actual stow commands, especially when:
- Working with a new dotfiles setup
- Adding new packages to stow  
- Using `--adopt` (which can move files around unexpectedly)
- Troubleshooting stow conflicts

### Stow Best Practices

**Safe workflow for stow operations:**
1. `git status` - Ensure clean working directory
2. `stow --simulate --verbose <package>` - Test individual packages first
3. `stow <package>` - Apply if simulation looks correct
4. Verify symlinks: `find ~ -maxdepth 1 -type l -ls`
5. Remove any unwanted package directory symlinks from home directory

**Recommended stow commands:**
- `stow bash git vim zsh tmux fzf` - Install home directory configs
- `stow .config` - Install ~/.config/ structure (watch for directory symlinks)
- **AVOID**: `stow .` - Creates package directory symlinks in home directory

**Common stow commands:**
- `stow <package>` - Install specific package (e.g., `stow fish`)
- `stow --delete <package>` - Remove package symlinks
- `stow --restow <package>` - Re-stow package (useful after updates)
- `stow --target=/path <package>` - Stow to different directory

**Avoiding conflicts:**
- Use `.stow-local-ignore` to exclude files from stowing
- Back up existing dotfiles before first stow
- Use `--adopt` only when you want to move existing files into the repo

This creates symlinks from the home directory to the configuration files in this repository.

## Shell Configuration Architecture

The repository supports multiple shells with cross-platform compatibility using a shared configuration approach:

### Shared Configuration (.profile)
- **Centralized development tools setup** - nvm, cargo/rust, pyenv configurations
- **Cross-platform PATH management** - handles macOS homebrew paths and Linux-specific settings  
- **DRY principle implementation** - eliminates code duplication across shells
- **Platform detection** - automatic macOS vs Linux environment setup
- **Standard compliance** - follows Unix convention for login shell configuration

### Fish Shell (fish/)
- Uses abbreviations (abbr) for common git and system operations
- Platform-specific configurations (separate from .profile due to syntax differences)
- Vi key bindings enabled
- Custom PATH and environment setup

### Bash (bash/)
- **Sources .profile** for shared development tools configuration
- Vi mode enabled (`set -o vi`)
- Custom prompt configuration in separate `.bash_prompt` file
- History control with ignoreboth setting

### Zsh (zsh/)
- **Sources .profile** for shared development tools configuration
- Uses Oh My Zsh framework with robbyrussell theme
- Custom prompt with git integration

## Neovim Configuration

The Neovim setup is based on Kickstart.nvim:
- Uses lazy.nvim as package manager
- Space key configured as leader
- Lua-based configuration in `nvim/init.lua`
- Additional Lua modules in `nvim/lua/` directory

## Common Development Commands

Since this is a dotfiles repository, there are no build, test, or lint commands. The primary operations are:

- `stow --simulate --verbose <package>` - Test individual package operations safely before applying
- `stow bash git vim zsh tmux fzf` - Install/update home directory dotfile symlinks
- `stow .config` - Install/update ~/.config/ structure (watch for unwanted directory symlinks)
- `git status` - Check repository status
- `git add <files>` - Stage changes
- `git commit -m "message"` - Commit changes
- `git push` - Push to remote repository

## Platform Considerations

The configuration includes conditional logic for different platforms:
- macOS: Uses homebrew paths, different bookmarks location  
- Linux: Standard Linux paths, BOOKMARKS environment variable

When modifying configurations, ensure platform-specific sections are maintained appropriately.

## Troubleshooting Notes

### Stow Issues
- **"already exists" conflicts**: Use `stow --simulate` to identify conflicts, backup/move existing files
- **Directory nesting issues**: Check for `.config/` subdirectories created by `--adopt`, move files to correct locations
- **Package directory symlinks in home**: `stow .` creates unwanted symlinks like `~/git`, `~/zsh` - remove these and use individual package stowing instead
- **Missing symlinks**: Verify you're in the correct directory (`/home/neil/dotfiles`) when running stow
- **Wrong symlink targets**: Use `stow --delete` then `stow` again to recreate correct symlinks
- **Directory vs file conflicts**: When stow tries to create directory symlinks but individual files are needed, stow individual packages rather than using `stow .`

### Configuration Issues
- **SSH Agent**: Configuration uses standard SSH agent, not 1Password integration
- **pyenv**: Includes defensive checks to prevent errors when pyenv is not installed
- **tmux character display**: Updated configuration supports UTF-8 and modern terminal features

