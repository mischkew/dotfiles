#! /bin/bash

set -e
source "$(dirname $0)/../scripts/utils.sh"

platform=$(uname -s)

install_osx_packages() {
    info "Install casks for OSX"

    # Keyboard Shortcuts for the OSX window manager
    # https://github.com/rxhanson/Rectangle
    brew install rectangle --cask

    user "Make sure to set Rectangle to launch automatically on boot"
    user "Make sure to set the accessibility rights for Rectangle!"
}

if [ "$platform" = "Darwin" ]; then
    install_osx_packages
fi
