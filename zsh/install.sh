#! /bin/bash

set -e

PLATFORM="$(uname -s)"

if [ "$PLATFORM" = "Linux" ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if command -v zsh >/dev/null 2>&1; then
  info 'zsh is already installed'
elif ! command -v brew >/dev/null 2>&1; then
  fail 'brew is not installed'
else
  brew install zsh
fi
