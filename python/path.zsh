#! /bin/zsh

export PATH="${HOME}/.pyenv/bin:${PATH}"

if [ "$PLATFORM" = "Linux" ]; then
  eval "$(command pyenv init - --no-rehash)"
elif [ "$PLATFORM" = "Darwin" ]; then
  export PATH="/Users/sven/.pyenv/shims:${PATH}"
  export PYENV_SHELL=zsh
  pyenv() {
    local command
    command="${1:-}"
    if [ "$#" -gt 0 ]; then
      shift
    fi

    case "$command" in
      activate|deactivate|rehash|shell)
        eval "$(pyenv "sh-$command" "$@")";;
      *)
        command pyenv "$command" "$@";;
    esac
  }
else
  echo "Don't know how to setup pyenv on your platform: $PLATFORM"
fi
