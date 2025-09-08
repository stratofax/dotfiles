# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a personal dotfiles repository managed with GNU `stow` for symlink management. The repository contains configuration files for various shell environments and development tools:

- `bash/` - Bash shell configuration (.bashrc, .bash_aliases, .bash_prompt)
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
stow --adopt .
```

This creates symlinks from the home directory to the configuration files in this repository.

## Shell Configuration Architecture

The repository supports multiple shells with cross-platform compatibility:

### Fish Shell (fish/)
- Uses abbreviations (abbr) for common git and system operations
- Platform detection for macOS vs Linux with different PATH configurations
- Vi key bindings enabled
- 1Password SSH agent integration on Linux

### Bash (bash/)
- Vi mode enabled (`set -o vi`)
- Custom prompt configuration in separate `.bash_prompt` file
- History control with ignoreboth setting

### Zsh (zsh/)
- Uses Oh My Zsh framework with robbyrussell theme
- Standard Oh My Zsh configuration structure

## Neovim Configuration

The Neovim setup is based on Kickstart.nvim:
- Uses lazy.nvim as package manager
- Space key configured as leader
- Lua-based configuration in `nvim/init.lua`
- Additional Lua modules in `nvim/lua/` directory

## Common Development Commands

Since this is a dotfiles repository, there are no build, test, or lint commands. The primary operations are:

- `stow --adopt .` - Install/update dotfile symlinks
- `git status` - Check repository status
- `git add <files>` - Stage changes
- `git commit -m "message"` - Commit changes
- `git push` - Push to remote repository

## Platform Considerations

The configuration includes conditional logic for different platforms:
- macOS: Uses homebrew paths, different bookmarks location
- Linux: Standard Linux paths, 1Password SSH agent configuration

When modifying configurations, ensure platform-specific sections are maintained appropriately.