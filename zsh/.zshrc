# ~/.zshrc - zsh configuration

# Source credentials (not in git repo, created per-machine)
[[ -f ~/.my_tokens ]] && source ~/.my_tokens

# Source shared shell functions
[[ -f ~/.shell_functions ]] && source ~/.shell_functions

# fzf integration
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
