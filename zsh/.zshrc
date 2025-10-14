
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Source shared development tools configuration from .profile
if [ -f ~/.profile ]; then
  . ~/.profile
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

