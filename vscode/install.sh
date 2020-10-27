#!/bin/sh

DOTFILES_ROOT="$(realpath "$(dirname "$0")/..")"

if command -v code >/dev/null; then
  if [ "$(uname -s)" = "Darwin" ]; then
    VSCODE_HOME="$HOME/Library/Application Support/Code"
  else
    VSCODE_HOME="$HOME/.config/Code"
  fi
  mkdir -p "$VSCODE_HOME/User"

  ln -sf "$DOTFILES_ROOT/vscode/settings.json" "$VSCODE_HOME/User/settings.json"
  ln -sf "$DOTFILES_ROOT/vscode/keybindings.json" "$VSCODE_HOME/User/keybindings.json"
  ln -sf "$DOTFILES_ROOT/vscode/snippets" "$VSCODE_HOME/User/snippets"

  while read -r module; do
    code --install-extension "$module" || true
  done <"$DOTFILES_ROOT/vscode/extensions.txt"
else
  fail "vscode not found"
  exit 1
fi
