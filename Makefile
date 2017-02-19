# https://github.com/elemoine/dotfiles/blob/master/Makefile
kernel=$(shell uname -r)
user=$(shell whoami)
CHECK=✔
DONE="${CHECK} DONE."
BASEDIR=$(shell pwd)

all: install

#
# REPOSITORY
#

install: init-submodules setup-zsh setup-emacs

init-submodules:
	@echo "Initializing submodules"
	@git submodule init && git submodule update && git submodule status

new-submodule:
	@echo "Creating new submodule '${name}' from ${git}"
	@git submodule add --force ${git} libs/${name}
	@echo $(DONE)

update: update-repo init-submodules update-submodules

update-repo:
	git pull origin master
	@echo $(DONE)

update-submodules:
	@echo "Updating submodules"
	@git submodule foreach "(git checkout master; git pull)&"
	@echo $(DONE)init-submodules:
	@echo "Initializing submodules"
	@git submodule init && git submodule update && git submodule status

#
# GIT SETUP
#

setup-git: install-git git-link-config

install-git:
	@echo "Installing git"
	@brew install git
	@echo $(DONE)

git-link-config:
	@echo "Linking gitconfig --> ~/.gitconfig"
	@ln -i -s $(pwd)/gitconfig ~/.gitconfig
	@echo "Linking gitignore_global --> ~/.gitignore_global"
	@ln -s $(pwd)/gitignore_global ~/.gitignore_global
	@echo $(DONE)
#
# EMACS SETUP
#

setup-emacs: install-emacs emacs-link-config

install-emacs:
	@echo "Installing emacs"
	@brew install emacs
	@brew linkapps emacs
	@echo $(DONE)

emacs-link-config:
	@echo "Linking libs/emacs-config --> ~/.emacs.d"
	@ln -i -s $(pwd)/libs/emacs-config ~/.emacs.d
	@echo $(DONE)
#
# ZSH SETUP
#

setup-zsh: install-zsh zsh-link-config

install-zsh:
	@echo "Installing zsh"
	@brew install zsh
	@echo $(DONE)

install-antigen:
	@echo "Installing antigen package manager"
	@mdkir -p $(BASEDIR)/vendor
	curl https://cdn.rawgit.com/zsh-users/antigen/v1.4.0/bin/antigen.zsh > $(BASEDIR)/vendor/antigen.zsh
	@echo $(DONE)

zsh-link-config:
	@echo "Linking .zshrc --> ~/.zshrc"
	@ln -f -s $(BASEDIR)/.zshrc ~/
	@echo $(DONE)

.PHONY: packages
packages:
	apt-get install dkms build-essential linux-headers-$(kernel) python2.7 python-pip subversion git

.PHONY: virtualbox
virtualbox: packages
	# setup vbox shared folders
	apt-get install --no-install-recommends virtualbox-guest-utils
	apt-get install virtualbox-guest-dkms
	adduser $(user) vboxsf

.PHONY: sshserver
sshserver:
	apt-get install openssh-server

.PHONY: clean
clean:
	# nothing to clean yet
