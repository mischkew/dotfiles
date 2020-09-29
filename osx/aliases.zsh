if [ "$PLATFORM" = "Darwin" ]; then
  # Use special apropos script on OSX to speed up
  # completion checks.
  # See https://apple.stackexchange.com/a/375629
  alias apropos="$DOTFILES/osx/apropos.macos_10.15.1"
fi			      
