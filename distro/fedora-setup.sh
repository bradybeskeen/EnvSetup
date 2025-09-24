#!/bin/sh

# Install build dependencies (example for Fedora)
sudo dnf upgrade -y
sudo dnf install make cmake ninja-build gettext libtool autoconf automake cmake g++ pkg-config unzip curl minisign

. ./general.sh
