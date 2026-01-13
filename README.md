# dotfiles

This repository provides a cross-platform solution for sharing configuration files across multiple computers and platforms using GNU `stow` for symlink management.

## Requirements

- git
- stow

Install using the computer's package manager, such as `apt` or `brew`.

## Installation

### 1. Back Up Existing Configuration Files

**CRITICAL**: Back up your existing dotfiles before installation to avoid losing your current configurations.

```bash
# Create backup directory
mkdir ~/dotfiles-backup-$(date +%Y%m%d)

# Back up common configuration files (adjust paths as needed)
cp ~/.bashrc ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp ~/.bash_profile ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp ~/.zshrc ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp ~/.vimrc ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp ~/.gitconfig ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp ~/.tmux.conf ~/dotfiles-backup-$(date +%Y%m%d)/ 2>/dev/null || true
```

### 2. Install Dotfiles


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
# For .config structure (be cautious of directory symlinks):
stow .config
```

### 3. Verify Installation

After installation, verify that symlinks were created correctly:

```bash
# Check that symlinks point to your dotfiles repository
ls -la ~/.bashrc ~/.gitconfig ~/.vimrc ~/.tmux.conf

# Verify they point to ~/dotfiles/ (should show -> /home/username/dotfiles/...)
find ~ -maxdepth 1 -type l -ls | grep dotfiles
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

### 🚨 Recovery Procedures

**If you accidentally ran `stow .`:**

1. **Identify unwanted package directory symlinks in your home directory:**
   ```bash
   find ~ -maxdepth 1 -type l -ls | grep dotfiles
   ```

2. **Remove unwanted package directory symlinks** (like `~/bash`, `~/git`, `~/zsh`):
   ```bash
   # CAREFUL: Only remove package directory symlinks, not individual config file symlinks
   rm ~/bash ~/git ~/zsh ~/vim ~/nvim ~/tmux  # adjust based on what you find
   ```

3. **Re-stow individual packages correctly:**
   ```bash
   cd ~/dotfiles
   stow --simulate --verbose bash git vim zsh tmux fzf  # verify first
   stow bash git vim zsh tmux fzf  # then apply
   ```

**If stow conflicts prevent installation:**

1. **Identify conflicting files:**
   ```bash
   stow --simulate --verbose <package>  # shows conflicts
   ```

2. **Move conflicting files to backup:**
   ```bash
   mv ~/.bashrc ~/.bashrc.backup  # example for bashrc conflict
   ```

3. **Retry stowing:**
   ```bash
   stow <package>
   ```

## Configuration Architecture

This dotfiles repository supports multiple shells with cross-platform compatibility:

### Repository Structure
- `bash/` - Bash shell configuration (.bashrc, .bash_aliases, .bash_prompt, .profile)
- `fish/` - Fish shell configuration with custom abbreviations and platform-specific paths
- `zsh/` - Zsh configuration using Oh My Zsh framework
- `nvim/` - Neovim configuration based on Kickstart.nvim template using lazy.nvim package manager
- `vim/` - Vim configuration files
- `tmux/` - Terminal multiplexer configuration
- `git/` - Git configuration files
- `fzf/` - Fuzzy finder configuration
- `omf/` - Oh My Fish framework configuration

### Shell Configuration Philosophy

**Shared Configuration (.profile):**
- **Centralized development tools** - nvm, cargo/rust, pyenv configurations
- **Cross-platform PATH management** - handles macOS homebrew paths and Linux-specific settings
- **Platform detection** - automatic macOS vs Linux environment setup
- **Standard Unix compliance** - follows login shell conventions

**Shell-Specific Features:**
- **Fish Shell** - Uses abbreviations (abbr), vi key bindings, platform-specific configurations
- **Bash** - Sources .profile, vi mode enabled, custom prompt configuration
- **Zsh** - Sources .profile, Oh My Zsh framework with robbyrussell theme

### Configuration Principles

**DRY (Don't Repeat Yourself):**
- **Shared `.profile`** - Development tools configuration (nvm, cargo, pyenv, PATH) is centralized
- **Single source of truth** - Changes to development environments only need to be made once
- **Cross-shell compatibility** - Both bash and zsh source the same shared configuration

**Consistency & Simplification:**
- **Standardized setup** - All shells get identical development tool configurations
- **Platform detection** - Automatic handling of macOS vs Linux differences
- **Standard compliance** - Uses conventional Unix `.profile` approach

### Platform Considerations
- **macOS**: Uses homebrew paths, different bookmarks location
- **Linux**: Standard Linux paths, BOOKMARKS environment variable
- Automatic platform detection ensures proper PATH and tool configurations

### Machine-Specific Configuration

This repository uses **conditional logic** instead of separate branches for machine-specific settings. This keeps all configuration in a single `main` branch.

**How it works:**
- Platform detection: `case "$(uname -s)"` for macOS vs Linux
- Hostname detection: `case "$(hostname)"` for machine-specific settings

**Current machine-specific settings:**

| Machine | Hostname | Custom Settings |
|---------|----------|-----------------|
| Baby Dell (Linux Mint) | `baby-dell` | Smaller gvim font (11pt vs 14pt) |
| Messier4 (Mac) | `Messier4.local` | iTerm2 integration, pyenv, custom Homebrew cask path |

**Adding a new machine:**

1. Identify your hostname: `hostname`
2. Add a case block in the appropriate platform section:

```bash
# In zsh/.zshrc (inside the Linux or Darwin case block):
case "$(hostname)" in
  your-hostname)
    # Machine-specific settings here
    ;;
esac
```

3. For vim/gvim, edit `vim/.gvimrc`:
```vim
if hostname() =~ 'your-hostname'
  " Machine-specific settings
endif
```

**Updating existing machines:**

When configuration changes are made, update other machines by pulling and restowing:

```bash
cd ~/dotfiles
git pull origin main
stow --restow bash git vim zsh tmux fzf
```

**Git commit signing:**

All machines use SSH signing with the key at `~/.ssh/id_ed25519`. Ensure this key exists on each machine:

```bash
# Check for existing key
ls ~/.ssh/id_ed25519

# Generate if needed
ssh-keygen -t ed25519 -C "your-email@example.com"
```

