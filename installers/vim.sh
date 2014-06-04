#!/bin/bash
set -e

if [ -e ~/.vim ]; then
	if [ "$1" == "-f" ]; then
		echo "Note: deleting ~/.vim"
		rm -rf ~/.vim
	else
		echo "Error: .vim exists.  Move or delete ~/.vim"
		exit 1
	fi
fi

# Install dotfiles (this will fail it already exists so we are safe)
echo Installing .vimrc
ln $@ -s $TERM_TOOLS/config/vimrc ~/.vimrc
echo Installing .gvimrc
ln $@ -s $TERM_TOOLS/config/gvimrc ~/.gvimrc

echo Installing Vundle
mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install plugins
echo Installing Vundle plugins..
vim +PluginInstall +qall
