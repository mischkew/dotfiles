# dotfiles repository
export ZSH_INSTALL_DIR=$(dirname $(readlink ~/.zshrc))

# terminal capabilities
export TERM=xterm-256color

# Choose your fav editor
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -c"

# antigen path
ANTIGEN_PLUGIN=$ZSH_INSTALL_DIR/vendor/antigen.zsh

# install antigen if not done yet
if [ ! -f $ANTIGEN_PLUGIN ]; then
    (cd $ZSH_INSTALL_DIR && make install-antigen)
fi

# user path configurations
export PATH="/Users/sven/.rvm/gems/ruby-2.0.0-p247/bin:/Users/sven/.rvm/gems/ruby-2.0.0-p247@global/bin:/Users/sven/.rvm/rubies/ruby-2.0.0-p247/bin:/Users/sven/.rvm/bin:/usr/local/opt/php56/bin:/usr/local/share/zsh-completions:/Users/sven/perl5/perlbrew/bin:/Users/sven/perl5/perlbrew/perls/perl-5.16.0/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:/usr/texbin"

# load antigen package manager
source $ANTIGEN_PLUGIN

# load oh-my-zsh
antigen use oh-my-zsh

# plugin configurations (have to be set before plugins load)
export NVM_LAZY_LOAD=true  # Prevent nvm from slowing down zsh startup

# load plugins
antigen bundles <<EOBUNDLES
git
z
pyenv
command-not-found
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-completions
lukechilds/zsh-nvm
EOBUNDLES

# set shell theme
antigen theme awesomepanda

# apply all antigen configurations
antigen apply

# aliases
alias zshconfig="$EDITOR ~/.zshrc"
alias ec="emacsclient -c -n"
