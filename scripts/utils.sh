#! /bin/bash

#
# Helpers for printing nicely formatted progress updates
#

info() {
  # shellcheck disable=SC2059
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
  # shellcheck disable=SC2059
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
  # shellcheck disable=SC2059
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
  # shellcheck disable=SC2059
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

#
# Copy and symlink utils
#

# Create a symlink. If the symlink already exists, skip the action. If another
# file exists with the same name, create a backup and then create the symlink.
link_file() {
  # $1 - source
  # $2 - destination
  if [ -e "$2" ]; then
    if [ "$(readlink "$2")" = "$1" ]; then
      success "skipped $1"
      return 0
    else
      mv "$2" "$2.backup"
      success "moved $2 to $2.backup"
    fi
  fi
  ln -sf "$1" "$2"
  success "linked $1 to $2"
}
