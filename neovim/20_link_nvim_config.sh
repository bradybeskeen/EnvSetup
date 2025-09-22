#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Find the absolute path of the directory where this script is located
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Create nvim config directory if it doesn't exist
mkdir -p ~/.config/nvim

# Create or overwrite the symbolic link using the script's location
# to build a full, absolute path to the source `nvim` folder.
ln -sf "$SCRIPT_DIR/config/"* ~/.config/nvim/

echo "Neovim config linked successfully!"
