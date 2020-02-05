#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir -p ~/.config/karabiner/assets/complex_modifications
    $FNAME=~/.config/karabiner/assets/complex_modifications/karabiner-wjakob.json

    if [ -e $FNAME ]; then
        echo "Error: file already exists.  Move or delete $FNAME"
        exit 1
    else
        echo "Installing karabiner-wjakob.json .."
        ln -s $TERM_TOOLS/config/karabiner-wjakob.json $FNAME
    fi
else
    echo "Skipping (darwin only)"
fi
