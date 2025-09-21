#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Install build dependencies (example for Debian/Ubuntu)
sudo apt-get update
sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl

# Clone the repository
git clone https://github.com/neovim/neovim.git
cd neovim

# Checkout the stable version and build
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo

# Install Neovim
sudo make install

echo "Neovim has been successfully installed."
echo "To uninstall it later, navigate to this directory and run 'sudo make uninstall'"
