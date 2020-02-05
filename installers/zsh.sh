#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.zshrc ]; then
    echo "Error: file already exists.  Move or delete ~/.zshrc"
else
    echo "Installing .zshrc .."
	cp $TERM_TOOLS/config/zshrc ~/.zshrc
fi
