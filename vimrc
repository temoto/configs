" Author: Sergey Shepelev <temotor@gmail.com>

syntax on
filetype on
filetype plugin on
filetype indent on

set mouse=a

set background=dark
let g:solarized_italic = 0
colors solarized

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
set laststatus=2
set statusline=%F%m%r%h%w\ [%{&ff},\ %Y]\ [0x\%02.2B]\ [%04l,%04v][%p%%/%L]
set cmdheight=2

" Begin excerpt from mswin.vim
" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]
" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x
" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
" CTRL-V and SHIFT-Insert are Paste
map <C-V>		"+gP
map <S-Insert>		"+gP
cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+
" backspace in Visual mode deletes selection
vnoremap <BS> d
" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <C-O>u
" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>
" End excerpt from mswin.vim

" Combination of mswin and vim selection behaviour
set keymodel=startsel
set selection=inclusive
set selectmode=
imap <S-Up> <C-o>V
imap <S-Down> <C-o>V

" <C-p> does neocomplcache completion
inoremap <C-p> <C-x><C-u>

" C-v in normal mode is for block-selection, not pasting clipboard
unmap <C-v>
" But in visual mode, C-v is for pasting clipboard.
" Use C-q for block selection in visual.
vmap <C-v> "+gP
smap <C-v> "+gP

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
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" Shift-Tab is previous window
inoremap <S-Tab> <C-O><C-W>W
cnoremap <S-Tab> <C-C><C-W>W
onoremap <S-Tab> <C-C><C-W>W

" reread config
if has("gui_running")
	ino <M-r> <C-o>:so ~/.vimrc<CR><C-o>:so ~/.gvimrc<CR>
	nno <M-r> :so ~/.vimrc<CR>:so ~/.gvimrc<CR>
else
	ino <M-r> <C-o>:so ~/.vimrc<CR>
	nno <M-r> :so ~/.vimrc<CR>
endif

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

" quickfix
ino <F11> <C-o>:cnext<CR>
nno <F11> :cnext<CR>
ino <S-F11> <C-o>:cprevious<CR>
nno <S-F11> :cprevious<CR>
ino <silent><C-F11> <C-o>:cclose<CR>
nno <silent><C-F11> :cclose<CR>

" not yet smart Tab indentation cycle
function! InsertTabWrapper()
	"let col = col('.') - 1
	"if !col || getline('.')[col - 1] !~ '\k'
	"	return "\<Tab>"
	"else
	"	return "\<C-p>"
	"endif
	return "\<C-t>"
endfunction
ino <silent><Tab> <C-r>=InsertTabWrapper()<CR>

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
let ropevim_vim_completion = 1
let ropevim_autoimport_underlineds = 1
" Don't let sql completion ruin your insert-mode experience.
" Annoying completions on Left/Right keys. Impossible to move cursor!
let g:ftplugin_sql_omni_key_left = 'stub'
let g:ftplugin_sql_omni_key_right = 'stub'


python << ENDCODE
import vim
def EvaluateCurrentRange():
	try:
		eval(compile('\n'.join(vim.current.range), '', 'exec'), globals())
	except:
		raise
	else:
		print("OK")
ENDCODE

function! <SID>PythonGrep(tool)
	set lazyredraw
	" Close any existing cwindows.
	cclose
	let l:grepformat_save = &grepformat
	let l:grepprogram_save = &grepprg
	set grepformat&vim
	set grepformat&vim
	let &grepformat = '%f:%l:%m'
	if a:tool == "pylint-errors"
		let &grepprg = 'python `which pylint` --errors-only'
	elseif a:tool == "pylint-warnings"
		let &grepprg = 'python `which pylint` --disable=E,C --disable=W0142'
	elseif a:tool == "pylint-other"
		let &grepprg = 'python `which pylint` --disable=E,W'
	elseif a:tool == "pychecker"
		let &grepprg = 'python `which pychecker` --quiet -q'
	else
		echohl WarningMsg
		echo "PythonGrep Error: Unknown Tool"
		echohl none
	endif
	if &readonly == 0 | update | endif
	silent! grep! %
	let &grepformat = l:grepformat_save
	let &grepprg = l:grepprogram_save
	" Open cwindow
	execute 'belowright copen'
	set nolazyredraw
	redraw!
endfunction

ino <M-1> <C-o>:call <SID>PythonGrep('pylint-errors')<CR>
nno <M-1> :call <SID>PythonGrep('pylint-errors')<CR>
ino <M-2> <C-o>:call <SID>PythonGrep('pylint-warnings')<CR>
nno <M-2> :call <SID>PythonGrep('pylint-warnings')<CR>
ino <M-3> <C-o>:call <SID>PythonGrep('pylint-other')<CR>
nno <M-3> :call <SID>PythonGrep('pylint-other')<CR>
ino <M-9> <C-o>:call <SID>PythonGrep('pychecker')<CR>
nno <M-9> :call <SID>PythonGrep('pychecker')<CR>

" Go uses tabs
augroup go
	au!
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter *.go setlocal noexpandtab
augroup END

" python has 4 spaces instead of tabs
augroup python
	au!
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter *.py setlocal expandtab
	au BufRead,BufEnter,BufWinEnter *.py setlocal makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
	au BufRead,BufEnter,BufWinEnter *.py setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
	au BufEnter,BufWinEnter *.py ino <buffer><silent> <C-n> <C-r>=RopeCodeAssistInsertMode()<CR>
	au BufEnter,BufWinEnter *.py ino <buffer><silent> <F8> <C-o>:!python %<CR>
	au BufEnter,BufWinEnter *.py ino <buffer><silent> <F9> <C-o>:py EvaluateCurrentRange()<CR>
	au BufEnter,BufWinEnter *.py vno <buffer><silent> <F9> :py EvaluateCurrentRange()<CR>
	au BufEnter,BufWinEnter *.py ino <buffer><silent> ( ()<Left>
	au BufEnter,BufWinEnter *.py ino <buffer><silent> [ []<Left>
	au BufEnter,BufWinEnter *.py ino <buffer><silent> { {}<Left>
	au BufWritePre *.py silent! %s/\v(\ +)$//
augroup END

" vimrc uses tabs
augroup vimrc
	au!
	au BufEnter,BufWinEnter *vimrc setlocal noexpandtab
augroup END

" markdown settings
augroup mkd
	au!
	au BufRead,BufNewFile *.mkd setlocal ai formatoptions=tcroqn2 comments=n:>
augroup END

" read-only windows trigger insert-mode off
augroup read_only
	au!
	au BufEnter,BufWinEnter * if &readonly || !&modifiable | set noinsertmode | else | set insertmode | endif
augroup END

" NERDTree is in normal mode, nodes are opened with <CR>
augroup NERDTree_Customized
	au!
	au BufEnter *NERD_tree* nmap <buffer> <CR> o
	au BufEnter,BufWinEnter *NERD_tree* set noinsertmode
augroup END

" Project plugin is in normal mode
augroup Project_Customized
	au!
	au BufEnter,BufWinEnter *.vimprojects setlocal noinsertmode
augroup END
