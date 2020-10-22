#! /bin/bash

set -e
source "$(dirname $0)/../scripts/utils.sh"

PLATFORM="$(uname -s)"

if [ "$PLATFORM" = "Linux" ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if command -v brew >/dev/null 2>&1; then
  info 'brew is already installed'
elif ! command -v curl >/dev/null 2>&1; then
  fail 'curl not found'
  exit 1
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
