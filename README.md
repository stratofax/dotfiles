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
stow --adopt .
```

## Usage

### Management Commands

```bash
# Re-link all packages (useful after updates)
stow --restow .

# Remove all symlinks (for uninstalling)
stow --delete .

# Dry run to preview what would be linked
stow -n --verbose .

# Explicitly set target directory
stow --target=$HOME .
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
# Check for conflicting files before linking
stow --conflicts .

# Show detailed output of what's being linked
stow --verbose .
```

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

