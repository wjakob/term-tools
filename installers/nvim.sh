#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

# Set up Neovim by linking init.lua into ~/.config/nvim
NVIM_DIR="$HOME/.config/nvim"
NVIM_INIT="$NVIM_DIR/init.lua"

if [ -e "$NVIM_INIT" ]; then
    echo "Error: file already exists. Move or delete $NVIM_INIT"
    exit 1
fi

mkdir -p "$NVIM_DIR"
echo "Installing Neovim config .."
ln -s "$TERM_TOOLS/config/init.lua" "$NVIM_INIT"

echo "Neovim config installed. Launch 'nvim' to bootstrap plugins (lazy.nvim)."
