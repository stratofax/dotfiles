# dotfiles

This `dotfiles` repo contains my set of "dotfiles" and is intended to be used with GNU `stow`.

## Requirements

- git
- stow

Install using the computer's package manager, such as `apt` or `brew`.

## Installation

1. Back up your existing dot files by either moving or renaming them.
2. Run the following script:


```bash
# go to your home directory
cd
# clone this repo
git clone git@github.com:stratofax/dotfiles.git
cd ~/dotfiles

# IMPORTANT: Always test with simulation first!
stow --simulate --verbose bash git vim zsh tmux fzf
# If simulation looks correct, then install individual packages:
stow bash git vim zsh tmux fzf
# For .config structure:
stow .config
```

## Usage

### Management Commands

⚠️ **CRITICAL WARNING**: Avoid `stow .` as it creates unwanted package directory symlinks in your home directory (like `~/git`, `~/zsh`). Use individual package management instead.

```bash
# RECOMMENDED: Re-link individual packages (safe)
stow --restow bash git vim zsh tmux fzf

# DANGEROUS: This creates unwanted directory symlinks - AVOID
# stow --restow .

# SAFE: Remove individual packages
stow --delete bash git vim zsh tmux fzf

# ALWAYS test operations first with simulation
stow --simulate --verbose <package>

# Show detailed output of what's being linked
stow --verbose <package>
```

### Individual Package Management

```bash
# Only install specific configuration
stow bash
stow nvim
stow fish

# Remove only specific symlinks
stow --delete nvim
stow --delete bash

# Re-link only specific configuration
stow --restow fish
```

### Troubleshooting

```bash
# ALWAYS simulate first to identify conflicts
stow --simulate --verbose <package>

# Check for conflicting files before linking
stow --conflicts <package>

# Show detailed output of what's being linked
stow --verbose <package>
```

### ⚠️ Critical Safety Guidelines

**ALWAYS DO BEFORE STOWING:**
1. `git status` - Ensure clean working directory
2. `stow --simulate --verbose <package>` - Test individual packages first
3. Verify simulation output looks correct before proceeding

**COMMANDS TO AVOID:**
- ❌ `stow .` - Creates unwanted package directory symlinks in home directory
- ❌ `stow --adopt .` - Can move files around unexpectedly without simulation

**SAFE WORKFLOW:**
- ✅ Use individual package names: `stow bash git vim zsh tmux fzf`
- ✅ Always simulate first: `stow --simulate --verbose <package>`
- ✅ Verify symlinks after: `find ~ -maxdepth 1 -type l -ls`
- ✅ Remove any unwanted package directory symlinks from home directory

**COMMON ISSUES:**
- **Package directory symlinks in home**: If you accidentally ran `stow .`, remove unwanted symlinks like `~/git`, `~/zsh` from your home directory
- **"already exists" conflicts**: Use simulation to identify conflicts, backup/move existing files
- **Wrong symlink targets**: Use `stow --delete <package>` then `stow <package>` again

## Configuration Principles

This dotfiles repository follows these key principles:

### DRY (Don't Repeat Yourself)
- **Shared `.profile`** - Development tools configuration (nvm, cargo, pyenv, PATH) is centralized
- **Single source of truth** - Changes to development environments only need to be made once
- **Cross-shell compatibility** - Both bash and zsh source the same shared configuration

### Consistency
- **Standardized setup** - All shells get identical development tool configurations
- **Platform detection** - Automatic handling of macOS vs Linux differences
- **Uniform aliases** - Common git and system aliases across shells

### Simplification  
- **Reduced complexity** - Eliminated duplicate configuration blocks
- **Standard compliance** - Uses conventional Unix `.profile` approach
- **Maintainability** - Easier to update and debug configuration issues

