# dotfiles

This `dotfiles` repo contains my set of "dotfiles" and is intended to be used with GNU `stow`.

## Requirements

- git
- stow

Install using the computer's package manager, such as `apt` or `brew`.

## Installation

1. Back up your existing dot files by either moving or renaming them.
2. Run the following script:


```bash
# go to your home directory
cd
# clone this repo
git clone git@github.com:stratofax/dotfiles.git
cd ~/dotfiles
stow --adopt .
```

