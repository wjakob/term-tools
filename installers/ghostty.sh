#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

GHOSTTY_DIR="$HOME/.config/ghostty"
GHOSTTY_CONFIG="$GHOSTTY_DIR/config"

if [ -e "$GHOSTTY_CONFIG" ]; then
    echo "Error: file already exists. Move or delete $GHOSTTY_CONFIG"
    exit 1
fi

mkdir -p "$GHOSTTY_DIR"
echo "Installing Ghostty config .."
ln -s "$TERM_TOOLS/config/ghostty" "$GHOSTTY_CONFIG"
