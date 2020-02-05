#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.gdbinit ]; then
    echo "Error: file already exists.  Move or delete ~/.gdbinit"
    exit 1
else
    echo "Installing .gdbinit .."
    ln -s $TERM_TOOLS/config/gdbinit ~/.gdbinit
fi
