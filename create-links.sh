#!/bin/sh
link="ln --force --no-dereference --symbolic"
src=`python -c "import os, sys; print(os.path.dirname(os.path.abspath(os.path.relpath(sys.argv[1]))))" $0`

mkdir -p ~/bin
mkdir -p ~/.config/terminator
$link "$src/bash_profile" ~/.bash_profile
$link "$src/bashrc" ~/.bashrc
$link "$src/bin/install-pacaur" ~/bin/
$link "$src/gitconfig" ~/.gitconfig
$link "$src/gitignore" ~/.gitignore
$link "$src/gvimrc" ~/.gvimrc
$link "$src/hgrc" ~/.hgrc
$link "$src/inputrc" ~/.inputrc
$link "$src/sublime-text-2" ~/.config/sublime-text-2
$link "$src/sublime-text-3" ~/.config/sublime-text-3
$link "$src/terminator" ~/.config/terminator/config
$link "$src/vim" ~/.vim
$link "$src/vimrc" ~/.vimrc
$link "$src/xbindkeysrc" ~/.xbindkeysrc
$link "$src/xinitrc" ~/.xinitrc
$link "$src/zshenv" ~/.zshenv
$link "$src/zshrc" ~/.zshrc
