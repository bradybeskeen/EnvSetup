#!/bin/sh

# unlink bin
sudo unlink /usr/local/bin/nvim

# unlink lib
sudo unlink /usr/local/lib/nvim

# unlink share
sudo unlink /usr/local/share/nvim
sudo unlink /usr/local/share/applications
sudo unlink /usr/local/share/icons
sudo unlink /usr/local/share/man

# delete nvim files in /opt
sudo rm -rf /opt/nvim-*
