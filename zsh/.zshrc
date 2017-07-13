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
export EDITOR="emacsclient -c"

# nvm lazy loading
export NVM_LAZY_LOAD=true

# load antibody package manager
source <(antibody init)
antibody bundle < "$ZSH_INSTALL_DIR/.antibody-bundles"

#
# modify path
#

# add homebrew sbin path
export PATH="/usr/local/sbin:$PATH"

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
it2prof() { echo -e "\033]50;SetProfile=$1\a" }

# pyenv
if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
    eval "$(pyenv virtualenv-init -)";
fi
