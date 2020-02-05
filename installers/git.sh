#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.gitconfig ]; then
    echo "Error: file already exists.  Move or delete ~/.gitconfig"
    exit 1
else
    echo "Installing .gitconfig .."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ln $@ -s $TERM_TOOLS/config/gitconfig-osx ~/.gitconfig
    else
        ln $@ -s $TERM_TOOLS/config/gitconfig-linux ~/.gitconfig
    fi
fi
