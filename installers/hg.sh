#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.hgrc ]; then
	if [ "$1" == "-f" ]; then
		echo "Note: deleting ~/.hgrc"
		rm -rf ~/.hgrc
	else
		echo "Error: .hgrc exists.  Move or delete ~/.hgrc"
		exit 1
	fi
fi

cp $TERM_TOOLS/config/hgrc ~/.hgrc
