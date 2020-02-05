#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.lldbinit ]; then
    echo "Error: file already exists.  Move or delete ~/.lldbinit"
    exit 1
else
    echo "Installing .lldbinit .."
    ln -s $TERM_TOOLS/config/lldbinit ~/.lldbinit
fi
