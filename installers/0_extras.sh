#!/bin/bash
set -e

if command -v yum >/dev/null 2>&1; then
	sudo yum install -y zsh git vim less source-highlight \
		 the_silver_searcher fzf
elif command -v apt-get >/dev/null 2>&1; then
	sudo apt-get install -y zsh git vim less source-highlight \
		libclang-3.4-dev clang-3.4 silversearcher-ag fzf
elif command -v brew >/dev/null 2>&1; then
	brew install zsh vim source-highlight \
		coreutils the_silver_searcher
else
	echo "ERROR: don't know how to install extras!"
	exit
fi
