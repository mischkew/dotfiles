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

install_packages() {
    if [ -z $IS_OSX ]; then
	install_packages_linux
    else
	install_packages_osx
    fi
}

install_packages_osx() {
    echo "No packages for OSX defined. Skipping."
}

install_packages_linux() {
    sudo apt-get install -y \
	 curl \
	 xclip
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

	echo "Setup brew paths for zsh"
	if [ -r ~/.zprofile ]; then
	    echo "export PATH=\"$(brew --prefix)/bin:$(brew --prefix)/sbin:\$PATH\"" >> ~/.zprofile
	else
	    echo "export PATH=\"$(brew --prefix)/bin:$(brew --prefix)/sbin:\$PATH\"" > ~/.zprofile
	fi
	echo "brew setup for zsh terminal $DONE"
    else
	not_configured
    fi
}

install_git() {
    echo "Linking git configs"
    ln -v -i -s "$BASEDIR/git/gitconfig" ~/.gitconfig
    ln -v -i -s "$BASEDIR/git/gitignore_global" ~/.gitignore_global
    echo $DONE
}

install_antibody() {
    echo "Installing antibody package manager."
    curl -sL https://git.io/antibody | sh -s
    echo $DONE
}

install_pyenv() {
    if is_installed pyenv; then
	echo "pyenv is already installed. Skipping."
	return 0
    fi
			       
    if is_installed brew; then
	echo "Installing pyenv"
	brew install pyenv pyenv-virtualenv
	eval "$(pyenv init -)"
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

install() {
    install_packages
    install_brew
    install_zsh
    install_git
    install_antibody
    install_pyenv
}
