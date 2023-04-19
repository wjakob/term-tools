#!/bin/bash
set -e

if command -v apt >/dev/null 2>&1; then
    sudo apt install -y vim git clang-15 lldb-15 libc++-15-dev libc++abi-15-dev fzf texlive xorg-dev cmake  zsh git vim less source-highlight silversearcher-ag fzf ninja-build tmux fd-find curl imagemagick
elif command -v brew >/dev/null 2>&1; then
    brew install zsh vim source-highlight less lesspipe llvm \
        coreutils the_silver_searcher tmux fd curl
else
    echo "ERROR: don't know how to install extras!"
    exit 1
fi
