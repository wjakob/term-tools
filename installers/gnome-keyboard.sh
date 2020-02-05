#!/bin/bash

if type gsettings 2>/dev/null; then
    gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"
fi
