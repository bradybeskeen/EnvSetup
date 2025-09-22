#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# remove bin sym link
sudo rm -f /usr/local/bin/nvim
sudo rm -f /usr/local/share/man/man1/nvim.1

# delete nvim files in /opt
sudo rm -rf /opt/nvim-*

echo "Neovim has been uninstalled."
