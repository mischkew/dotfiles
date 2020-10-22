# add homebrew sbin path
export PATH="/usr/local/sbin:$PATH"

# linuxbrew
if [ "$PLATFORM" = "Linux" ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi