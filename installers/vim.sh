#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.config/nvim ]; then
    echo "Error: ~/.config/nvim exists.  Move or delete the directory."
    exit 1
fi

mkdir -p ~/.config/nvim
ln -s $TERM_TOOLS/config/init.lua ~/.config/nvim/init.lua
