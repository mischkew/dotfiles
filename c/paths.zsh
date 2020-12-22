#! /bin/zsh

if [ "$PLATFORM" = "Darwin" ]; then
  # use homebrew llvm toolchain instead of the system one
  export PATH="/usr/local/opt/llvm/bin:${PATH}"
fi
