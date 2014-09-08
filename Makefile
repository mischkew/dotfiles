# https://github.com/elemoine/dotfiles/blob/master/Makefile

kernel = $(shell uname -r)
user = $(shell whoami)

.PHONY: all
all: dotfiles virtualbox sshserver virtualenv

.PHONY: dotfiles
dotfiles:
	python install-dotfiles.py

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

.PHONY: clean
clean:
	# nothing to clean yet
