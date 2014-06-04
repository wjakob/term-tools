#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ ! -d ~/.oh-my-zsh ]; then
	wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
fi

# install oh-my-zsh config if it exists
if [ -d ~/.oh-my-zsh ]; then
	cd ~/.oh-my-zsh

	ln $@ -s $TERM_TOOLS/oh-my-zsh-custom/zsh-syntax-highlighting plugins/zsh-syntax-highlighting
	ln $@ -s $TERM_TOOLS/config/wjakob.zsh-theme themes/wjakob.zsh-theme
	cd -
else
	echo "ERROR: ~/.oh-my-zsh does not exist"
	exit 1
fi

