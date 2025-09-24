#!/bin/sh

# Get our path
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Link the vimrc file
ln -sf "$SCRIPT_DIR/vimrc" "$HOME/.vimrc"
