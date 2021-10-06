if status --is-interactive
    abbr --add --global dtf 'dotfiles'
    abbr --add --global dtfs 'dotfiles status'
    abbr --add --global dtfa 'dotfiles add'
    abbr --add --global dtfc 'dotfiles commit -m'
    abbr --add --global dtfp 'dotfiles push'
    abbr --add --global gco 'git checkout'
    abbr --add --global gpr 'git pull --rebase'
    abbr --add --global audg 'sudo apt update && sudo apt upgrade'
    abbr --add --global q! 'exit'
end

# eval (pipenv --completion)
if test (uname -s) = "Darwin"
  set -gx PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
  set -gx PATH /usr/local/opt/gnu-sed/libexec/gnubin $PATH
  set PATH $PATH /Users/neil/.local/bin
elif
  set PATH $PATH /home/neil/.local/bin
end


