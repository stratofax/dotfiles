# If not running interactively, don't do anything
[[ $- == *i* ]] || return

[ -n "$PS1" ] && source ~/.bash_profile;
alias dotfiles='/usr/bin/git --git-dir=/Users/neil/.dotfiles/ --work-tree=/Users/neil'
