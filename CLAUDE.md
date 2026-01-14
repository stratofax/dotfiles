# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This repository provides a cross-platform solution for sharing configuration files across multiple computers and platforms using GNU `stow` for symlink management. The repository contains configuration files organized by application/tool:

- `bash/` - Bash shell configuration files (.bashrc, .bash_aliases, .bash_prompt, .profile)
- `fish/` - Fish shell configuration files
- `zsh/` - Zsh shell configuration files  
- `nvim/` - Neovim editor configuration files
- `vim/` - Vim editor configuration files
- `tmux/` - Terminal multiplexer configuration files
- `git/` - Git version control configuration files
- `fzf/` - Fuzzy finder configuration files
- `omf/` - Oh My Fish framework configuration files
- `claude/` - Claude Code shared configurations (commands, skills, agents)

### Claude Code Directories (Important Distinction)

This repository contains two `.claude` directories with different purposes:

1. **`.claude/`** (at repo root: `dotfiles/.claude/`)
   - Project-specific Claude Code settings for working in this dotfiles repository
   - Contains `settings.local.json` with permissions specific to dotfiles development
   - **Never symlinked** - used only when working in this repo
   - Similar to how any project has its own `.claude/` directory

2. **`claude/.claude/`** (stow package: `dotfiles/claude/.claude/`)
   - Shared Claude Code configurations to be symlinked to `~/.claude/`
   - Contains custom commands, skills, agents, and a shared `CLAUDE.md`
   - **Stow this package** with `stow claude` to symlink contents to `~/.claude/`
   - Provides consistent Claude Code setup across all computers

**Do not confuse these two directories.** The root `.claude/` is for this repo only; `claude/.claude/` is the stow package for global Claude settings.

## Installation and Setup

The dotfiles use GNU `stow` for symlink management:

```bash
cd ~/dotfiles
# Always test with simulation first to avoid issues
stow --simulate --verbose bash git vim zsh tmux fzf claude
# If simulation looks correct, then run individual packages:
stow bash git vim zsh tmux fzf claude
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
- `stow claude` - Install shared Claude Code commands/skills/agents to ~/.claude/
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

### .stow-local-ignore Usage
The `.stow-local-ignore` file (placed in package directories) excludes specific files from being stowed:

**File format (Perl regex patterns):**
```
# Comments start with #
\.git.*          # Ignore all git files
README.*         # Ignore README files
\.DS_Store       # Ignore macOS metadata
.*\.bak$         # Ignore backup files ending in .bak
temp/            # Ignore temp directory
```

**Common use cases:**
- Exclude development files (README, .git, etc.) from being linked to home directory
- Skip platform-specific files that shouldn't be shared across computers
- Ignore temporary or backup files
- Exclude files that should remain local to the repository

**Location:** Place `.stow-local-ignore` in the root of each package directory (e.g., `bash/.stow-local-ignore`, `nvim/.stow-local-ignore`)

This creates symlinks from the home directory to the configuration files in this repository.

## Cross-Platform Configuration Architecture

The repository supports multiple shells and platforms using a shared configuration approach to ensure consistency across different computers:

### Shared Configuration Strategy
- **Centralized shared settings** - Common configurations stored in .profile for cross-shell compatibility
- **Cross-platform PATH management** - Handles different platform-specific paths and environment variables
- **DRY principle implementation** - Eliminates duplication of configuration across shells and platforms
- **Platform detection** - Automatic detection and configuration for macOS vs Linux environments
- **Standard compliance** - Follows Unix conventions for maximum compatibility

### Shell Configuration Files
- **Fish Shell (fish/)** - Platform-specific configurations (separate syntax from other shells)
- **Bash (bash/)** - Sources shared .profile for common settings, plus bash-specific configurations
- **Zsh (zsh/)** - Sources shared .profile for common settings, plus zsh-specific configurations

### Cross-Platform Compatibility
The configuration files include conditional logic and platform detection to ensure proper operation across different operating systems and environments.

## Computer-Specific Branch Strategy

This repository uses separate branches for different computers to handle machine-specific configurations:

### Branch Naming Convention
- `main` - Shared configurations that work across all computers
- `linux-mint-baby-dell` - Specific configurations for Linux Mint on Baby Dell computer
- `macos-macbook-pro` - Specific configurations for macOS MacBook Pro (example)

### Workflow for Computer-Specific Changes
1. **Work on computer-specific branch**: `git checkout linux-mint-baby-dell`
2. **Make configuration changes** specific to that computer
3. **Test with stow simulation**: `stow --simulate --verbose <package>`
4. **Commit changes**: Include computer context in commit message
5. **Push to computer-specific branch**: `git push origin linux-mint-baby-dell`
6. **Merge shared changes to main** when configurations are proven to work across platforms

### Branch Management
- **Keep main branch clean** - Only merge configurations proven to work cross-platform
- **Use computer branches for experimentation** - Test new configurations safely
- **Cherry-pick or merge** successful configurations from computer branches to main
- **Pull from main regularly** to keep computer branches updated with shared improvements

## Common Development Commands

Since this is a dotfiles repository, there are no build, test, or lint commands. The primary operations are:

### Stow Operations
- `stow --simulate --verbose <package>` - Test individual package operations safely before applying
- `stow bash git vim zsh tmux fzf` - Install/update home directory dotfile symlinks
- `stow claude` - Install/update shared Claude Code configurations to ~/.claude/
- `stow .config` - Install/update ~/.config/ structure (watch for unwanted directory symlinks)

### Git Operations
- `git status` - Check repository status
- `git checkout <computer-branch>` - Switch to computer-specific branch
- `git add <files>` - Stage changes
- `git commit -m "message"` - Commit changes (include computer context for computer-specific changes)
- `git push origin <computer-branch>` - Push to computer-specific remote branch

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

### Cross-Platform Issues
- **Platform detection**: Ensure conditional logic properly detects macOS vs Linux environments
- **PATH differences**: Verify platform-specific paths are correctly configured in shared .profile
- **Symlink compatibility**: Check that symlinks work correctly across different filesystems and platforms

