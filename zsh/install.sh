#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
echo "Linked ~/.zshrc -> $SCRIPT_DIR/.zshrc"
