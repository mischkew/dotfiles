#! /bin/bash

set -e
source "$(dirname "$0")/../scripts/utils.sh"

PLATFORM="$(uname -s)"


if [ "$PLATFORM" = "Darwin" ]; then
  info 'installing ccls, llvm and bear'
  if ! command -v brew >& /dev/null; then
	  fail 'brew is not installed, cannot install ccls'
	  return 1
  else
	  brew install ccls llvm bear
  fi
else
  fail "don't know how to install ccls no your platform"
fi
