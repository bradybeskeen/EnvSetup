#!/bin/sh

# --- Configuration ---
ZED_INSTALL_SCRIPT="https://zed.dev/install.sh"
ZED_CONFIG_DIR="$HOME/.config/zed"
SCRIPT_DIR="$(dirname "$0")"

# --- 1. Install Zed ---
echo "Installing Zed..."
if ! curl -fsSL "$ZED_INSTALL_SCRIPT" | sh; then
    echo "ERROR: Zed installation failed." >&2
    exit 1
fi
echo "Zed installed successfully."

# --- 2. Create Config Directory ---
echo "Ensuring config directory exists at $ZED_CONFIG_DIR..."
if ! mkdir -p "$ZED_CONFIG_DIR"; then
    echo "ERROR: Failed to create config directory." >&2
    exit 1
fi
echo "Config directory ready."

# --- 3. Copy Config Files ---
echo "Copying config files (keymap.json, settings.json)..."

# Check if the source files exist before attempting to copy
if [[ -f "$SCRIPT_DIR/keymap.json" ]] && [[ -f "$SCRIPT_DIR/settings.json" ]]; then
    if ! cp "$SCRIPT_DIR/keymap.json" "$SCRIPT_DIR/settings.json" "$ZED_CONFIG_DIR"; then
        echo "ERROR: Failed to copy config files." >&2
        exit 1
    fi
    echo "Config files copied to $ZED_CONFIG_DIR."
else
    echo "WARNING: Source config files (keymap.json and/or settings.json) not found in the script's directory. Skipping config copy." >&2
fi

echo ""
echo "Installation and setup finished!"
