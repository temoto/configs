#!/bin/sh
link="ln -nfs"
src=`python -c "import os, sys; print(os.path.dirname(os.path.abspath(os.path.relpath(sys.argv[1]))))" $0`

mkdir -p ~/bin
$link "$src/bash_profile" ~/.bash_profile
$link "$src/bashrc" ~/.bashrc
$link "$src/bin/install-pacaur" ~/bin/
$link "$src/gitconfig" ~/.gitconfig
$link "$src/gitignore" ~/.gitignore
$link "$src/gvimrc" ~/.gvimrc
$link "$src/hgrc" ~/.hgrc
$link "$src/inputrc" ~/.inputrc
$link "$src/terminator" ~/.config/terminator/config
$link "$src/vim" ~/.vim
$link "$src/vimrc" ~/.vimrc
$link "$src/xbindkeysrc" ~/.xbindkeysrc
$link "$src/xinitrc" ~/.xinitrc
$link "$src/zshenv" ~/.zshenv
$link "$src/zshrc" ~/.zshrc
