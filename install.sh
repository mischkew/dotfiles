#!/bin/sh

platform=$(uname -s)
if [ $platform = "Darwin" ]; then IS_OSX="1"; fi

user=$(whoami)
CHECK=✔
DONE="${CHECK} DONE."

if [ -z "$IS_OSX" ]; then
    BASEDIR=$(readlink -e $(dirname $0))
else
    echo "Not implemented for OSX"
    exit 1
fi
echo "Running install from $BASEDIR"

not_configured() {
  echo "Install only configured via brew."
  if [ $platform = "Darwin" ]; then
    echo "Visit https://brew.sh/ for install instructions."
  else
    echo "Visit http://linuxbrew.sh/ for install instructions."
  fi
}

is_installed() {
    # 1 - application
    application=$1
    which $application > /dev/null
}

install_zsh() {
    if is_installed brew; then
	echo "Installing zsh terminal..."	
	brew install zsh || brew upgrade zsh
	ln -i -v -s "$BASEDIR/zsh/.zshrc" ~/.zshrc

	if [ -z $IS_OSX ]; then
	    if cat /etc/shells | grep zsh > /dev/null; then
		echo "zsh already added to shells file"
	    else
		command -v zsh | sudo tee -a /etc/shells
	    fi
	    chsh -s $(which zsh)
	else
	    echo "Not implemented for OSX"
	    exit 1
	fi
	
	echo "zsh terminal $DONE"
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

install_brew() {
    if is_installed brew; then
	echo "Upgrading Homebrew..."
	brew update && brew upgrade
	echo "Homebrew $DONE"
	return 0
    fi
    
    if [ -z $IS_OSX ]; then
	install_brew_linux
    else
	install_brew_osx
    fi
}

install_brew_linux() {
    set -e
    echo "Installing Homebrew..."
    
    # install from remote script
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

    # set bashrc and profile paths
    test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
    test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
    test -r ~/.bash_profile && echo "export PATH=\"$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH\"" >>~/.bash_profile
    test -r ~/.profile && echo "export PATH=\"$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH\"" >>~/.profile

    echo "Homebrew $DONE"
    set +e
}

install_brew
install_zsh
