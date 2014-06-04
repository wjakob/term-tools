#!/bin/bash
set -e

if command -v apt-get >/dev/null 2>&1; then
	sudo apt-get install -y zsh git-all vim less source-highlight \
		libclang-3.4-dev clang-3.4 silversearcher-ag googlecl 
else
	echo "ERROR: don't know how to install extras!"
	exit
fi
