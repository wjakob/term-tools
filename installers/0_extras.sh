#!/bin/bash
set -e

if command -v apt >/dev/null 2>&1; then
    sudo apt install -y zsh git vim less source-highlight \
        clang-9 clangd-9 lldb-9 clang-tools-9 clang clangd lldb clang-tools \
        libc++abi1-9  libc++abi-9-dev libc++1-9 libc++-9-dev \
        silversearcher-ag fzf ninja-build tmux
elif command -v brew >/dev/null 2>&1; then
    brew install zsh vim source-highlight less lesspipe llvm \
        coreutils the_silver_searcher tmux
else
    echo "ERROR: don't know how to install extras!"
    exit
fi
