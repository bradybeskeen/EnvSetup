#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if an argument was provided. If not, print an error and usage info, then exit.
if [ -z "$1" ]; then
	echo "Error: No configuration specified." >&2
	echo "Usage: $0 [custom|lazyvim]" >&2
	exit 1
fi

# Check if the argument is one of the allowed values.
if [ "$1" != "custom" ] && [ "$1" != "lazyvim" ]; then
	echo "Error: Invalid configuration '$1' specified." >&2
	echo "Please use 'custom' or 'lazyvim'." >&2
	exit 1
fi

CONFIG_NAME=$1

# Find the absolute path of the directory where this script is located
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Define the source directory and check if it exists
SOURCE_DIR="$SCRIPT_DIR/$CONFIG_NAME"
if [ ! -d "$SOURCE_DIR" ]; then
	echo "Error: Source configuration directory not found at '$SOURCE_DIR'" >&2
	exit 1
fi

# Create nvim config directory if it doesn't exist
mkdir -p ~/.config/nvim

# Create or overwrite the symbolic link using the script's location
# to build a full, absolute path to the source `nvim` folder.
ln -sf "$SOURCE_DIR/"* ~/.config/nvim/

echo "Neovim config '$CONFIG_NAME' linked successfully!"
