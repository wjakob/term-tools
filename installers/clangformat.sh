#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.clang-format ]; then
    echo "Error: file already exists.  Move or delete ~/.clang-format"
    exit 1
else
    echo "Installing .clang-format .."
    ln -s $TERM_TOOLS/config/clang-format ~/.clang-format
fi
