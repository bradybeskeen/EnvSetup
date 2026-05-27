#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../general.sh"

# Install build dependencies
sudo dnf upgrade -y
sudo dnf install -y make cmake ninja-build gettext libtool autoconf automake cmake g++ pkg-config unzip curl minisign wget fontconfig

install_nerd_font
set_default_font

# Install lazygit
sudo dnf copr enable atim/lazygit -y
sudo dnf install -y lazygit
