syntax on
filetype on
filetype plugin on
filetype indent on

set mouse=a

if has("gui_running")
	colors rdark_temoto
else
	colors evening
endif

set nocompatible
set viminfo+=h
set ttyfast

set tabstop=4 shiftwidth=4 softtabstop=4 autoindent smartindent
set backspace=indent,eol,start
set history=2000
set undolevels=200

" i hate freaking space indentation, but most people use it :(
set expandtab

set ffs=unix,mac,dos
set listchars=tab:>-,trail:-
set nowrap showbreak=+ ignorecase

set number showmode showmatch incsearch hlsearch lazyredraw wildmenu ruler
set laststatus=2
set statusline=%F%m%r%h%w\ [%{&ff},\ %Y]\ [0x\%02.2B]\ [%04l,%04v][%p%%/%L]
set cmdheight=2

set tags+=~/.vim/tags/python.ctags
set tags+=~/.vim/tags/*.ctags

" good-mode
set insertmode

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
ino <F2> <C-o>:w<CR>
ino <C-s> <C-o>:w<CR>
ino <C-\> <C-o>:q!<CR>
nno <C-\> :q!<CR>
vno <C-\> :q!<CR>
ino <silent><M-q> <C-o>:bd!<CR>
nno <silent><M-q> :bd!<CR>

" tab management
ino <silent><C-Tab> <C-o>:tabnext<CR>
ino <silent><C-S-Tab> <C-o>:tabprevious<CR>
ino <silent><C-w> <C-o>:silent! tabclose<CR>
nno <silent><C-w> :silent! tabclose<CR>

" NERDtree
ino <silent><F3> <C-o>:NERDTreeToggle<CR>
nno <silent><F3> :NERDTreeToggle<CR>
vno <silent><F3> :<C-w>NERDTreeToggle<CR>
let g:NERDTreeSplitVertical = 0
let g:NERDTreeIgnore = ['\.pyc', '\.hi', '\.o']

" tag list
ino <silent><F4> <C-o>:TlistToggle<CR>

" comment/uncomment and move lower
ino <M-;> <Home># <Down>
ino ; <Home># <Down>
ino <M-'> <Home><Del><Del><Down>
ino ' <Home><Del><Del><Down>

" undo/redo
nno <C-z> :undo<CR>i
ino <C-z> <C-o>:undo<CR>
ino <C-y> <C-o>:redo<CR>

" clipboard
ino <C-l> <C-o>dd
vno <C-l> d
ino <C-k> <C-o>yy
vno <C-k> y
ino <C-p> <C-o>P
vno <C-p> P
ino <M-p> <C-o>p
vno <M-p> p

" S-Tab goes to next split
ino <silent><S-Tab> <C-o>:wincmd w<CR>
nno <silent><S-Tab> :wincmd w<CR>

" erase word
ino <C-BS> <C-w>
cno <C-BS> <C-w>
ino <M-BS> <C-o>daw
ino <C-Del> <C-Right><C-w>
ino <C-kDel> <C-Right><C-w>
ino <M-Del> <Right><C-o>daw
ino <M-kDel> <Right><C-o>daw

" erase line
ino <C-Del> <C-o>"_dd
ino <C-kDel> <C-o>"_dd

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

" selection
ino <S-Down> <C-o>V
vno <S-Down> <Down>
ino <S-Up> <C-o>V<Up>
vno <S-Up> <Up>
ino <S-Right> <C-o>v
vno <S-Right> <Right>
ino <S-Left> <Left><C-o>v
vno <S-Left> <Left>
ino <S-End> <C-o>v<End>
ino <S-Home> <C-o>v<Home>

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

" filetype specific options
" =========================

let python_highlight_all = 1
let ropevim_vim_completion = 1
let ropevim_autoimport_underlineds = 1

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
		let &grepprg = 'pylint --errors-only'
	elseif a:tool == "pylint-warnings"
		let &grepprg = 'pylint --disable-msg-cat=E,C'
	elseif a:tool == "pylint-other"
		let &grepprg = 'pylint --disable-msg-cat=E,W'
	elseif a:tool == "pychecker"
		let &grepprg = 'pychecker --quiet -q'
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

" python has 4 spaces instead of tabs
augroup python
	au!
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

" some particular projects use tabs
augroup python_tabs
	au!
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/obuh/* setlocal noexpandtab
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/vm-001/* setlocal noexpandtab
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/qt-001/* setlocal noexpandtab
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/qt-002/* setlocal noexpandtab
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/edicore-001/* setlocal noexpandtab
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/wedi/* setlocal noexpandtab
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/heroshi/* setlocal noexpandtab
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/corners-bot/* setlocal noexpandtab
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/insomnia-server/* setlocal noexpandtab
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter project/insomnia-client/* setlocal noexpandtab
augroup END

augroup html
	au!
	au BufReadPre,FileReadPre,BufEnter,BufWinEnter *.html setlocal tabstop=2 shiftwidth=2 softtabstop=2
augroup END

" markdown settings
augroup mkd
	autocmd BufRead *.mkd  setlocal ai formatoptions=tcroqn2 comments=n:>
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
