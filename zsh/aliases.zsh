#! /bin/zsh

alias zshconfig="$EDITOR $HOME/.zshrc"
alias ls-ports="netstat -ltnp"
alias ll="ls -al"
alias watch="ffplay -i"

if [ "$PLATFORM" = "Linux" ]; then
  alias open="xdg-open"
  alias pbcopy="xclip -sel clip"
fi
