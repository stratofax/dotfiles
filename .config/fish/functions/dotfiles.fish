# Defined in /var/folders/bf/bqvzkhgj7_321mj0jcxcwthh0000gp/T//fish.tmDl8A/dotfiles.fish @ line 2
function dotfiles
    command /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
end
