#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.tmux.conf ]; then
    echo "Error: file already exists.  Move or delete ~/.tmux.conf"
    exit 1
else
    echo "Installing .tmux.conf .."
    ln -s $TERM_TOOLS/config/tmux.conf ~/.tmux.conf
fi
