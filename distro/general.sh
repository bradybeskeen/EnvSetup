#!/bin/sh
# Distro Agnostic Functions

# Install Go Mono Nerf Font
install_nerd_font() {
	wget -O gomono_nerd.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Go-Mono.zip
	unzip -d gomono_nerd gomono_nerd.zip
	mkdir -p $HOME/.local/share/fonts
	cp gomono_nerd/*.ttf $HOME/.local/share/fonts/
	rm -rf gomono_nerd*
	fc-cache -f
	echo "Restart your terminal to apply"
}

install_node_js() {
	# Download and install nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

	# in lieu of restarting the shell
	\. "$HOME/.nvm/nvm.sh"

	# Download and install Node.js:
	nvm install 22

	# Verify the Node.js version:
	node -v # Should print "v22.19.0".

	# Verify npm version:
	npm -v # Should print "10.9.3".
}

install_lua() {
	# Get Lua from remote
	curl -L -R -O https://www.lua.org/ftp/lua-5.4.8.tar.gz
	tar zxf lua-5.4.8.tar.gz
	cd lua-5.4.8
	sudo make install
	cd ..

	# Get LuaRocks from remote
	curl -L -R -O https://luarocks.org/releases/luarocks-3.12.2.tar.gz
	tar zxpf luarocks-3.12.2.tar.gz
	cd luarocks-3.12.2
	./configure --lua-version=5.4 --with-lua-bin=/usr/local/bin
	make && sudo make install
	cd ..

	rm -rf lua-5.4.8.tar.gz luarocks-3.12.2.tar.gz
	sudo mv -f lua-5.4.8 luarocks-3.12.2 /opt
}

# TODO: One day call these conditionally only if not already in system
install_nerd_font
install_node_js
install_lua
