#! /bin/zsh

if [ "$PLATFORM" = "Darwin" ]; then
  # use homebrew llvm toolchain instead of the system one
  export PATH="/usr/local/opt/llvm/bin:${PATH}"
elif [ "$PLATFORM" = "Linux" ]; then
  # self-built llvm toolchain and Bear tool
  export PATH="${DOTFILES}/c/bin:${PATH}"
fi
