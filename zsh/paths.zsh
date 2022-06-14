#! /bin/zsh

# usr local binaries
export PATH="/usr/local/bin:${PATH}"

# add emacs binaries
export PATH="${PATH}:~/.emacs.d/bin"

# add cuda libs
export CUDA_PATH=/usr/local/cuda
export CUDA_ROOT=$CUDA_PATH
export PATH=$CUDA_PATH/bin:${PATH}

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_PATH/lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_PATH/lib64
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_PATH/libnsight
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_PATH/libnvvp

if [ "$PLATFORM" = "Darwin" ]; then
  export DYLD_LIBRARY_PATH=.:$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH

  # add android sdk and ndk
  export ANDROID_HOME="/Users/sven/Library/Android/sdk"
  export ANDROID_NDK="${ANDROID_HOME}/ndk/21.4.7075529"
  export PATH="${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${ANDROID_NDK}"

  export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"

  if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"
  fi

  if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
  fi
fi


if [ "$PLATFORM" = "Linux" ]; then
  # glib modules
  export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules/

  # add node to path
  export PATH=${PATH}:/home/sven/.nvm/versions/node/v10.16.0/bin
fi

# ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"

# google cloud sdk
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi

# google cloud sdk completions
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi
