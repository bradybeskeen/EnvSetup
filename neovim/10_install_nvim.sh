#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Neovim filename
NVIM_FILENAME=nvim-linux-x86_64

# Get the nvim executable
curl -LO "https://github.com/neovim/neovim/releases/download/stable/$NVIM_FILENAME.tar.gz"

# Unpack the tarball
tar xzvf "$NVIM_FILENAME.tar.gz"

# Remove the tarball
rm -f "$NVIM_FILENAME.tar.gz"

# Move the nvim directory to /opt
sudo mv $NVIM_FILENAME /opt

# Sym link the nvim files into the filesystem
sudo ln -s /opt/$NVIM_FILENAME/bin/* /usr/local/bin/
sudo ln -s /opt/$NVIM_FILENAME/lib/* /usr/local/lib/
sudo ln -s /opt/$NVIM_FILENAME/share/* /usr/local/share/

