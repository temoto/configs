" My take on mswin behaviour.
" Author: Sergey Shepelev <temotor@gmail.com>

" Original file:
so $VIMRUNTIME/mswin.vim

" Combination of mswin and vim selection behaviour.
set keymodel=startsel
set selection=inclusive
set selectmode=
imap <S-Up> <C-o>V
imap <S-Down> <C-o>V

" C-v in normal mode is for block-selection, not pasting clipboard
unmap <C-v>
" But in visual mode, C-v is for pasting clipboard.
" Use C-q for block selection in visual.
vmap <C-v> "+gP
smap <C-v> "+gP

" <C-p> does neocomplcache completion
inoremap <C-p> <C-x><C-u>

" CTRL-X, Ctrl-c, Ctrl-v for insert mode operate on whole line
imap <C-x> <C-o>"+dd
inoremap <C-c> <C-o>"+yy
imap <C-v> <C-o>"+gP

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" CTRL-Tab is Next window
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" Shift-Tab is previous window
inoremap <S-Tab> <C-O><C-W>W
cnoremap <S-Tab> <C-C><C-W>W
onoremap <S-Tab> <C-C><C-W>W

