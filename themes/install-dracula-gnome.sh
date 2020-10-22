#! /bin/sh

# required to configure the terminal
echo "About to install dconf-cli. Sudo required."
sudo apt install dconf-cli

git submodule update --init "$(dirname $0)/gnome-terminal"
"$(dirname $0)/gnome-terminal/install.sh"