#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.inputrc ]; then
    echo "Error: file already exists.  Move or delete ~/.inputrc"
    exit 1
else
    echo "Installing .inputrc .."
    ln -s $TERM_TOOLS/config/inputrc ~/.inputrc
fi
