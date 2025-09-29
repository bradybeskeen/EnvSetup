#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Find the absolute path of the directory where this script is located
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Unlink the existing nvim config
rm -rf  ~/.config/nvim/

echo "Neovim config removed successfully!"
