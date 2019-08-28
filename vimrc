" Author: Sergey Shepelev <temotor@gmail.com>

if has("syntax")
	syntax on
endif
"filetype on
filetype off " required for Vundle
"filetype plugin on " Vundle related
"filetype indent on " Vundle related

set mouse=a
set background=dark
set nocompatible
set viminfo+=h
set ttyfast

set expandtab tabstop=4 shiftwidth=4 softtabstop=4 autoindent smartindent
set backspace=indent,eol,start
set history=2000
set undolevels=200

set ffs=unix,mac,dos
set listchars=tab:>-,trail:-
set nowrap showbreak=+ ignorecase

set number showmode showmatch incsearch hlsearch lazyredraw wildmenu ruler
set splitright
set statusline=%F%m%r%h%w\ [%{&ff},\ %Y]\ [0x\%02.2B]\ [%04l,%04v][%p%%/%L]
set cmdheight=2 showcmd laststatus=2

" Begin Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'editorconfig/editorconfig-vim'
call vundle#end()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
" End Vundle

" Begin excerpt from mswin.vim
" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]
" backspace in Visual mode deletes selection
vnoremap <BS> d
" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <C-O>u
" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>
" End excerpt from mswin.vim

" <C-p> does neocomplcache completion
inoremap <C-p> <C-x><C-u>

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" Shift-Tab is previous window
inoremap <S-Tab> <C-O><C-W>W
cnoremap <S-Tab> <C-C><C-W>W
onoremap <S-Tab> <C-C><C-W>W

" open/save/exit
ino <C-e> <C-o>:e!<Space>
nno <C-e> :e!<Space>
ino <M-e> <C-o>:tabe!<Space>
nno <M-e> :tabe!<Space>
ino <C-b> <C-o>:bu!<Space>
ino <M-b> <C-o>:tab sb<Space>
ino <F2> <C-o>:update<CR>
ino <C-s> <C-o>:update<CR>
ino <silent><C-\> <C-o>:q!<CR>
nno <silent><C-\> :q!<CR>
vno <silent><C-\> :q!<CR>
ino <silent><M-q> <C-o>:bd!<CR>
nno <silent><M-q> :bd!<CR>

" NERDtree
ino <silent><F3> <C-o>:NERDTreeToggle<CR>
nno <silent><F3> :NERDTreeToggle<CR>
vno <silent><F3> :<C-w>NERDTreeToggle<CR>
let g:NERDTreeSplitVertical = 1
let g:NERDTreeIgnore = ['\.pyc', '\.hi', '\.o']

" erase word
ino <C-BS> <C-w>
cno <C-BS> <C-w>
ino <M-BS> <C-o>daw
ino <C-Del> <C-Right><C-w>
ino <C-kDel> <C-Right><C-w>
ino <M-Del> <Right><C-o>daw
ino <M-kDel> <Right><C-o>daw

" erase line
ino <C-k>    <C-o>"_dd
ino <C-Del>  <C-o>"_dd
ino <C-kDel> <C-o>"_dd

" join lines
ino <silent><C-j> <C-o>J

" sort
vno <M-s> :sort<CR>

" search
ino <M-/> <C-o>/\v
nno <M-/> /\v
vno <M-/> /\v
vno / /\v
ino <M-n> <C-o>n
nno <M-n> n
vno <M-n> n
cno <M-n> <CR>n
ino <silent><M-F3> <C-o>:let @/=""<CR>
nno <silent><M-F3> :let @/=""<CR>
ino <C-h> <C-o>:%s/\v
vno <C-h> :s/\v

" browsing
ino <M-PageUp> <C-o>''
ino <M-PageDown> <C-o>'.
ino <M-c> <C-o>:
nno <M-c> :
vno <M-c> :
ino c <C-o>:
ino <C-^> <C-o><C-^>
ino <silent><M-Left> <C-o><C-t>
nno <silent><M-Left> <C-t>
ino <silent><M-Right> <C-o><C-]>
nno <silent><M-Right> <C-]>
ino <M-C-Left> <C-o><C-o>
nno <M-C-Left> <C-o>
ino <M-C-Right> <C-o><C-i>
nno <M-C-Right> <C-i>
ino <C-Space> <C-x><C-o>

" diff
com! DiffOrig diffoff! | vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis


" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
"let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_max_list = 17
let g:neocomplcache_disable_auto_complete = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_temporary_dir = "/tmp/vim-neocomplcache"
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }


" Project plugin settings.
let g:proj_window_width = 48


" filetype specific options
" =========================

let python_highlight_all = 1
" Don't let sql completion ruin your insert-mode experience.
" Annoying completions on Left/Right keys. Impossible to move cursor!
let g:ftplugin_sql_omni_key_left = 'stub'
let g:ftplugin_sql_omni_key_right = 'stub'
let g:terraform_align = 1


" python has 4 spaces instead of tabs
augroup python
	au!
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter *.py setlocal expandtab
	au BufWritePre *.py silent! %s/\v(\ +)$//
augroup END

" vimrc uses tabs
augroup vimrc
	au!
	au BufEnter,BufWinEnter *vimrc setlocal noexpandtab
augroup END
