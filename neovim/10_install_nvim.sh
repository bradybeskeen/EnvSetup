#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Get OS name
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Map 'darwin' to 'macos'
if [ "$OS" = "darwin" ]; then
	OS="macos"
fi

# Get Architecture
ARCH=$(uname -m)

# Normalize Architecture names
case "$ARCH" in
"x86_64")
	ARCH="x86_64"
	;;
"aarch64" | "arm64")
	ARCH="arm64"
	;;
"armv7l")
	echo "Error: You are running a 32-bit OS (armv7l)."
	echo "Neovim releases only support 64-bit (arm64) or x86_64."
	exit 1
	;;
*)
	echo "Unsupported architecture: $ARCH"
	exit 1
	;;
esac

# Neovim filename
NVIM_FILENAME="nvim-$OS-$ARCH"
INSTALL_DIR="/opt/$NVIM_FILENAME"

echo "Detected System: $OS"
echo "Detected Arch:   $ARCH"
echo "Target Filename: $NVIM_FILENAME"
echo "--------------------------------"

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

# Create the man page directory if it doesn't exist
sudo mkdir -p /usr/local/share/man/man1

# Symlink the man page
sudo ln -sf "$INSTALL_DIR/share/man/man1/nvim.1" "/usr/local/share/man/man1/nvim.1"

echo "Neovim installed successfully!"
