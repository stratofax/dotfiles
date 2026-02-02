# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists. See /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Note: .bashrc sources .profile, so we don't source .bashrc from here to avoid circular dependency
# if running bash
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
# 	. "$HOME/.bashrc"
#     fi
# fi

# nvm - Node Version Manager
# Supports three installation methods:
# 1. Standard nvm script installation (~/.nvm)
# 2. Alternative user installation (~/.config/nvm)
# 3. Homebrew installation (/opt/homebrew/opt/nvm)

# Check for Homebrew installation first (macOS)
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ ! -d "$NVM_DIR" ] && mkdir -p "$NVM_DIR"  # Create working directory if needed
  \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# Check for standard nvm installation
elif [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# Check for alternative user installation
elif [ -d "$HOME/.config/nvm" ]; then
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# Rust/Cargo environment
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Python environment manager
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  # Only initialize pyenv if the command is actually available
  if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
fi

# Common PATH additions
# Add local bin directories to PATH
echo "$PATH" | grep -Eq "(^|:)$HOME/.local/bin(:|$)" || export PATH="$PATH:$HOME/.local/bin"
echo "$PATH" | grep -Eq "(^|:)$HOME/bin(:|$)" || export PATH="$PATH:$HOME/bin"

# Platform-specific configurations
case "$(uname -s)" in
  Darwin)
    # macOS homebrew paths
    echo "$PATH" | grep -Eq "(^|:)/usr/local/opt/coreutils/libexec/gnubin(:|$)" || export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    echo "$PATH" | grep -Eq "(^|:)/usr/local/opt/gnu-sed/libexec/gnubin(:|$)" || export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    export BOOKMARKS="/Users/neil"
    ;;
  Linux)
    export BOOKMARKS="/home/neil"
    ;;
esac

# thefuck alias initialization
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
fi
# dotfiles-managed: lmstudio
# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section

