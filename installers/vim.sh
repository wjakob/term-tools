#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.vim ]; then
    echo "Error: .vim exists.  Move or delete ~/.vim"
    exit 1
fi

if [ -e ~/.vimrc ]; then
    echo "Error: .vimrc exists.  Move or delete ~/.vimrc"
    exit 1
fi

# Install dotfiles (this will fail it already exists so we are safe)
ln -s $TERM_TOOLS/config/vimrc ~/.vimrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
