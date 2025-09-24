#!/bin/sh

# Install build dependencies (example for Debian/Ubuntu)
sudo apt-get update
sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl minisign

. ./general.sh
