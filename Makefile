# https://github.com/elemoine/dotfiles/blob/master/Makefile
SHELL=/bin/bash
kernel = $(shell uname -r)
user = $(shell whoami)
CHECK=✔
DONE="${CHECK} DONE."

all: install

#
# REPOSITORY
#

install: init-submodules setup-zsh

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
# ZSH SETUP
#

setup-zsh: install-zsh install-oh-my-zsh zsh-link-config zsh-link-plugins

install-zsh:
	@echo "Installing zsh"
	@brew install zsh
	@echo $(DONE)

zsh-link-config:
	@echo "Linking .zshrc --> ~/.zshrc"
	@ln -f -s $(pwd)/.zshrc ~/
	@echo $(DONE)

install-oh-my-zsh:
	@echo "Installing oh-my-zsh --> ~/.oh-my-zsh"
	@ln -i -s $(pwd)/libs/oh-my-zsh ~/.oh-my-zsh
	@echo $(DONE)

zsh-link-plugins:
	@echo "Linking zsh plugins."
	@for plugin in ./zsh-plugins/*; do \
		echo "Linking plugin $$plugin --> $(ZSH)/custom/plugins/$$plugin";\
		ln -f -s $(pwd)/zsh-plugins/$$plugin $(ZSH)/custom/plugins;\
	done;
	@echo $(DONE)

new-plugin:
	@echo "Create new zsh plugin '${name}' from ${git}"
	@git submodule add --force ${git} zsh-plugins/${name}
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

.PHONY: virtualenv
virtualenv:
	pip install virtualenvwrapper && /
	@install-virtualenv.sh

.PHONY: z-script
z-script:
	git clone https://github.com/rupa/z.git
	echo "source z-source.sh" >> .bashrc

.PHONY: clean
clean:
	# nothing to clean yet
