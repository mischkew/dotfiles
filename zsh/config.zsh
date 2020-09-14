#! /bin/zsh

# shell history configuration, see `man zshoptions` and `man zshparams`
HISTSIZE=10000 # load past <HISTSIZE> commands into history
SAVEHIST=10000 # store past <SAVEHIST> commands to disk
HISTFILE=~/.history # store history into <HISTFILE>
setopt SHARE_HISTORY # share command history between multiple shells
setopt HIST_FIND_NO_DUPS # don't search for duplicate commands with C-r

# allow editing of commands in emacs
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
