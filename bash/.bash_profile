# ~/.bash_profile: executed by bash(1) for login shells.
# Sources .profile (dev tools, PATH) and .bashrc (prompt, aliases, interactive config).

# Load shared environment settings (dev tools, PATH, platform config)
if [ -f ~/.profile ]; then
  . ~/.profile
fi

# Load interactive shell settings (prompt, aliases, vi mode, completions)
if [ -n "$BASH_VERSION" ] && [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
