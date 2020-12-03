#! /bin/zsh

alias ll="ls -al"

# Will connect to the running emacs GUI if called from a standard
# terminal. Will connect to vscode if called from within a vscode
# terminal
alias edit="$EDITOR"

# Will connect to a running emacs server but stay on the terminal.
# Useful if using a terminal outside of emacs vterm (i.e. Gnome
# Terminal or iTerm2)
alias ec="emacsclient --tty"

# Edit .zshrc in the standard editor
alias zshconfig="$EDITOR $HOME/.zshrc"

# List all ports which are currently listening to applications, useful
# to debug if ports are blocked.
alias ls-ports="netstat -ltnp"

# Use ffmpeg to watch a video from the command line.
alias watch="ffplay -i"

# "$PLATFORM" defined in .zshrc.symlink
if [ "$PLATFORM" = "Linux" ]; then
    # Open anything with open, like on OSX.
    alias open="xdg-open"

    # Copy to clipboard with the same command as on OSX.
    alias pbcopy="xclip -sel clip"
fi
