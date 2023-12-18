set nocompatible

let $CACHE = expand('~/.cache')
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    let s:dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !(s:dir->isdirectory())
      execute '!git clone https://github.com/Shougo/dein.vim' s:dir
    endif
  endif
  execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif

let s:dein_base = '~/.cache/dein/'
let s:dein_src = '~/.cache/dein/repos/github.com/Shougo/dein.vim'

if dein#load_state(s:dein_base)

  call dein#begin(s:dein_base)

" Dein plugin manager
  call dein#add(s:dein_src)

" Commands
  call dein#add('godlygeek/tabular', {'on_cmd': 'Tabularize'})
  call dein#add('vim-scripts/taglist.vim', {'on_cmd': [ 'TlistToggle', 'TlistOpen' ]})
  call dein#add('scrooloose/nerdtree', {'on_cmd': 'NERDTreeToggle'})
  call dein#add('chrisbra/NrrwRgn', {'on_cmd': 'NR'})
  call dein#add('vim-scripts/foldutil.vim', {'on_cmd': ['FoldMatching', 'FoldShowLines', 'FoldShowRange']})
  call dein#add('HiPhish/info.vim', {'on_cmd': 'Info'})

" Documentation
  call dein#add('milisims/nvim-luaref')

" Shells and REPLs
  call dein#add('metakirby5/codi.vim', {'on_cmd': 'Codi' }) 

" Git Support
  call dein#add('airblade/vim-gitgutter', {'on_path': '.*'})
  call dein#add('tpope/vim-fugitive', {'on_cmd': ['Git', 'Gcommit', 'Gblame','Gstatus', 'Gitdiff', 'Gbrowse'] }) 
  call dein#add('jreybert/vimagit', {'on_cmd': 'Magit'})
  call dein#add('gregsexton/gitv', {'on_cmd': ['Gitv', 'Gitv!'], 'depends': 'vim-fugitive' })

" Auto Completion
  call dein#add('Raimondi/delimitMate')

" User Interface
  call dein#add('simeji/winresizer')
  call dein#add('dhruvasagar/vim-zoom')
  call dein#add('terryma/vim-expand-region')
  call dein#add('matze/vim-move')

" Writing prose
"  call dein#add('junegunn/goyo.vim', {'on_cmd': 'Goyo'})
"  call dein#add('reedes/vim-pencil', {'on_cmd': ['Pencil', 'SoftPencil', 'HardPencil']})
"  call dein#add('junegunn/limelight.vim', {'on_cmd': ['Limelight', 'Limelight!!']})

" Text Objects
  call dein#add('kana/vim-textobj-user')
  call dein#add('kana/vim-textobj-function')

" Nvim only plugins
  if has('nvim')
	call dein#add('nvim-lua/plenary.nvim')
	call dein#add('nvim-telescope/telescope.nvim', { 'rev': '0.1.4' })
	call dein#add('nvim-telescope/telescope-fzf-native.nvim', { 'build': 'make' })
  endif

" Add Hoc Plugins
  call dein#add('tyru/capture.vim')
  call dein#add('tpope/vim-commentary')
  call dein#add('mhinz/vim-startify')
  call dein#add('junegunn/vim-peekaboo')
  call dein#add('lambdalisue/suda.vim')
  call dein#add('dyng/ctrlsf.vim', {'on_cmd': 'CtrlSF<Space>'})

  call dein#end()
  call dein#save_state()

endif

" Open new vertical window to the right
set splitright

" No status line if there's just one window
set laststatus=1

" Some filetype defaults
auto FileType lua setl shiftwidth=2
auto FileType lua setl keywordprg=:help
auto FileType lua setl iskeyword+=.

" Colorscheme
highlight CursorLine ctermbg=239 cterm=NONE
highlight VertSplit ctermfg=7
highlight StatusLineNC ctermfg=7
highlight TabLine cterm=NONE
highlight TabLineFill cterm=NONE

" Gitgutter plugin configuration
highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

" Configure tabline
lua require('tabline_configuration').setup({})

" Configure telescope fuzzy finder
lua require('telescope').load_extension('fzf')
lua require('telescope_configuration')

" Vim-move plugin configuration
let g:move_key_modifier = 'C'
let g:move_key_modifier_visualmode = 'C'

" A synonym for CtrlSF command
command! -nargs=* Find CtrlSF <args>

" NerdTree plugin configuration
nnoremap <silent> <A-f> :NERDTreeToggle<cr>
let NERDTreeMinimalUI=1

" Close NERDTree if it's the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" DelimitMate (autoclosing) plugin configuration
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1

" Immediately focus CtrlSF results pane
let g:ctrlsf_auto_focus = { "at": "start" }

" Enable folding for markdown filetype
let g:markdown_folding = 1

" Source current file when editing vim and lua scripts
auto FileType vim nnoremap <buffer> <C-C><C-C> :update \| source %<cr>
auto FileType vim vnoremap <buffer> <C-C><C-C> y:<c-u>@"<cr>
auto FileType lua nnoremap <buffer> <C-C><C-C> :update \| luafile %<cr>
auto FileType lua vnoremap <buffer> <C-C><C-C> y:<c-u>lua <c-r>"<cr>

" Allways start terminal in insert mode
autocmd BufEnter term://* startinsert
autocmd TermOpen * startinsert
tnoremap <Esc><Esc> <C-\><C-N>

" Insert date&time stamp
iabbrev <expr> ttime strftime("%m/%d/%Y %H:%M")

" Write file as root using suda.vim
cnoreabbrev w!! SudaWrite

" Diff unsaved changes in the buffer as edited by the user
" against the file on disk. From :help :DiffOrig
command! DiffOrig let my_diff_orig_filetype=&filetype |
                \ vert new | set buftype=nofile | read ++edit # | 0d_
                \ | call setbufvar("%","&filetype",my_diff_orig_filetype)
                \ | diffthis | wincmd p | diffthis

" Keep visual selection after indenting
vnoremap > >gv
vnoremap < <gv

" Uppercase preceding word
inoremap <A-u> <esc>mzgUiw`za

" Swap/eXchange two adjacent words
autocmd FileType text,markdown,org,dictionary nnoremap <buffer> <c-l> dawwPb
autocmd FileType text,markdown,org,dictionary nnoremap <buffer> <c-h> dawbPb

" Insert Mode Completion
inoremap <c-f> <c-x><c-f>
inoremap <c-]> <c-x><c-]>

" Clear search highlighting
nnoremap <silent> \\ :nohlsearch\|echon<CR>

" e %. opens Netrw/NERDTree in current file's directory (like Explore)
cabbr <expr> %. getcmdtype() == ':' && getcmdline() == "e %." ? expand("%:p:h") : "%."

" additional mappings for git rebase
auto FileType gitrebase nnoremap <buffer> <silent> ,e :Edit<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,p :Pick<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,s :Squash<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,r :Reword<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,f :Fixup<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,d :Drop<cr>

" Utility functions
function! MyError(msg)
	echohl ErrorMsg
	echomsg a:msg
	echohl NONE
	let v:errmsg = a:msg
endfunction

function! MyDebug(msg)
	if exists("g:mydebug") && g:mydebug > 0
		echo a:msg
	endif
endfunction

" Navigation between windows
" Taken from https://github.com/AnotherProksY/ez-window
function! MyNewScratchBuffer()
	enew
	setl noswapfile
	setl bufhidden=wipe
	setl buftype=
	setl nobuflisted
endfunction

function! MyNavigateWindows(key)
	let cur_win = winnr()
	exec "wincmd " . a:key
	if (cur_win == winnr())
		if (match(a:key,'[jk]'))
			wincmd v
		else
			wincmd s
		endif
		exec "wincmd " . a:key | call MyNewScratchBuffer()
	endif
endfunc

nnoremap <silent> <Space>h :call MyNavigateWindows('h')<cr>
nnoremap <silent> <Space>j :call MyNavigateWindows('j')<cr>
nnoremap <silent> <Space>k :call MyNavigateWindows('k')<cr>
nnoremap <silent> <Space>l :call MyNavigateWindows('l')<cr>
    nmap <silent> <Space>m <C-w>m
" Terminal mode
tnoremap <silent> <C-Space>h <C-\><C-N>:call MyNavigateWindows('h')<cr>
tnoremap <silent> <C-Space>j <C-\><C-N>:call MyNavigateWindows('j')<cr>
tnoremap <silent> <C-Space>k <C-\><C-N>:call MyNavigateWindows('k')<cr>
tnoremap <silent> <C-Space>l <C-\><C-N>:call MyNavigateWindows('l')<cr>

" Delete buffer without closing any windows
" Taken from https://github.com/moll/vim-bbye
function! s:mystr2bufnr(buffer)
	if empty(a:buffer)
		return bufnr("%")
	elseif a:buffer =~# '^\d\+$'
		return bufnr(str2nr(a:buffer))
	else
		return bufnr(a:buffer)
	endif
endfunction

function! s:bdelete(bang, buffer_name)

	let buffer = s:mystr2bufnr(a:buffer_name)
	let w:bbye_back = 1

	if buffer < 0
		return s:error("E516: No match for ".a:buffer_name)
	endif

	if getbufvar(buffer, "&modified") && empty(a:bang)
		let error = "E89: No write since last change for buffer "
		return MyError(error . buffer . " (add ! to override)")
	endif

	" If the buffer contains changes, we can't switch away from it.
	" Thus hide it before we eventually delete it.
	if getbufvar(buffer, "&modified") && !empty(a:bang)
		call setbufvar(buffer, "&bufhidden", "hide")
	endif

	" Since adding or hiding buffers might cause new windows to
	" appear or old windows to disappear thus decrementing total
	" number of windows, we loop backwards.
	for window in reverse(range(1, winnr("$")))
		" For invalid window numbers, winbufnr returns -1.
		if winbufnr(window) != buffer | continue | endif
		execute window . "wincmd w"

		" Bprevious also wraps around the buffer list, if necessary:
		try | exe bufnr("#") > 0 && buflisted(bufnr("#")) ? "buffer #" : "bprevious"
		catch /^Vim([^)]*):E85:/ " E85: There is no listed buffer
		endtry

		if bufnr("%") != buffer | continue | endif
		call MyNewScratchBuffer()
	endfor

	" Since tabbars and other appearing/disappearing windows change
	" window numbers, we find where we were manually:
	let back = filter(range(1, winnr("$")), "getwinvar(v:val, 'bbye_back')")[0]
	if back | exe back . "wincmd w" | unlet w:bbye_back | endif

	if buflisted(buffer) && buffer != bufnr("%")
		exe "bdelete" . a:bang . " " . buffer
	endif
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
	\ :call s:bdelete(<q-bang>, <q-args>)

cabbr zb Bdelete

" Leave insert mode with jk
" Taken from https://jdhao.github.io/2020/11/23/neovim_better_mapping_for_leaving_insert_mode/
inoremap <expr> k EscapeInsertOrNot()

function! EscapeInsertOrNot() abort
  " If k is preceded by j, then remove j and go to normal mode.
  let line_text = getline('.')
  let cur_ch_idx = CursorCharIdx()
  let pre_char = strcharpart(line_text, cur_ch_idx-1,1)
  echom 'pre_char is:' pre_char
  if pre_char ==# 'j'
    return "\b\e"
  else
    return 'k'
  endif
endfunction

function! CursorCharIdx() abort
  " A more concise way to get character index under cursor.
  let cursor_byte_idx = col('.')
  if cursor_byte_idx == 1
    return 0
  endif

  let pre_cursor_text = getline('.')[:col('.')-2]
  return strchars(pre_cursor_text)
endfunction

" Use Backspace to cycle through buffers *smartly*
" including not stalling on terminal buffers
"
function! MySmartBackspace_normal()
	bprev
	if &buftype ==# 'terminal'
		let b:SmartBackspaceInitialTime = reltime()
	endif
endfunction

function! MySmartBackspace_terminal()
	if has_key(b:,'SmartBackspaceInitialTime')
		let elapsed_time = reltimefloat(reltime(b:SmartBackspaceInitialTime))
		if elapsed_time < 2
			return ':call MySmartBackspace_normal()'
		endif
	endif
	return "\b"
endfunction

nnoremap <silent> <Backspace> :call MySmartBackspace_normal()<cr>
tnoremap <silent> <expr> <Backspace> MySmartBackspace_terminal()
nnoremap <silent> <M-Backspace> :tabp<cr>

" My terminal wrapper
function! MySwitchToWindowByBuffer(bufn)
	let this_win=winnr()
	while 1
		wincmd w
		if bufnr('%') == a:bufn
			return 1
		elseif this_win == winnr()
			return 0
		endif
	endwhile
endfunction

function! MyCreateTerminalWrapper()
	terminal
endfunction

function! MyTerminalPostAction(action)
	if has_key(b:,"MyLinkedSourceBuffer")
		if type(a:action) == type("string")
			exe a:action
		endif
	endif
endfunction

function! MyTerminalWrapper()
	let post_action=get(b:,'MyLinkedPostAction')
	if has_key(b:,"MyLinkedTerminalWrapper") && bufexists(b:MyLinkedTerminalWrapper)
		if !MySwitchToWindowByBuffer(b:MyLinkedTerminalWrapper)
			vertical split
			exe 'buffer ' . b:MyLinkedTerminalWrapper
		endif
		call MyTerminalPostAction(post_action)
	else
		let source_buffer=bufnr('%')
		vertical split
		call MyCreateTerminalWrapper()
		let target_buffer=bufnr('%')
		let b:MyLinkedSourceBuffer=source_buffer
		exe 'buffer ' . source_buffer
		let b:MyLinkedTerminalWrapper=target_buffer
		exe 'buffer' . target_buffer
	endif
endfunction

function! SetTerminalWrapperMode(mode)
	if a:mode == "repeat"
		let b:MyLinkedPostAction="call MyTerminalWrapperRepeat()"
	elseif a:mode == "off"
		let b:MyLinkedPostAction=0
	endif
endfunction

function! MyTerminalWrapperRepeat()
	call feedkeys("\<C-P>\<CR>\<C-\>\<C-N>\<C-W>w")
endfunction

function! MyTerminalWrapperSendBlock()
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end]     = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)

	call MyTerminalWrapper()
	if !exists('b:terminal_job_id')
		return ""
	endif

	call chansend(b:terminal_job_id, join(lines,"\n") . "\n")
	stopinsert
	wincmd p
endfunction

command! -nargs=1 TerminalWrapperMode call SetTerminalWrapperMode('<args>')
nnoremap <C-C><C-C> :call MyTerminalWrapper()<cr>
vnoremap <silent> <C-C><C-C> :<c-u>call MyTerminalWrapperSendBlock()<cr>

" Codi configuration
function! s:codi_guile_preprocess(line)
	return substitute(a:line, "^$[0-9]\\+ = ", "", "")
endfunction

function! s:codi_guile_rephrase(buffer)
	let buffer="\n".a:buffer
	while match(buffer,"\n[^\t ][^\n]*\n[\t ]\\+") != -1
		let buffer=substitute(buffer,"\n\\([^\t ][^\n]\\+\\)\n[\t ]\\+\\([^\n]*\\)","\n;;\n\\1 \\2","")
	endwhile
	let buffer=substitute(buffer,"\n\n","\n;;\n","g")
	return buffer[1:]
endfunction

let g:codi#interpreters = {
\      'python': {
\         'bin': 'python3',
\      },
\      'scheme': {
\         'bin': 'guile-expect',
\         'prompt': '^scheme@(guile-user)[^>]*> ',
\         'preprocess': function('s:codi_guile_preprocess'),
\         'rephrase': function('s:codi_guile_rephrase'),
\      },
\      'javascript.gjs': {
\         'bin': 'gjs-expect',
\         'prompt': '^gjs> \|\.\.\.\. ',
\      }
\}

" Scheme support

autocmd FileType scheme setl tags+=$HOME/.config/nvim/ctags/guile
autocmd FileType scheme setl keywordprg=:GuileHelp

let g:guile_info_index_file = $HOME . '/.config/nvim/data/guile-info.index'
command! -nargs=1 GuileHelp :call MyGuileHelp(<q-args>)
function! MyGuileHelp(word)
	let l:word = substitute(a:word, "\\\\\\\*", "*", "g")
	let l:xRefString = system(['fgrep', '-m1', '* '.l:word.':', g:guile_info_index_file])
	let l:xRefString = trim(l:xRefString)
	if l:xRefString == ""
		call MyError("Sorry, no entry for ".l:word)
	else
		let l:xRef = info#reference#decode(l:xRefString, {'File': 'guile.info'})
		let l:uri = info#uri#encode(l:xRef)
		if s:my_find_inf_window()
			execute 'silent edit' info#uri#exescape(l:uri)
		else
			execute 'silent split' info#uri#exescape(l:uri)
		endif
	endif
endfunction

function! s:my_find_inf_window() abort
     if s:is_inf_window_filetype(&filetype)
          return 1
      elseif winnr('$') ==# 1
          return 0
      endif                                                                              

      let l:thiswin = winnr()
      while 1 
          wincmd w
          if s:is_inf_window_filetype(&filetype)
              return 1
          elseif l:thiswin ==# winnr()
              return 0
          endif
       endwhile
endfunction

function! s:is_inf_window_filetype(filetype)
	return a:filetype ==# 'info' ||
	     \ a:filetype ==# 'help' ||
	     \ a:filetype ==# 'dictionary'
endfunction

" DFS traversal of Info pages
function! MyInfoDFSTraverse()
	if has_key(b:info,'Menu')
		call MyInfoGoto(b:info.Menu[0])
	elseif has_key(b:info,'Next')
		call MyInfoGoto(b:info.Next)
	else
		while has_key(b:info,'Up')
			call MyInfoGoto(b:info.Up)
			if has_key(b:info,'Next')
				call MyInfoGoto(b:info.Next)
				return(1)
			endif
		endwhile
	endif
endfunction

function! MyInfoGoto(reference)
	execute 'silent edit' info#uri#exescape(info#uri#encode(a:reference))
endfunction

autocmd FileType info nnoremap <Space><Space> :call MyInfoDFSTraverse()<cr>
autocmd FileType info nnoremap <A-Left>  :InfoPrev<cr>
autocmd FileType info nnoremap <A-Right> :InfoNext<cr>
autocmd FileType info nnoremap <A-Up>    :InfoUp<cr>

" Personal implementation of orgmode
" See https://github.com/albfan/ag.vim/commit/bdccf94877401035377aafdcf45cd44b46a50fb5
autocmd BufNewFile,BufRead *.org setfiletype org
autocmd Filetype org setl conceallevel=2
autocmd Filetype org setl concealcursor=nc
autocmd Filetype org setl nowrap

function! MyOrgModeForwardSkipConceal(count)
  let cnt=a:count
  let mvcnt=0
  let c=col('.')
  let l=line('.')
  let lc=col('$')
  let line=getline('.')
  while cnt
    if c>=lc
      let mvcnt+=cnt
      break
    endif
    if stridx(&concealcursor, 'n')==-1
      let isconcealed=0
    else
      let [isconcealed, cchar, group]=synconcealed(l, c)
      if !isconcealed && synconcealed(l,c+1)[0]
	      let c+=1
	      let cnt-=1
	      let mvcnt+=1
	      let [isconcealed, cchar, group]=synconcealed(l, c)
      endif
    endif
    if isconcealed
      let cnt-=strchars(cchar)
      let oldc=c
      let c+=1
      while c<lc && synconcealed(l, c)[0]
        let c+=1
      endwhile
      let mvcnt+=strchars(line[oldc-1:c-2])
    else
      let cnt-=1
      let mvcnt+=1
      let c+=len(matchstr(line[c-1:], '.'))
    endif
  endwhile
  "exec "normal ".mvcnt."l"
  return ":\<C-u>\e".mvcnt."l"
endfunction

function! MyOrgModeBackwardSkipConceal(count)
  let cnt=a:count
  let mvcnt=0
  let c=col('.')
  let l=line('.')
  let lc=1
  let line=getline('.')
  while cnt
    if c<=lc
      let mvcnt+=cnt
      break
    endif
    if stridx(&concealcursor, 'n')==-1
      let isconcealed=0
    else
      let [isconcealed, cchar, group]=synconcealed(l, c)
      if !isconcealed && synconcealed(l,c-1)[0]
	      let c-=1
	      let cnt-=1
	      let mvcnt+=1
	      let [isconcealed, cchar, group]=synconcealed(l, c)
      endif
    endif
    if isconcealed
      let cnt-=strchars(cchar)
      let oldc=c
      let c-=1
      while c>lc && synconcealed(l, c)[0]
        let c-=1
      endwhile
      let mvcnt+=strchars(line[c:oldc-1])
    else
      let cnt-=1
      let mvcnt+=1
      let c-=len(matchstr(line[c-1:], '.'))
    endif
  endwhile
  "exec "normal ".mvcnt."h"
  return ":\<C-u>\e".mvcnt."h"
endfunction

autocmd Filetype org nnoremap <expr> <silent> <buffer> l MyOrgModeForwardSkipConceal(v:count1)
autocmd Filetype org nnoremap <expr> <silent> <buffer> h MyOrgModeBackwardSkipConceal(v:count1)

function! MyOrgModeFollowLinkUnderCursor()
	let l:referencePattern='\v\[\[([^\]]+)\](\[([^\]]+)\])?\]'

	let l:line=getline('.')
	let l:col=col('.')
	let l:start=0

	while l:col>=l:start
		let l:start=match(l:line, l:referencePattern)+1
		let l:end=matchend(l:line, l:referencePattern)

		if l:start<0 || l:end<0
			break
		endif

		if l:col < l:end
			let l:link=matchlist(l:line, l:referencePattern)
			call MyOrgModeFollowLink(l:link[1])
			return
		endif

		let l:line=l:line[l:end:]
		let l:col-=l:end
		let l:start=0
	endwhile	
endfunction

function! MyOrgModeFollowLink(linkString)
	let l:openInNeovim='\.\(c\|cpp\|h\|hpp\|scm\|vim\|org\)$'
	echo a:linkString
	if match(a:linkString,"^https\?\:\/\/") != -1
		silent exe "!xdg-open \"" . a:linkString . "\" &"
	elseif match(a:linkString,"\\.mp4$") != -1
		call jobstart('mplayer -really-quiet "'.a:linkString.'"', {'detach':1})
	elseif match(a:linkString,l:openInNeovim) != -1
		exe "edit ".a:linkString
	else
		silent exe "!xdg-open \"" . a:linkString . "\" &"
	endif
endfunction

autocmd Filetype org nnoremap <silent> <buffer> <CR> :call MyOrgModeFollowLinkUnderCursor()<cr>
autocmd Filetype org nnoremap <silent> <buffer> <C-]> :call MyOrgModeFollowLinkUnderCursor()<cr>

autocmd FileType org imap <silent> <buffer> <expr> <CR> MyOrgModeEnterKeyHandler()

function! MyOrgModeEnterKeyHandler()
	let line=getline('.')
	if line =~ '^\s*\(\a\|\d\+\)[.)]\(\s\|$\)'
		return "\<Esc>^y/\\.\\|)/e+1\<CR>:nohl\<CR>o\<C-R>\"\<Esc>^\<C-A>A"
	elseif line =~ '^\(\s*[-+]\|\s\+\*\)\(\s\|$\)'
		return "\<Esc>^y2lo\<C-R>\""
	elseif line =~ '^\*\{2,\} '
		return "\<Esc>^yf o\<C-R>\""
	else
		return "\<CR>"
	endif
endfunction

" Navigate between diary entries
function! MyEditDiary(what)
	
	let directory=expand("%:p:h")
	let file_list=glob(directory.'/*',v:false,v:true)
	if !filereadable(expand("%"))
		let position=len(file_list)
	else
		let position=index(file_list, expand("%:p"))
	endif

	if a:what == "next"
		if position>-1
		  if position<len(file_list)-1
			exe "edit " . l:file_list[position+1]
		  else
			Note
		  endif
		endif
	elseif a:what == "prev"
		if position>0
			exe "edit " . l:file_list[position-1]
		endif
	endif
	echo expand("%:t")
endfunction

autocmd BufNewFile,BufRead */Zetelkastten/Daily\ Log/* nnoremap <silent> <buffer> <A-Left> :call MyEditDiary("prev")<cr>
autocmd BufNewFile,BufRead */Zetelkastten/Daily\ Log/* nnoremap <silent> <buffer> <A-Right> :call MyEditDiary("next")<cr>
command Note exe "edit " . $HOME . "/Zetelkastten/Daily Log/" . strftime("%m-%d-%Y") . ".org"

" Automatic tags management
command! -bang AutoTags :call MyAutoAddTagFile("<bang>")

function! MyAutoAddTagFile(bang)
	let base_dir = MyGetBaseProjectDirectory(expand("%:p:h"))
	let language = MyTagFiletypeToLanguage(&filetype)

	if base_dir == ""
		return ""
	endif

	let tag_file = MyGetAutoTagFile(base_dir,language,a:bang)
	if tag_file != ""
		" Nothing to do if already done...
		if exists("b:AutoTagInserted")
			return ""
		endif
		let b:AutoTagInserted = 1

		" Take care of already loaded buffers...
		let currBuff=bufnr("%")
		bufdo if (expand("%:p") =~ "^" . l:base_dir) && 
		      \  (MyTagFiletypeToLanguage(&filetype) == l:language) | 
		      \     exe "setl tags+=" . l:tag_file | 
		      \     let b:AutoTagInserted=1 | 
	              \ endif
		execute 'buffer ' . currBuff

		" And set it up for future buffers...
		exe "augroup " . matchstr(tag_file,'-\zs[a-z0-9]*') . "\n" .
		  \ "  autocmd!" . " | " .
		  \ "augroup END"
		exe "autocmd! " . matchstr(tag_file,'-\zs[a-z0-9]*') .
		  \ "  BufNewFile,BufRead " . l:base_dir . "/* " .
		  \ "  setl tags+=" . l:tag_file
		
		call MyDebug( "Phase 3: Setting tagfile..." . tag_file )
	endif
endfunction

function! MyGetBaseProjectDirectory(dir)
	if a:dir =~ '^/usr/local/share/TeXmacs/progs/'
		return '/usr/local/share/TeXmacs/progs'
	else
		let external_cmd='echo $(cd "' . a:dir . '"; git rev-parse --show-toplevel 2>/dev/null)'
		return system(external_cmd)->trim()
	endif
endfunction

function! MyGetAutoTagFile(base_dir, language, bang)
	let tag_file = fnamemodify(a:base_dir,":t") . '-'
	let tag_file .= substitute(system("sha1sum", a:base_dir . ':' . a:language)," .*$",".tags","")
	let tag_file = $HOME . "/.config/nvim/ctags/" . l:tag_file
	
	call MyDebug( "Phase 1: Determine tag file name: " . tag_file )
	if !filereadable(tag_file) || a:bang == "!"
		echo "Generated " . tag_file
		let tag_file = MyMakeTagFile(tag_file, a:base_dir, a:language)
	endif
	
	return tag_file
endfunction

function! MyMakeTagFile(tag_file, base_dir, language)
	let command = 'find "' . a:base_dir . '" -regex '
	let pattern = MyTagLanguageToPattern(a:language)
	let command .= "'" . l:pattern . "' | "
	let ctags = MyCtagsBinaryFor(a:language)
	let command .= l:ctags . "'" . a:tag_file . "'"
	call MyDebug( "Phase 2: Running " . l:command )
	silent exe "!" . l:command
	return a:tag_file
endfunction

function! MyCtagsBinaryFor(language)
	if a:language == "lua"
		return "utags-lua "
	else
		return "ctags -L - -f "
	endif
endfunction

function! MyTagLanguageToPattern(language)
	if a:language == 'scheme'
		let pattern='.*[.]scm'
	elseif a:language == 'c-or-cpp'
		let pattern='.*[.]\(c\|h\|cpp\)'
	elseif a:language == 'vim'
		let pattern='.*[.]vim'
	elseif a:language == 'lua'
		let pattern='.*[.]lua'
	else
		let pattern='.*'
	endif
	return pattern
endfunction

function! MyTagFiletypeToLanguage(filetype)
	if a:filetype == 'c' || a:filetype == 'cpp'
		return 'c-or-cpp'
	else
		return a:filetype
	endif
endfunction

" Automatically invoke AutoTags if tag is not found
function! MyTagCommand()
	try
		silent exe 'tag' expand('<cword>')
	catch
		AutoTags
		try
		   exe 'tag' expand('<cword>')
	        catch
		   call MyError('E426: tag not found: '.expand('<cword>'))
	        endtry
	endtry
endfunction
nnoremap <silent> <C-]> :call MyTagCommand()<cr>

" Set custom behaviour for this and all subsequently
" loaded buffers of the same filetype.
command! -nargs=* Set :call MySetFiletypeOption(<f-args>)
function! MySetFiletypeOption(...)
	if a:0>0
		let command = MyGetFiletypeSpecificCommand(&filetype,a:1)
		if command != {}
		  exe l:command.immediate
		  call MySetFiletypeSpecificAutocommand(&filetype,l:command.auto)
		endif
	endif
endfunction

function! MySetFiletypeSpecificAutocommand(filetype,command)
	let group='MFSC-'.a:filetype
	exe "augroup " . l:group . "\n" .
	  \ "  autocmd!" . " | " .
	  \ "augroup END"
	exe "autocmd! " . l:group .
	  \ "  FileType " . a:filetype . " " . a:command
endfunction

function! MyGetFiletypeSpecificCommand(filetype,option)
	if a:option == "fold"
		return My_option_fold(&filetype)
	elseif a:option == "fold!"
		return My_option_fold_bang(&filetype)
	else
		return {}
	endif
endfunction

function! My_option_fold(filetype)
	if a:filetype == "lua" || a:filetype == "vim"
		return { 'immediate': "setl foldmethod=indent",
		     \   'auto': "setl foldmethod=indent", }
	elseif a:filetype == "c" || a:filetype == "cpp"
		return { 'immediate': "setl foldmethod=syntax",
		     \   'auto': "setl foldmethod=syntax", }
	endif
endfunction

function! My_option_fold_bang(filetype)
	return { 'immediate': "setl foldmethod=manual|norm zE",
	     \   'auto': "exe", }
	endif
endfunction

" Execute Ex command in the current file's or project's directory
command! -nargs=1 FromCfd call MyRunInCurrentFileDirectory(<f-args>)
command! -nargs=1 FromProj call MyRunInCurrentProject(<f-args>)

function! MyRunInCurrentFileDirectory(cmd)
	call MyRunInDirectory(a:cmd, expand("%:p:h"))
endfunction

function! MyRunInCurrentProject(cmd)
	let proj_base = MyGetBaseProjectDirectory(expand("%:p:h"))
	if proj_base != ""
		call MyRunInDirectory(a:cmd, proj_base)
	endif
endfunction

function! MyRunInDirectory(cmd, dir)
	let rdir = getcwd()
	if haslocaldir(0)
		let rcmd = "lcd"
	elseif haslocaldir(-1)
		let rcmd = "tcd"
	else
		let rcmd = "cd"
	endif

	execute rcmd a:dir
	execute a:cmd
	execute rcmd rdir
endfunction

" Delete file on disk without E211: File no longer available
command! -bar -bang Unlink
       \ if <bang>0 || confirm("Delete file ".expand("%:p")."? ","&Yes\n&No",2) == 1 |
       \    if delete(expand("%:p")) |
       \       echoerr empty(getftype(expand("%:p"))) ? "No file \"".@%."\" on disk" : "Failed to delete \"".@%."\"" |
       \    else |
       \       edit! |
       \    endif |
       \ endif
command! -bar -bang Remove Unlink<bang>

" Open current file's directory in Netrw like vinegar
nmap <silent> <expr> - MyRevealCurrentFileInNetrw()
function! MyRevealCurrentFileInNetrw()
	if &filetype != "netrw"
		return ":Explore\<CR>/" . expand("%:t") . "\<CR>:nohl\<CR>"
	else
		return "-"
	endif
endfunction

" For text, markdown and orgmode filetypes, K looks up word in a dictionary
autocmd FileType text,markdown,org,dictionary setlocal keywordprg=:WordDictionary
autocmd BufReadCmd Dictionary:* call MyDictionaryWordLoad(expand('<afile>'))
command! -nargs=1 WordDictionary :call MyWordDictionary(<q-args>)
function! MyWordDictionary(word)

	let l:alias = g:dict_alias
	let l:dictionary = g:dict_prg
	if exists("b:dict_prg")
		let l:dictionary = b:dict_prg
		let l:alias = b:dict_alias
	endif

	if !s:my_find_inf_window()
		split
	endif

	exe "edit" "Dictionary:".a:word." (".l:alias.")"
endfunction

function! MyDictionaryWordLoad(dict_url)
	let l:url_components=matchlist(a:dict_url,'\vDictionary:(.*) \(([A-Za-z0-9]*)\)')
	let l:word=url_components[1]
	let l:dictionary=url_components[2]

	let b:dict_word = l:word
	let b:dict_alias = l:dictionary
	let b:dict_prg = MyDictionary2executable(l:dictionary)
	setlocal buftype=nofile
	setlocal nobuflisted
	setlocal filetype=dictionary
	setlocal nowrap
	redraw
	silent keepjumps exe "read" "!".b:dict_prg." ".l:word." 2>/dev/null"
	silent keepjumps norm gg
endfunction

" Default dictionary
let g:dict_prg = "dict"
let g:dict_alias = "dict"

" Front facing dictionary user interface
autocmd FileType dictionary nnoremap <buffer> , :Dict @
command! -nargs=* -complete=customlist,MyDictionaryAutocomplete
       \ Dict :call MyDictionaryFrontEnd(<f-args>)
function! MyDictionaryFrontEnd(...)
	let word = ""
	let dict = ""
	let alias = ""
	for i in range(1,a:0)
		if a:{i} =~ "^@"
			let dict = MyDictionary2executable(a:{i}[1:])
			let alias = a:{i}[1:]
		else
			let word = a:{i}
		endif
	endfor

	if l:dict != ""
		if exists("b:dict_prg")
			let b:dict_prg = l:dict
			let b:dict_alias = l:alias
		else
			let g:dict_prg = l:dict
			let g:dict_alias = l:alias
		endif
	endif

	if word != "" || exists("b:dict_word")
		call MyWordDictionary(word==""?b:dict_word:word)
	endif
endfunction

function! MyDictionary2executable(alias)
	if a:alias=="google"
		return "dict-google"
	elseif a:alias=="cambridge"
		return "dict-cambridge"
	elseif a:alias=="webster"
		return "dict-webster"
	elseif a:alias=="dict"
		return "dict"
	elseif a:alias=="translate"
		return "trans --no-ansi"
	else
		return "dict-unknown"
	endif
endfunction

let g:dictionary_aliases=['webster', 'cambridge', 'google', 'translate', 'dict']
function MyDictionaryAutocomplete(arglead, cmdline, cursorpos)
	let candidates=[]
	for alias in g:dictionary_aliases
		if "@".alias[0:len(a:arglead)-2] ==# a:arglead
			let candidates+=["@".l:alias]
		endif
	endfor
	return candidates
endfunction

" Menu Infrastructure
function! MyStartMenu(name)

  if !&hidden && &modified
    call MyError('Save your changes first.')
    return v:false
  endif

  if line2byte('$') != -1
    noautocmd enew
  endif

  silent! setlocal
        \ bufhidden=wipe
        \ colorcolumn=
        \ foldcolumn=0
        \ matchpairs=
        \ modifiable
        \ nobuflisted
        \ nocursorcolumn
        \ nocursorline
        \ nolist
        \ nonumber
        \ noreadonly
        \ norelativenumber
        \ nospell
        \ noswapfile
        \ signcolumn=no
        \ synmaxcol&

  if empty(&statusline)
    exe "setlocal statusline=".substitute(a:name,' ','\\ ','g')
  endif

  let b:MyMenu = { 'fixed_col': 5, 'leftmouse': 0, 'entries': {} }
  return v:true
endfunction

function! MyMenuFinish()
  setlocal nomodifiable nomodified
  nnoremap <buffer><nowait><silent> <cr> :call MyMenuOpen()<cr>
  nnoremap <buffer><nowait><silent> <LeftMouse>   :call MyMenu_leftmouse()<cr>

  " Without these mappings n/N wouldn't work properly, since autocmds always
  " force the cursor back on the index.
  nnoremap <buffer><expr> n ' j'[v:searchforward].'n'
  nnoremap <buffer><expr> N 'j '[v:searchforward].'N'

  function! s:compare_by_index(foo, bar)
    return a:foo.index - a:bar.index
  endfunction

  for entry in sort(values(b:MyMenu.entries), 's:compare_by_index')
    execute 'nnoremap <buffer><silent><nowait>' entry.index
          \ ':call MyMenuOpen('. string(entry.line) .')<cr>'
  endfor

  let b:MyMenu.firstline=min(keys(b:MyMenu.entries))
  let b:MyMenu.lastline =max(keys(b:MyMenu.entries))
  
  call cursor(b:MyMenu.firstline, b:MyMenu.fixed_col)
  autocmd startify CursorMoved <buffer> call MyMenu_set_cursor()

  set filetype=menu
endfunction

function! MyMenuRegister(line, index, command)
	let b:MyMenu.entries[a:line] = {
            \ 'index': a:index,
	    \ 'line':  a:line,
	    \ 'command': a:command, }
endfunction

function! MyMenu_set_cursor() abort
  let b:MyMenu.oldline = exists('b:MyMenu.newline') ? b:MyMenu.newline : b:MyMenu.fixed_col
  let b:MyMenu.newline = line('.')

  " going up (-1) or down (1)
  if b:MyMenu.oldline == b:MyMenu.newline
        \ && col('.') != b:MyMenu.fixed_col
        \ && !b:MyMenu.leftmouse
    let movement = 2 * (col('.') > b:MyMenu.fixed_col) - 1
    let b:MyMenu.newline += movement
  else
    let movement = 2 * (b:MyMenu.newline > b:MyMenu.oldline) - 1
    let b:MyMenu.leftmouse = 0
  endif

  " skip lines that are not part of the menu
  while !has_key(b:MyMenu.entries,b:MyMenu.newline) &&
      \ b:MyMenu.newline>b:MyMenu.firstline &&
      \ b:MyMenu.newline<b:MyMenu.lastline
	  let b:MyMenu.newline += movement
  endwhile

  let b:MyMenu.newline = max([b:MyMenu.firstline, 
                         \    min([b:MyMenu.lastline, b:MyMenu.newline])])

  call cursor(b:MyMenu.newline, b:MyMenu.fixed_col)
endfunction

function! MyMenu_leftmouse()
  " feedkeys() triggers CursorMoved which calls s:set_cursor() which checks .leftmouse
  let b:MyMenu.leftmouse = 1
  call feedkeys("\<LeftMouse>", 'nt')
endfunction

function! MyMenuButton(index)
	return '   ' . '[' . a:index . ']' . repeat(' ',3-strlen(a:index))
endfunction

function! MyMenuOpen(...)
	if exists('a:1')
		let command = b:MyMenu.entries[a:1].command
	else
		let command = b:MyMenu.entries[line('.')].command
	endif
	exe command
endfunction

" Buffer selector menu
nnoremap <silent> \<Backspace> :call MyBufferSelectionMenu()<cr>
function! MyBufferSelectionMenu()
	if MyStartMenu("Select Buffer")
		call append('$',['   Buffers:',''])
		
		let index=0
		for buffer in getbufinfo({'buflisted': 1})
			let entry = MyMenuButton(index) . bufname(buffer.bufnr)
			call append('$', entry)
			call MyMenuRegister(line('$'), index, 'bu '.buffer.bufnr)
			let index+=1
		endfor
		call append('$','')
		nnoremap <silent> <buffer> q :Bdelete<cr>
		call MyMenuFinish()
	endif
endfunction
