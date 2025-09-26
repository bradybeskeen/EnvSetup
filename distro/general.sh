#!/bin/sh
#
# Distro Agnostic Installer Script
#
# This script will check for the existence of each program before attempting
# to install it. Versions are managed in the configuration section below.
#
set -e

# --- Configuration ---
NERD_FONT_VERSION="3.4.0"
NVM_VERSION="0.40.3"
NODE_VERSION="22"
LUA_VERSION="5.4.8"
LUAROCKS_VERSION="3.12.2"
ZIG_VERSION="0.15.1"
GO_VERSION="1.25.1"

# --- Distro Agnostic Functions ---

# Install Go Mono Nerd Font
install_nerd_font() {
	# A simple check for one of the expected font files
	if [ -f "$HOME/.local/share/fonts/GoMonoNerdFont-Regular.ttf" ]; then
		echo "Go Mono Nerd Font appears to be installed. Skipping."
		return
	fi

	echo "Installing Go Mono Nerd Font..."
	wget -O gomono_nerd.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v${NERD_FONT_VERSION}/Go-Mono.zip"
	unzip -d gomono_nerd gomono_nerd.zip
	mkdir -p "$HOME/.local/share/fonts"
	cp gomono_nerd/*.ttf "$HOME/.local/share/fonts/"
	rm -rf gomono_nerd*
	fc-cache -f
	echo "Nerd Font installed. Restart your terminal to apply."
}

# Install Node.js via NVM
install_node_js() {
	if command -v node >/dev/null 2>&1; then
		echo "Node.js is already installed. Skipping."
		return
	fi

	echo "Installing Node.js v${NODE_VERSION}..."
	curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash

	# Source nvm for the current script session
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

	nvm install "${NODE_VERSION}"
	nvm use "${NODE_VERSION}"
	nvm alias default "${NODE_VERSION}"

	echo "Node.js installation complete."
	node -v
	npm -v
}

# Install Lua and LuaRocks
install_lua() {
	if command -v lua >/dev/null 2>&1; then
		echo "Lua is already installed. Skipping."
		return
	fi

	LUA_MAJOR_MINOR_VERSION=$(echo "$LUA_VERSION" | cut -d'.' -f1-2)
	echo "Installing Lua v${LUA_VERSION} and LuaRocks v${LUAROCKS_VERSION}..."

	# Install Lua
	curl -L -R -O "https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz"
	tar zxf "lua-${LUA_VERSION}.tar.gz"
	cd "lua-${LUA_VERSION}"
	make linux
	make test
	sudo make install
	cd ..

	# Install LuaRocks
	curl -L -R -O "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"
	tar zxpf "luarocks-${LUAROCKS_VERSION}.tar.gz"
	cd "luarocks-${LUAROCKS_VERSION}"
	./configure --lua-version="${LUA_MAJOR_MINOR_VERSION}" --with-lua-bin=/usr/local/bin
	make && sudo make install
	cd ..

	# Cleanup
	sudo mv -f "lua-${LUA_VERSION}" "luarocks-${LUAROCKS_VERSION}" /opt
	rm -f "lua-${LUA_VERSION}.tar.gz" "luarocks-${LUAROCKS_VERSION}.tar.gz"
	echo "Lua and LuaRocks installation complete."
}

# Install Zig
install_zig() {
	if command -v zig >/dev/null 2>&1; then
		echo "Zig is already installed. Skipping."
		return
	fi

	echo "Installing Zig v${ZIG_VERSION}..."
	PUBKEY="RWSGOq2NVecA2UPNdBUZykf1CCb147pkmdtYxgb3Ti+JO/wCYvhbAb/U"
	ZIG_DIRECTORY="zig-$(uname -m)-$(uname | tr '[:upper:]' '[:lower:]')-${ZIG_VERSION}"
	TARBALL_NAME="${ZIG_DIRECTORY}.tar.xz"
	MIRRORS_URL="https://ziglang.org/download/community-mirrors.txt"

	command -v curl >/dev/null 2>&1 || {
		echo >&2 "Error: 'curl' is required."
		exit 1
	}
	command -v shuf >/dev/null 2>&1 || {
		echo >&2 "Error: 'shuf' is required."
		exit 1
	}
	command -v minisign >/dev/null 2>&1 || {
		echo >&2 "Error: 'minisign' is required."
		exit 1
	}

	curl -sL "$MIRRORS_URL" | shuf | while IFS= read -r mirror_url; do
		[ -z "$mirror_url" ] && continue
		echo "---" && echo "Trying mirror: $mirror_url"
		TARBALL_URL="${mirror_url}/${TARBALL_NAME}"
		SIGNATURE_URL="${mirror_url}/${TARBALL_NAME}.minisig"

		if curl --fail --location --progress-bar -o "$TARBALL_NAME" "$TARBALL_URL" &&
			curl --fail --location --progress-bar -o "${TARBALL_NAME}.minisig" "$SIGNATURE_URL"; then
			if minisign -V -P "$PUBKEY" -m "$TARBALL_NAME"; then
				echo "Success! Tarball downloaded and verified." && break
			else
				echo "SIGNATURE VERIFICATION FAILED. Trying next mirror..."
				rm -f "$TARBALL_NAME" "${TARBALL_NAME}.minisig"
			fi
		else
			echo "Failed to download from this mirror. Trying next..."
			rm -f "$TARBALL_NAME" "${TARBALL_NAME}.minisig"
		fi
	done

	rm -f "${TARBALL_NAME}.minisig"
	tar xf "$TARBALL_NAME"
	rm -f "$TARBALL_NAME"

	[ -d "/opt/$ZIG_DIRECTORY" ] && sudo rm -rf "/opt/$ZIG_DIRECTORY"
	sudo mv -f "$ZIG_DIRECTORY" /opt
	sudo ln -sf "/opt/$ZIG_DIRECTORY/zig" /usr/local/bin/zig
	echo "Zig installation complete."
}

# Install Rust
install_rust() {
	if command -v cargo >/dev/null 2>&1; then
		echo "Rust (via cargo) is already installed. Skipping."
		return
	fi

	echo "Installing Rust..."
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	# Add cargo to path for the current script session
	source "$HOME/.cargo/env"
	rustup update
	echo "Rust installation complete."
}

# Install Yazi file manager
install_yazi() {
	if command -v yazi >/dev/null 2>&1; then
		echo "Yazi is already installed. Skipping."
		return
	fi

	if ! command -v cargo >/dev/null 2>&1; then
		echo "Error: Rust (cargo) is required to build Yazi. Please install it first."
		exit 1
	fi

	echo "Installing Yazi..."
	git clone https://github.com/sxyazi/yazi.git
	cd yazi
	cargo build --release --locked
	sudo mv target/release/yazi target/release/ya /usr/local/bin/
	cd ..
	rm -rf yazi
	echo "Yazi installation complete."
}

# Install Go
install_go() {
	if command -v go >/dev/null 2>&1; then
		echo "Go is already installed. Skipping."
		return
	fi

	echo "Installing Go v${GO_VERSION}..."
	GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
	wget "https://go.dev/dl/${GO_TARBALL}"
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf "${GO_TARBALL}"
	rm -f "${GO_TARBALL}"

	# Add Go to PATH if it's not already there
	if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' "$HOME/.profile"; then
		echo 'export PATH=$PATH:/usr/local/go/bin' >>"$HOME/.profile"
	fi

	echo "Go installation complete. Please run 'source ~/.profile' or restart your shell."
}

# --- Execution ---
install_nerd_font
install_node_js
install_lua
install_zig
install_go
install_rust
install_yazi

echo -e "\nAll installations complete!"
