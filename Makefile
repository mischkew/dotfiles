# https://github.com/elemoine/dotfiles/blob/master/Makefile

.PHONY: all
all: dotfiles

.PHONY: dotfiles
dotfiles:
	python install-dotfiles.py

.PHONY: packages
packages:
	apt-get install dkms build-essential linux-headers-$(uname -r) python2.7 python-pip

.PHONY: virtualbox
virtualbox: packages
	# setup vbox shared folders
	apt-get install --no-install-recommends virtualbox-guest-utils
	apt-get install virtualbox-guest-dkms
	adduser $(whoami) vboxsf

.PHONY: sshserver
sshserver: 
	apt-get install openssh-server
	
.PHONY: allclean
allclean:
	# nothing to clean yet