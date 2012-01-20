" GVim specific options

set list
set guicursor=a:block-Cursor
set guicursor=a:blinkon0
set guioptions=aegirLt
set guifont=dejavu\ sans\ mono\ 11

" X clipboard
ino <C-Insert> <C-o>"+yy
vno <C-Insert> "+y
ino <S-Del> <C-o>"+dd
vno <S-Del> "+d
ino <S-Insert> <C-o>"+P
vno <S-Insert> "+P

" ugly notebook keyboard
ino <M-.> <C-o>"+dd
vno <M-.> "+d
ino <M-m> <C-o>"+P
vno <M-m> <C-o>"+P

" Ctrl+Space omni completion
ino <C-Space> <C-x><C-o>
