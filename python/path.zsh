#! /bin/zsh

# This lazy-loads pyenv by executing the pyenv init command first call, which
# then essentially replaces this function
# See: https://carlosbecker.com/posts/speeding-up-zsh
pyenv() {
  eval "$(command pyenv init -)"
  eval "$(command pyenv virtualenv-init -)"
  pyenv "$@"
}
