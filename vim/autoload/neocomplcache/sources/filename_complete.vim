"=============================================================================
" FILE: filename_complete.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 31 Jul 2010
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:source = {
      \ 'name' : 'filename_complete',
      \ 'kind' : 'complfunc',
      \}

function! s:source.initialize()"{{{
  " Initialize.
  let s:skip_dir = {}
  let s:completion_length = neocomplcache#get_auto_completion_length('filename_complete')
  
  " Set rank.
  call neocomplcache#set_dictionary_helper(g:neocomplcache_plugin_rank, 'filename_complete', 2)
endfunction"}}}
function! s:source.finalize()"{{{
endfunction"}}}

function! s:source.get_keyword_pos(cur_text)"{{{
  if &filetype ==# 'vimshell' || neocomplcache#within_comment()
    return -1
  endif

  let l:is_win = has('win32') || has('win64')

  " Not Filename pattern.
  if a:cur_text =~ 
        \'\*$\|\.\.\+$\|[/\\][/\\]\f*$\|[^[:print:]]\f*$\|/c\%[ygdrive/]$\|\\|$\|\a:[^/]*$'
    return -1
  endif

  " Filename pattern.
  let l:pattern = neocomplcache#get_keyword_pattern_end('filename')
  let [l:cur_keyword_pos, l:cur_keyword_str] = neocomplcache#match_word(a:cur_text, l:pattern)
  if neocomplcache#is_auto_complete() && len(l:cur_keyword_str) < s:completion_length
    return -1
  endif

  " Not Filename pattern.
  if l:is_win && &filetype == 'tex' && l:cur_keyword_str =~ '\\'
    return -1
  endif

  " Skip directory.
  if neocomplcache#is_auto_complete()
    let l:dir = simplify(fnamemodify(l:cur_keyword_str, ':p:h'))
    if l:dir != '' && has_key(s:skip_dir, l:dir)
      return -1
    endif
  endif

  return l:cur_keyword_pos
endfunction"}}}

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str)"{{{
  let l:cur_keyword_str = escape(a:cur_keyword_str, '[]')

  let l:is_win = has('win32') || has('win64')

  if a:cur_keyword_str =~ '^\$\h\w*'
    let l:env = matchstr(a:cur_keyword_str, '^\$\h\w*')
    let l:env_ev = eval(l:env)
    if l:is_win
      let l:env_ev = substitute(l:env_ev, '\\', '/', 'g')
    endif
    let l:len_env = len(l:env_ev)
  else
    let l:len_env = 0
    
    if a:cur_keyword_str =~ '^\~\h\w*'
      let l:cur_keyword_str = simplify($HOME . '/../' . l:cur_keyword_str[1:])
    endif
  endif
  
  let l:cur_keyword_str = substitute(l:cur_keyword_str, '\\ ', ' ', 'g')

  let l:path = (!neocomplcache#is_auto_complete() && a:cur_keyword_str !~ '^\.\.\?/')? &path : ','
  try
    let l:glob = (l:cur_keyword_str !~ '\*$')?  l:cur_keyword_str . '*' : l:cur_keyword_str
    let l:files = split(substitute(globpath(l:path, l:glob), '\\', '/', 'g'), '\n')
    if empty(l:files)
      " Add '*' to a delimiter.
      let l:cur_keyword_str = substitute(l:cur_keyword_str, '\w\+\ze[/._-]', '\0*', 'g')
      let l:glob = (l:cur_keyword_str !~ '\*$')?  l:cur_keyword_str . '*' : l:cur_keyword_str
      let l:files = split(substitute(globpath(l:path, l:glob), '\\', '/', 'g'), '\n')
    endif
  catch
    call neocomplcache#print_error(v:exception)
    return []
  endtry
  if empty(l:files) || (neocomplcache#is_auto_complete() && len(l:files) > g:neocomplcache_max_list)
    return []
  endif

  let l:list = []
  let l:home_pattern = '^'.substitute($HOME, '\\', '/', 'g').'/'
  let l:paths = map(split(&path, ','), 'substitute(v:val, "\\\\", "/", "g")')
  for word in l:files
    let l:dict = { 'word' : word, 'menu' : '[F]' , 'rank': 1 }

    let l:cur_keyword_str = $HOME . '/../' . l:cur_keyword_str[1:]
    if l:len_env != 0 && l:dict.word[: l:len_env-1] == l:env_ev
      let l:dict.word = l:env . l:dict.word[l:len_env :]
    elseif a:cur_keyword_str =~ '^\~/'
      let l:dict.word = substitute(word, l:home_pattern, '\~/', '')
    elseif !neocomplcache#is_auto_complete() && a:cur_keyword_str !~ '^\.\.\?/'
      " Path search.
      for path in l:paths
        if path != '' && neocomplcache#head_match(word, path . '/')
          let l:dict.word = l:dict.word[len(path)+1 : ]
          break
        endif
      endfor
    endif

    call add(l:list, l:dict)
  endfor

  call sort(l:list, 'neocomplcache#compare_rank')
  " Trunk many items.
  let l:list = l:list[: g:neocomplcache_max_list-1]

  let l:exts = escape(substitute($PATHEXT, ';', '\\|', 'g'), '.')
  for keyword in l:list
    let l:abbr = keyword.word
    
    if isdirectory(keyword.word)
      let l:abbr .= '/'
      let keyword.rank += 1
    elseif l:is_win
      if '.'.fnamemodify(keyword.word, ':e') =~ l:exts
        let l:abbr .= '*'
      endif
    elseif executable(keyword.word)
      let l:abbr .= '*'
    endif

    let keyword.abbr = l:abbr
  endfor

  for keyword in l:list
    " Escape word.
    let keyword.word = escape(keyword.word, ' *?[]"={}')
  endfor

  return l:list
endfunction"}}}

function! neocomplcache#sources#filename_complete#define()"{{{
  return s:source
endfunction"}}}

" vim: foldmethod=marker
