#! /bin/bash

set -e

source "$(dirname $0)/../scripts/utils.sh"
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

# install zsh extensions 

if command -v z >/dev/null 2>&1; then
  info '\t z extension already installed'
else
  info '\t installing z extension'
  git submodule update --init "$(dirname $0)/z"
  touch "$HOME/.z"
fi