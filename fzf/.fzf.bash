# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

if command -v fzf &>/dev/null; then
  if fzf --bash &>/dev/null; then
    eval "$(fzf --bash)"
  else
    # apt-installed fzf (Ubuntu 24.04) ships scripts separately
    [ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
    [ -f /usr/share/bash-completion/completions/fzf ] && source /usr/share/bash-completion/completions/fzf
  fi
fi
