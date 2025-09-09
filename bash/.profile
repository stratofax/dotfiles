# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists. See /usr/share/doc/bash/examples/startup-files for examples.

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
  eval "$(pyenv init -)"
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
    # 1Password SSH agent integration
    export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
    export BOOKMARKS="/home/neil"
    ;;
esac