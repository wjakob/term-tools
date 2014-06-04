#!/bin/bash
set -e

if [ -s /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
	echo "source-highlight: exists"
elif command -v apt-get >/dev/null 2>&1; then
	# ubuntu
	sudo apt-get install source-highlight
else
	echo "ERROR: installer not known for source-highlight"
	exit
fi

