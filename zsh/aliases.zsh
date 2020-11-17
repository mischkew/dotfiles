#! /bin/zsh

alias edit="$EDITOR"
alias ec="emacsclient --tty"
alias zshconfig="$EDITOR $HOME/.zshrc"
alias ls-ports="netstat -ltnp"
alias ll="ls -al"
alias watch="ffplay -i"

# "$PLATFORM" defined in .zshrc.symlink
if [ "$PLATFORM" = "Linux" ]; then
  alias open="xdg-open"
  alias pbcopy="xclip -sel clip"
fi
