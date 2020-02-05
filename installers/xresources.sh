#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [[ "$OSTYPE" == "linux"* ]]; then
	if [ -e ~/.Xresources ]; then
        echo "Error: file already exists.  Move or delete ~/.Xresources"
        exit -1
    else
        echo "Installing .Xresources .."
        ln -s $TERM_TOOLS/config/Xresources ~/.Xresources
	fi
else
    echo "Skipping (linux only)"
fi
