#!/bin/bash
set -e

echo "Increasing key repeat delay to 300ms, repeat interval to 30ms .."

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Multiples of 15ms
    defaults write -g KeyRepeat -int 2
    defaults write -g InitialKeyRepeat -int 20
else
    gsettings set org.gnome.desktop.peripherals.keyboard delay 300
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
fi
