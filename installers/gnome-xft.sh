#!/bin/bash

if type gsettings 2>/dev/null; then
    gsettings set org.gnome.settings-daemon.plugins.xsettings hinting slight
    gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing rgba
fi
