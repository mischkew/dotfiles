# https://github.com/elemoine/dotfiles/blob/master/Makefile

.PHONY: all
all: dotfiles

.PHONY: dotfiles
dotfiles:
	python install-dotfiles.py

.PHONY: packages
packages:
	apt-get install dkms build-essentials linux-headers-$(uname -r) python2.7 python-pip

.PHONY: allclean
allclean:
	# nothing to clean yet