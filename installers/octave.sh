#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.octaverc ]; then
    echo "Error: file already exists.  Move or delete ~/.octaverc"
    exit 1
else
    echo "Installing .octaverc .."
    ln -s $TERM_TOOLS/config/octaverc ~/.octaverc
fi
