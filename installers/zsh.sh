#!/bin/bash
set -e

ZSH="$HOME/.oh-my-zsh"

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ ! -d "$ZSH" ]; then
	git clone https://github.com/robbyrussell/oh-my-zsh.git $ZSH
fi

if [ ! -e "$ZSH/custom/themes/wjakob.zsh-theme" ]; then
	mkdir -p $ZSH/themes
	ln $@ -s $TERM_TOOLS/config/wjakob.zsh-theme $ZSH/themes/wjakob.zsh-theme
fi

if [ ! -d "$ZSH/custom/plugins/zsh-syntax-highlighting" ]; then
	mkdir -p $ZSH/custom/plugins
	git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
fi

if [ -e ~/.zshrc ]; then
	if [ "$1" == "-f" ]; then
		cp $TERM_TOOLS/config/zshrc ~/.zshrc
	else
		echo "Error: .zshrc exists.  Move or delete ~/.zshrc"
		exit 1
	fi
else
	cp $TERM_TOOLS/config/zshrc ~/.zshrc
fi
