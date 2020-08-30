#! /bin/zsh

# load antibody package manager
source <(antibody init)
antibody bundle <"$DOTFILES/zsh/.antibody-bundles"
