#! /bin/bash

set -e
source "$(dirname "$0")/../scripts/utils.sh"

PLATFORM="$(uname -s)"

if command -v emacs >/dev/null 2>&1; then
  info 'emacs is already installed'
elif ! command -v brew >/dev/null 2>&1; then
  fail 'brew is not installed, cannot install emacs'
  return 1
else
  brew cask install emacs
fi

if [ "$PLATFORM" = "Darwin" ]; then
  link_file "$(dirname "$0")/emacs.daemon.plist" ~/Library/LaunchAgents/emacs.daemon.plist
  info 'loading emacs daemon service'
  launchctl load -w ~/Library/LaunchAgents/emacs.daemon.plist
  launchctl start emacs.daemon
else
  fail 'no daemon launcher installed'
fi
