# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists. See /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# nvm - Node Version Manager
# Check for standard nvm installation (~/.nvm) first, then brew installation (~/.config/nvm)
# This handles both the default distribution script installation and macOS homebrew installation
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
elif [ -d "$HOME/.config/nvm" ]; then
  export NVM_DIR="$HOME/.config/nvm"
fi

# Only configure nvm environment if either installation directory was found
if [ -n "$NVM_DIR" ]; then
  # This loads nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  
  # This loads nvm bash_completion 
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  
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