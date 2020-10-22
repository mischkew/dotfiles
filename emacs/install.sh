#! /bin/bash

set -e
source "$(dirname "$0")/../scripts/utils.sh"

PLATFORM="$(uname -s)"

if [ "$PLATFORM" = "Linux" ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

#
# install emacs
#

if command -v emacs >/dev/null 2>&1; then
  info 'emacs is already installed'
elif ! command -v brew >/dev/null 2>&1; then
  fail 'brew is not installed, cannot install emacs'
  return 1
elif [ "$PLATFORM" = "Darwin" ]; then
  brew cask install emacs
elif [ "$PLATFORM" = "Linux" ]; then
  brew install emacs
else
  fail "I do not know how to install emacs on your platform (${PLATFORM})!"
fi

#
# install auxiliary packages for emacs usage
#

if command -v shellcheck >/dev/null 2>&1; then
    info 'shellcheck is already installed'
else
    info 'install shellcheck'
    brew install shellcheck
fi

#
# setup emacs daemon
#

if [ "$PLATFORM" = "Darwin" ]; then
  link_file "$(dirname "$0")/emacs.daemon.plist" ~/Library/LaunchAgents/emacs.daemon.plist
  info 'loading emacs daemon service'
  launchctl load -w ~/Library/LaunchAgents/emacs.daemon.plist
  launchctl start emacs.daemon
else
  fail 'no daemon launcher installed'
fi
