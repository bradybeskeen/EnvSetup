#!/bin/sh

# remove bin
sudo rm -rf /usr/local/bin/nvim

# remove lib
sudo rm -rf /usr/local/lib/nvim

# remove share
sudo rm -rf /usr/local/share/nvim
sudo rm -rf /usr/local/share/applications
sudo rm -rf /usr/local/share/icons
sudo rm -rf /usr/local/share/man

# delete nvim files in /opt
sudo rm -rf /opt/nvim-*
