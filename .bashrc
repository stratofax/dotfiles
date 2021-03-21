# If not running interactively, don't do anything
[[ $- == *i* ]] || return

[ -n "$PS1" ]
if [ -f $HOME/.bash_profile ]; then 
    source $HOME/.bash_profile;
fi
