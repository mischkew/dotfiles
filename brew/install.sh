#! /bin/bash

set -e
source "$(dirname $0)/../scripts/utils.sh"

if command -v brew >/dev/null 2>&1; then
  info 'brew is already installed'
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
