#!/bin/bash

DEP=( exuberant-ctags cscope git )
VIMRC=.vimrc

echo "====Install dep package===="
for dep in "${DEP[@]}"
do
	if [ -z "`dpkg -l | grep $dep`" ]; then
		sudo apt-get install $dep
	fi
done



echo "====Install Vundle===="
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


echo "====Install .vimrc===="
cp $VIMRC ~/

echo "====Done===="
