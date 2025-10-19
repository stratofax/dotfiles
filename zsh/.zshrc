# Source shared development tools configuration from .profile
if [ -f ~/.profile ]; then
  . ~/.profile
fi

## Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%F{cyan}(%b)%f '

# Set up the prompt with git branch name
setopt PROMPT_SUBST
PROMPT='%F{039}%n@%m%f in %F{yellow}%~%f ${vcs_info_msg_0_}
%F{red}❯%F{yellow}❯%F{green}❯%f '

# use vim motions
set -o vi

# reuse .bash_aliases, if available
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Platform & computer specific settings
# Set up fzf key bindings and fuzzy completion
case "$(uname -s)" in
  Darwin)
    source <(fzf --zsh)

    case "$(hostname)" in
      Messier4.local)

      test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

      export PYENV_ROOT="$HOME/.pyenv"
      command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"

      export HOMEBREW_CASK_OPTS="--appdir=/Volumes/990Pro2TB/Apps"

      ;;
    esac
    ;;

  Linux)
    if [ -f ~/.fzf.zsh ]; then
        source ~/.fzf.zsh
        # enable fzf keybindings for Zsh:
        source /usr/share/doc/fzf/examples/key-bindings.zsh
        # enable fuzzy auto-completion for Zsh:
        source /usr/share/doc/fzf/examples/completion.zsh
    fi
    ;;

esac

# App-specific configuration
# nvm
if [ -d ~/.nvm ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# fabric
[ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ] &&  source "$HOME/.config/fabric/fabric-bootstrap.inc" 

# Added by Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"
# Created by `pipx` on 2024-06-01 19:12:00
export PATH="$PATH:$HOME/.local/bin"
alias claude="/home/neil/.claude/local/claude"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if [ -f "/opt/homebrew/Caskroom/miniconda/base/bin/conda" ]; then
    __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi
# <<< conda initialize <<<