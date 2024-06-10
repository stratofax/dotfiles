# Setup fzf
# ---------
if [[ ! "$PATH" == */home/neil/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/neil/.fzf/bin"
fi

eval "$(fzf --bash)"
