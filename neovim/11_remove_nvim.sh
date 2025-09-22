#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# remove bin sym link
sudo unlink /usr/local/bin/nvim

# delete nvim files in /opt
sudo rm -rf /opt/nvim-*

echo "Neovim has been uninstalled."
