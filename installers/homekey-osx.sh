#!/bin/bash
set -e

if [[ "`uname`" == "Darwin" ]]; then
	mkdir -p ~/Library/KeyBindings
	cp $TERM_TOOLS/config/DefaultKeyBinding.dict ~/Library/KeyBindings
fi
