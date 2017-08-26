#!/bin/sh

platform=$(uname -s)
user=$(whoami)
CHECK=✔
DONE="${CHECK} DONE."
BASEDIR=$(pwd)

not_configured() {
  echo "Install only configured via brew."
  if [ $platform = "Darwin" ]; then
    echo "Visit https://brew.sh/ for install instructions."
  else
    echo "Visit http://linuxbrew.sh/ for install instructions."
  fi
}

install_zsh() {
  echo "Installing zsh terminal."
  if which brew >/dev/null 2>&1; then
    brew install zsh || brew upgrade zsh
    echo $DONE
  else
    not_configured
  fi
}

install_git() {
  echo "Linking gitconfig --> ~/.gitconfig"
  ln -i -s "$BASEDIR/gitconfig" ~/.gitconfig
  echo "Linking gitignore_global --> ~/.gitignore_global"
  ln -s "$BASEDIR/gitignore_global" ~/.gitignore_global
  echo $DONE
}

install_antibody() {
  echo "Installing antibody package manager."
  if which brew >/dev/null 2>&1; then
    brew install getantibody/tap/antibody || brew upgrade antibody
  else
    curl -sL https://git.io/antibody | sh -s
  fi
  echo $DONE
}

install_python() {
  if which brew >/dev/null 2>&1; then
    echo "(1/2) Installing pyenv"
    brew install pyenv pyenv-virtualenv
    echo "(2/2) Initialize pyenv and install python 3"
    eval "$(pyenv init -)"
    pyenv install 3.6.2
    echo $DONE
  else
    not_configured
  fi
}
