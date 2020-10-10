#! /bin/zsh

# find the socket of the running emacs daemon by listing all open file
# connections (aka sockets), find files of emacs of the current user
# with the specific `system-server` daemon name. The system-server is
# launched by the launchctl/ systemd configuration of these
# dotfiles. We then pick the filename which is the last column of lsof
# via awk.
# see: https://stackoverflow.com/a/28553846
server_file="$(lsof -c /emacs/i | grep $USER | grep system-server | awk 'NR==1 {print $NF}')"

# use the GUI emacs, try to reuse the current frame, don't block the
# tty
alias ec="emacsclient -s '$server_file' -a 'emacs' -c"

# use emacs in the tty
alias ecc="emacsclient -s '$server_file' -nw -a 'emacs -nw'"
