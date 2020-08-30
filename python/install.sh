#! /bin/bash

set -e
source "$(dirname $0)/../scripts/utils.sh"

if command -v pyenv >/dev/null 2>&1; then
  info 'pyenv is already installed'
else
  brew install pyenv
fi
