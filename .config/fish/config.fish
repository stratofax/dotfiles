if status --is-interactive
    abbr --add --global dtf 'dotfiles'
    abbr --add --global dtfs 'dotfiles status'
    abbr --add --global dtfa 'dotfiles add'
    abbr --add --global dtfc 'dotfiles commit -m'
    abbr --add --global dtfp 'dotfiles push'
    abbr --add --global dtfl 'dotfiles pull'
    abbr --add --global gco 'git checkout'
    abbr --add --global gpr 'git pull --rebase'
    abbr --add --global audg 'sudo apt update && sudo apt upgrade'
    abbr --add --global :q 'exit'
end

# eval (pipenv --completion)
if test (uname -s) = "Darwin"
  set -gx PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
  set -gx PATH /usr/local/opt/gnu-sed/libexec/gnubin $PATH
  set PATH $PATH /Users/neil/.local/bin /Users/neil/bin/ /Users/neil/.poetry/bin
else
  set PATH $PATH /home/neil/.local/bin /home/neil/bin/ /home/neil/.poetry/bin
end

fish_vi_key_bindings

source ~/.asdf/asdf.fish
