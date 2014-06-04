#!/bin/bash
set -e

if command -v apt-get >/dev/null 2>&1; then
	sudo apt-get install libclang-3.4-dev clang-3.4 silversearcher-ag googlecl
else
	echo "ERROR: installer not known for extras"
	exit
fi
