#! /bin/bash

set -e
source "$(dirname $0)/../scripts/utils.sh"

if command -v antibody >/dev/null 2>&1; then
  info 'antibody is already installed'
else
  curl -sL https://git.io/antibody | sh -s
fi
