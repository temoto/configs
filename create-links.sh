#!/bin/sh
link="ln -nfs"
src="`pwd`"
case $0 in /*) src="`dirname $0`";; esac

mkdir -p ~/bin
$link "$src/bin/install-pacaur" ~/bin/
$link "$src/bash_profile" ~/.bash_profile
$link "$src/bashrc" ~/.bashrc
$link "$src/gvimrc" ~/.gvimrc
$link "$src/inputrc" ~/.inputrc
$link "$src/vim" ~/.vim
$link "$src/vimrc" ~/.vimrc
$link "$src/xbindkeysrc" ~/.xbindkeysrc
$link "$src/xinitrc" ~/.xinitrc
$link "$src/zshenv" ~/.zshenv
$link "$src/zshrc" ~/.zshrc
