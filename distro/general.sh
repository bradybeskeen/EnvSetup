#!/bin/sh
# Distro Agnostic Functions

ZIG_VERSION=0.15.1

# Install Go Mono Nerf Font
install_nerd_font() {
	wget -O gomono_nerd.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Go-Mono.zip
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
	make linux
	make test
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

install_zig() {
	PUBKEY="RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U"
	ZIG_DIRECTORY="zig-$(uname -m)-$(uname | tr '[:upper:]' '[:lower:]')-${ZIG_VERSION}"
	TARBALL_NAME="${ZIG_DIRECTORY}.tar.xz"
	MIRRORS_URL="https://ziglang.org/download/community-mirrors.txt"

	command -v curl >/dev/null 2>&1 || {
		echo >&2 "Error: 'curl' is not installed. Aborting."
		exit 1
	}
	command -v shuf >/dev/null 2>&1 || {
		echo >&2 "Error: 'shuf' is not installed. Aborting."
		exit 1
	}
	command -v minisign >/dev/null 2>&1 || {
		echo >&2 "Error: 'minisign' is not installed. Aborting."
		exit 1
	}

	echo "Fetching and shuffling mirror list..."

	curl -sL "$MIRRORS_URL" | shuf | while IFS= read -r mirror_url; do
		if [ -z "$mirror_url" ]; then
			continue
		fi

		echo -e "\n---"
		echo "Trying mirror: $mirror_url"

		TARBALL_URL="${mirror_url}/${TARBALL_NAME}"
		SIGNATURE_URL="${mirror_url}/${TARBALL_NAME}.minisig"

		echo "Downloading tarball..."
		if ! curl --fail --location --progress-bar -o "$TARBALL_NAME" "$TARBALL_URL"; then
			echo "Failed to download tarball from this mirror. Trying next..."
			continue
		fi

		echo "Downloading signature..."
		if ! curl --fail --location --progress-bar -o "${TARBALL_NAME}.minisig" "$SIGNATURE_URL"; then
			echo "Failed to download signature from this mirror. Trying next..."
			rm -f "$TARBALL_NAME"
			continue
		fi

		echo "Verifying signature..."
		if minisign -V -P "$PUBKEY" -m "$TARBALL_NAME"; then
			echo -e "\nSuccess! Tarball downloaded and verified."
			echo "   File: $TARBALL_NAME"
			echo "   From: $mirror_url"
			return 0
		else
			echo "SIGNATURE VERIFICATION FAILED. This file is not safe. Trying next mirror..."
			rm -f "$TARBALL_NAME" "${TARBALL_NAME}.minisig"
			continue
		fi
	done

	# Remove minisig file
	rm ${TARBALL_NAME}.minisig
	# Extract tar
	tar xf $TARBALL_NAME
	# Remove the tarball
	rm ${TARBALL_NAME}

	# If the zig dir exists in target then remove
	if [ -d "/opt/$ZIG_DIRECTORY" ]; then
		echo "Removing existing installation at /opt/$ZIG_DIRECTORY..."
		sudo rm -rf "/opt/$ZIG_DIRECTORY"
	fi
	# Move the dir over
	sudo mv -f $ZIG_DIRECTORY /opt
	# Sym link the zig binary into /usr/local/bin
	sudo ln -s /opt/$ZIG_DIRECTORY/zig /usr/local/bin/
}

install_rust() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

install_go() {
	rm -rf /usr/local/go && tar -C /usr/local -xzf go1.25.1.linux-amd64.tar.gz
	echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.profile
	source ~/.profile
	go version
}

# TODO: One day call these conditionally only if not already in system
install_nerd_font
install_node_js
install_lua
install_zig
install_rust
