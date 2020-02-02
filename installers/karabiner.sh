#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

mkdir -p ~/.config/karabiner/assets/complex_modifications
ln $@ -s $TERM_TOOLS/config/karabiner-wjakob.json ~/.config/karabiner/assets/complex_modifications
