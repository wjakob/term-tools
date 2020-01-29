#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	if [ -e ~/.Xresources ]; then
		if [ "$1" == "-f" ]; then
			echo "Note: deleting ~/.Xresources"
			rm -rf ~/.Xresources
		else
			echo "Error: .Xresources exists.  Move or delete ~/.Xresources"
			exit 1
		fi
	fi
	echo "Installing .Xresources"
	ln $@ -s $TERM_TOOLS/config/Xresources ~/.Xresources
fi
