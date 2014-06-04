#!/bin/bash
set -e

if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	if [ -e ~/.Xmodmap ]; then
		if [ "$1" == "-f" ]; then
			echo "Note: deleting ~/.Xmodmap"
			rm -rf ~/.Xmodmap
		else
			echo "Error: .Xmodmap exists.  Move or delete ~/.Xmodmap"
			exit 1
		fi
	fi
	echo "Installing .Xmodmap"
	ln $@ -s $TERM_TOOLS/config/Xmodmap ~/.Xmodmap
else
	echo "Remember to map tabs lock to escape."
	echo "Instructions for OSX: http://stackoverflow.com/questions/127591/using-caps-lock-as-esc-in-mac-os-x"
	exit
fi
