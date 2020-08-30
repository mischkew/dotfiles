#! /bin/zsh
platform=$(uname -s)
if [ $platform = "Darwin" ]; then IS_OSX="1"; fi

# dotfiles repository
export ZSH_INSTALL_DIR=$(dirname $(readlink ~/.zshrc))
export ZSHRC="$ZSH_INSTALL_DIR/.zshrc"

# load completions
fpath=("$ZSH_INSTALL_DIR/completion" $fpath)

# terminal capabilities
export TERM=xterm-256color
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

# shell history configuration, see `man zshoptions` and `man zshparams`
HISTSIZE=10000 # load past <HISTSIZE> commands into history
SAVEHIST=10000 # store past <SAVEHIST> commands to disk
HISTFILE=~/.history # store history into <HISTFILE>
setopt SHARE_HISTORY # share command history between multiple shells
setopt HIST_FIND_NO_DUPS # don't search for duplicate commands with C-r

# Choose your fav editor
export ALTERNATE_EDITOR="emacsclient -c -n"
export EDITOR="code -w"

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

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_PATH/lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_PATH/lib64
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_PATH/libnsight
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$CUDA_PATH/libnvvp

if [ $platform = "Darwin" ]; then
  export DYLD_LIBRARY_PATH=.:$LD_LIBRARY_PATH:$DYLD_LIBRARY_PATH
fi


# add android sdk and ndk
export PATH=${PATH}:/usr/local/opt/android-ndk-r16b/
export PATH=${PATH}:/usr/local/opt/android-studio/bin/
export PATH=${PATH}:/home/sven/Android/Sdk/platform-tools/

if [ $platform = "Linux" ]; then
  # glib modules
  export GIO_EXTRA_MODULES=/usr/lib/x86_64-linux-gnu/gio/modules/

  # add node to path
  export PATH=${PATH}:/home/sven/.nvm/versions/node/v10.16.0/bin
fi

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

alias git="LANG=en-GB git"
alias zshconfig="$EDITOR ~/.zshrc"
alias ec="emacsclient -c -n"
alias tstk="pyenv activate tstk &> /dev/null && tstk"
alias medconv="pyenv activate medconv && medconv"
alias concat_videos=$ZSH_INSTALL_DIR/concat_videos.sh
alias start_bundling="pyenv activate tstk && aws ec2 start-instances --instance-ids i-09515906231acecf8 --region eu-west-1"
alias lsports="netstat -ltnp"
if [ $platform = "Linux" ]; then
  alias open="xdg-open"
fi

it2prof() { echo -e "\033]50;SetProfile=$1\a" }
dir2dicom() {
  localenv=$(pyenv version)
  pyenv activate medconv

  videos=$(find ./ -type f \( -name "*avi" -or -name "*mp4" \))
  while read -r video; do
    dcm=${video%.*}.dcm
    if [ ! -f "$dcm" ]; then
      medconv --src "$video" to-dicom --compressed True;
    else
      echo "$dcm already exists. Skipping conversion."
    fi
  done <<< $videos

  pyenv activate $localenv
}
dir2video() {
  localenv=$(pyenv version)
  pyenv activate medconv

  dicoms=$(find ./ -type f \( -name "*dcm" \))
  while read -r dicom; do
    mp4=${dicom%.*}.mp4
    if [ ! -f "$mp4" ]; then
      medconv --src "$dicom" - to-video;
    else
      echo "$mp4 already exists. Skipping conversion."
    fi
  done <<< $dicoms

  pyenv activate $localenv
}

video2gif() {
  input=$1
  filename=$(basename $input)
  output="${filename%.*}.gif"

  echo "Convert $input to $output"

  TMP_DIR="/tmp/video2gif-frames-$filename"
  mkdir "$TMP_DIR"
  ffmpeg -i "$input" -vf scale=320:-1:flags=lanczos,fps=10 "$TMP_DIR/ffout%03d.png"
  convert -loop 0 "$TMP_DIR/ffout*.png" "$output"

  rm -r "$TMP_DIR"

  echo "Done!"
}

if [ -z $IS_OSX ]; then
    alias pbcopy="xclip -sel clip"
    alias ll="ls -al"
fi

source $ZSH_INSTALL_DIR/docker_utils.sh


#
# custom ssh keys
#

SSH_KEY="~/.ssh/ec2-ireland-sven.pem"
if [ -f "$SSH_KEY" ]; then
  ssh-add "$SSH_KEY"  &> /dev/null
fi
