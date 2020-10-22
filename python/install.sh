#! /bin/bash

set -e
source "$(dirname $0)/../scripts/utils.sh"

PLATFORM="$(uname -s)"

if [ "$PLATFORM" = "Linux" ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

  # install python package dependencies
  sudo apt-get update
  sudo apt-get install -y --no-install-recommends \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncurses5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev
fi

if command -v pyenv >/dev/null 2>&1; then
  info 'pyenv is already installed'
else
  brew install pyenv pyenv-virtualenv
fi
