#! /bin/bash

set -e
source "$(dirname "$0")/../scripts/utils.sh"

PLATFORM="$(uname -s)"


if [ "$PLATFORM" = "Darwin" ]; then
  info 'installing llvm and bear'
  if ! command -v brew >& /dev/null; then
	  fail 'brew is not installed, cannot install llvm or bear'
	  return 1
  else
	  brew install llvm bear
  fi
elif [ "$PLATFORM" = "Linux" ]; then
  info 'installing and building llvm'
  WORKING_DIR="$(realpath "$(dirname "$0")")"
  cd "$WORKING_DIR"
  git submodule update --init "./llvm-project"
  mkdir -p ./llvm-project/build
  cd ./llvm-project/build
  cmake ../llvm -G "Unix Makefiles" \
        -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lldb" \
        -DCMAKE_BUILD_TYPE="Release" \
        -DCMAKE_INSTALL_PREFIX="$WORKING_DIR" \
    && make -j 8 \
    && make install

  info 'installing bear'
  sudo apt install bear
else
  fail "don't know how to install llvm no your platform"
fi
