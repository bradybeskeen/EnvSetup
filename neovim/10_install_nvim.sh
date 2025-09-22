#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Neovim filename
NVIM_FILENAME=nvim-linux-x86_64
INSTALL_DIR="/opt/$NVIM_FILENAME"

# Get the nvim executable
curl -LO "https://github.com/neovim/neovim/releases/download/stable/$NVIM_FILENAME.tar.gz"

# Unpack the tarball
tar xzvf "$NVIM_FILENAME.tar.gz"

# Remove the tarball
rm -f "$NVIM_FILENAME.tar.gz"

# Remove old installation if it exists
if [ -d "$INSTALL_DIR" ]; then
  sudo rm -rf "$INSTALL_DIR"
fi

# Move the nvim directory to /opt
sudo mv $NVIM_FILENAME /opt

# Create a symbolic link to the nvim executable
sudo ln -sf "$INSTALL_DIR/bin/nvim" "/usr/local/bin/nvim"

echo "Neovim installed successfully!"
