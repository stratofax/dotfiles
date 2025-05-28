# consolidated bash aliases

# Print my public IP
alias myip='curl ipinfo.io/ip'

# Work with dotfiles repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=/$HOME'
alias dtf='dotfiles'
alias dtfs='dotfiles status -uno'
alias dtfa='dotfiles add'
alias dtfc='dotfiles commit -m'
alias dtfp='dotfiles push'
alias dtfl='dotfiles pull'

# git aliases
alias gco='git checkout'
alias gpr='git pull --rebase'

# vim equivalents
alias :q='exit'

