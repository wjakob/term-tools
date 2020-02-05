#!/bin/bash

if [[ "$OSTYPE" == "linux"* ]]; then
    if type gsettings 2>/dev/null; then
        echo "Mapping caps lock to escape .."
        gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
    else
        echo "gsettings not found!"
        exit 1
    fi
else
    echo "Skipping (linux only)"
fi
