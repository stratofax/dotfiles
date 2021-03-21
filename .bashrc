# If not running interactively, don't do anything
[[ $- == *i* ]] || return

[ -n "$PS1" ] && source $HOME/.bash_profile;
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
