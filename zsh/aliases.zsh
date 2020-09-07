#! /bin/zsh

alias zshconfig="$EDITOR $HOME/.zshrc"
alias ec="emacsclient -nw -a 'emacs -nw'"
alias ls-ports="netstat -ltnp"
alias ll="ls -al"

if [ "$PLATFORM" = "Linux" ]; then
  alias open="xdg-open"
  alias pbcopy="xclip -sel clip"
fi

#
# ThinkSono-related
#

alias tstk="pyenv activate tstk &> /dev/null && tstk"
alias medconv="pyenv activate medconv &> /dev/null && medconv"
