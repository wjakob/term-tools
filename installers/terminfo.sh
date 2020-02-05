#!/bin/bash
set -e

echo "Installing terminfo for tmux (needed for italics support) .."
tic -x $TERM_TOOLS/config/tmux.terminfo
