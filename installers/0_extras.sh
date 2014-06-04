#!/bin/bash
set -e

if command -v apt-get >/dev/null 2>&1; then
	sudo apt-get install -y zsh git-all vim less source-highlight \
		libclang-3.4-dev clang-3.4 silversearcher-ag googlecl 
if command -v brew >/dev/null 2>&1; then
	brew install zsh vim source-highlight googlecl the_silver_searcher
else
	echo "ERROR: don't know how to install extras!"
	exit
fi
