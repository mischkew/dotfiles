# dotfiles repository
export ZSH_INSTALL_DIR=$(dirname $(readlink ~/.zshrc))

# terminal capabilities
export TERM=xterm-256color

# Choose your fav editor
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -c"

# nvm lazy loading
export NVM_LAZY_LOAD=true

# load antibody package manager
source <(antibody init)
antibody bundle < "$ZSH_INSTALL_DIR/.antibody-bundles"

#
# configure autocompletion
#

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# menu if nb items > 2
zstyle ':completion:*' menu select=2

# speed up initialization of auto complete
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit
else
  compinit -C
fi

#
# aliases
#

alias zshconfig="$EDITOR ~/.zshrc"
alias ec="emacsclient -c -n"

# pyenv
if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
    eval "$(pyenv virtualenv-init -)";
fi
