platform=$(uname -s)
if [ $platform = "Darwin" ]; then IS_OSX="1"; fi

# dotfiles repository
export ZSH_INSTALL_DIR=$(dirname $(readlink ~/.zshrc))

# load completions
fpath=(~/.zsh/completion $fpath)

# terminal capabilities
export TERM=xterm-256color

# save history
HISTSIZE=1000
if (( ! EUID )); then
  HISTFILE=~/.history_root
else
  HISTFILE=~/.history
fi
SAVEHIST=1000
setopt SHARE_HISTORY

# Choose your fav editor
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -c -n"

# nvm lazy loading
export NVM_LAZY_LOAD=true

# load antibody package manager
source <(antibody init)
antibody bundle < "$ZSH_INSTALL_DIR/.antibody-bundles"

#
# modify path
#

# add emacs binaries
export PATH="$PATH:~/.emacs.d/bin"

# add homebrew sbin path
export PATH="/usr/local/sbin:$PATH"

# add cuda libs
export CUDA_PATH=/usr/local/cuda
export CUDA_ROOT=$CUDA_PATH
export PATH=$CUDA_PATH/bin:${PATH}
export LD_LIBRARY_PATH=.:$CUDA_PATH/lib:$CUDA_PATH/lib64:$CUDA_PATH/libnsight:$CUDA_PATH/libnvvp:/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=.:$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH

# add android sdk and ndk
export PATH=${PATH}:/Users/sven/Library/Android/sdk/ndk-bundle
export PATH=${PATH}:/Users/sven/Library/Android/sdk/platform-tools


#
# configure autocompletion
#

# better autcomplete matching
# http://stackoverflow.com/questions/24226685/have-zsh-return-case-insensitive-auto-complete-matches-but-prefer-exact-matches
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# menu if nb items > 2
zstyle ':completion:*' menu select=2

# speed up initialization of auto complete
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C
fi

#
# aliases and functions
#

alias zshconfig="$EDITOR ~/.zshrc"
alias ec="emacsclient -c -n"
alias ll="ls -al"
alias tstk="pyenv activate tstk &> /dev/null && tstk"
alias medconv="pyenv activate medconv && medconv"
it2prof() { echo -e "\033]50;SetProfile=$1\a" }
dir2dicom() {
  pyenv activate medconv
  for f in *avi; do
	  medconv --src $f to-dicom --compressed True;
  done
  for f in *mp4; do
    medconv --src $f to-dicom --compressed True;
  done
  mkdir -p dicom
  mv ./*dcm dicom
  pyenv deactivate
}

if [ -z $IS_OSX ]; then
    alias pbcopy="xclip -sel clip"
fi

source $ZSH_INSTALL_DIR/docker_utils.sh

# pyenv
if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
    eval "$(pyenv virtualenv-init -)";
fi

#
# custom ssh keys
#

ssh-add ~/.ssh/ec2-ireland-sven.pem &> /dev/null
