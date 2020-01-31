#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

ln $@ -s $TERM_TOOLS/config/less ~/.less
