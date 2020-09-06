#! /bin/bash

set -e
source "$(dirname $0)/../scripts/utils.sh"

if command -v emacs >/dev/null 2>&1; then
  info 'emacs is already installed'
elif ! command -v brew >/dev/null 2>&1; then
  error 'brew is not installed, cannot install emacs'
  return 1
else
  brew cask install emacs
fi
