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
      let s:_firstTimeInstall = v:true
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
  call dein#add('yegappan/taglist', {'on_cmd': [ 'TlistToggle', 'TlistOpen' ]})
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
  call dein#add('rbong/vim-flog', {'on_cmd': ['Flog', 'Flogsplit', 'Floggit'], 'depends': 'vim-fugitive' })

" Auto Completion
  call dein#add('Raimondi/delimitMate')

" User Interface
  call dein#add('simeji/winresizer')
  call dein#add('dhruvasagar/vim-zoom')
  call dein#add('terryma/vim-expand-region')
  call dein#add('matze/vim-move')

" Color schemes
  call dein#add('catppuccin/nvim')

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

if exists("s:_firstTimeInstall")
	call dein#install()
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
highlight NormalFloat ctermbg=234

" Gitgutter plugin configuration
highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
autocmd User GitGutter ++once let g:gitgutter_floating_window_options['border'] = 'single'

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

" Resize splits if terminal window got resized
autocmd VimResized * tabdo wincmd =

" DelimitMate (autoclosing) plugin configuration
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1

" Immediately focus CtrlSF results pane
let g:ctrlsf_auto_focus = { "at": "start" }
let g:ctrlsf_mapping = {
    \ "open": "o",
    \ "openb": [ "<CR>", "O" ],
    \ }

" Toggle CtrlSF results pane
nnoremap \f :CtrlSFToggle<cr>

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
cabbr <expr> %. getcmdtype() == ':' && getcmdline() =~ '^\(e\\|cd\) %.$' ? expand("%:p:h") : "%."

" I keep forgetting that, for Vim, bash is filetype sh
cabbr <expr> bash getcmdtype() == ":" && getcmdline() == "set filetype=bash"?"sh":"bash"

" additional mappings for git rebase
auto FileType gitrebase nnoremap <buffer> <silent> ,e :Edit<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,p :Pick<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,s :Squash<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,r :Reword<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,f :Fixup<cr>
auto FileType gitrebase nnoremap <buffer> <silent> ,d :Drop<cr>

" Keep normal commands on the same keys in sr1 layout
nmap Č :
nmap žž \\
nmap đc ]c
nmap šc [c
nmap žhu \hu
nmap žhs \hs
nmap ž, \,
nmap ž<Backspace> \<Backspace>
nmap Ć "

" Shebang abbreviations
autocmd Filetype sh iabbr <buffer> <expr> #! MyInsertShebang("#!/bin/bash")
autocmd Filetype python iabbr <buffer> <expr> #! MyInsertShebang("#!/usr/bin/python3")
autocmd Filetype lua iabbr <buffer> <expr> #! MyInsertShebang("#!/usr/bin/env lua")
autocmd BufWritePost * call IfShebangSetExecutableBit()

" Asymptote filetype detection
autocmd BufNewFile,BufRead *.asy setfiletype asy
autocmd Filetype asy nnoremap <buffer> <silent> <C-C><C-C> :update \| silent! !asy % ; evince %:r.eps &<cr>

" Txr filetype detection
autocmd BufNewFile,BufRead *.txr set filetype=txr | set lisp
autocmd BufNewFile,BufRead *.tl,*.tlo set filetype=tl | set lisp

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

function! MyClearMessageLine(n)
	echon
endfunction

function MyInsertShebang(shebang)
	if col(".")==3 && line(".")==1
		let b:ShebangSet=1
		return a:shebang
	else
		return "#!"
	endif
endfunction

function! MySetExecutableBit()
	if filereadable(expand("%"))
		checktime
		exe "au FileChangedShell " . expand("%:p") . " :echo "
		silent !chmod a+x %
		checktime
		exe "au! FileChangedShell " . expand("%:p")
	endif
endfunction

function! IfShebangSetExecutableBit()
	if has_key(b:,'ShebangSet') &&
	 \ getline(1)[0:1]=="#!"
		call MySetExecutableBit()
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

" Change vertical splits to horizontal
nnoremap <C-W>e :call ChangeVerticalToHorizontalSplit()<CR>
function! ChangeVerticalToHorizontalSplit()
	let l:buffer = bufnr("%")
	wincmd c
	split
	wincmd j
	exe 'buffer ' . l:buffer
endfunction

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
	call MySmartPreviousBuffer()
	if &buftype ==# 'terminal'
		let b:SmartBackspaceInitialTime = reltime()
	endif
	echo expand("%")
	call timer_start(3000, 'MyClearMessageLine')
endfunction

function! MySmartBackspace_terminal()
	if has_key(b:,'SmartBackspaceInitialTime')
		let elapsed_time = reltimefloat(reltime(b:SmartBackspaceInitialTime))
		if elapsed_time < 2
			return ':call MySmartBackspace_normal()'
		endif
	endif
	return ""
endfunction

let g:SmartBackspaceData={'bufferlist': [], 'atime': reltime(), 'pos': 0}
function! MySmartPreviousBuffer()
	if exists("g:SmartBackspaceMode") && g:SmartBackspaceMode=="bufnr"
		bprev
		return
	endif

	let elapsed_time = reltimefloat(reltime(g:SmartBackspaceData.atime))
	let g:SmartBackspaceData.atime = reltime()
	if elapsed_time>2 || g:SmartBackspaceData.bufferlist == []
		let g:SmartBackspaceData.bufferlist = sort(getbufinfo({'buflisted': 1}),
					            \ {b1,b2->b2.lastused-b1.lastused})
		let g:SmartBackspaceData.pos = len(g:SmartBackspaceData.bufferlist)>1?1:0
	endif
	exe "buf" g:SmartBackspaceData.bufferlist[g:SmartBackspaceData.pos].bufnr
	let g:SmartBackspaceData.pos += 1
	if g:SmartBackspaceData.pos == len(g:SmartBackspaceData.bufferlist)
		let g:SmartBackspaceData.pos = 0
	endif
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

function! MyCreateTerminalWrapper(directory,cmd)
	exe "lcd" fnameescape(a:directory)
	exe "terminal" a:cmd
endfunction

function! MyTerminalPostAction(action)
	if has_key(b:,"MyLinkedSourceBuffer")
		if type(a:action) == type("string")
			exe a:action
		endif
	endif
endfunction

function! MyTerminalSwitchTo(buffer)
	let post_action=get(b:,'MyLinkedPostAction')
	if !MySwitchToWindowByBuffer(a:buffer)
		vertical split
		exe 'buffer ' . a:buffer
	endif
	call MyTerminalPostAction(post_action)
endfunction

let g:MyProjectsTerminalCache = {}

function! MyTerminalWrapper(base_dir,cmd)
	if has_key(b:,"MyLinkedTerminalWrapper") && bufexists(b:MyLinkedTerminalWrapper)
		call MyTerminalSwitchTo(b:MyLinkedTerminalWrapper)
	else
		let curr_dir = expand("%:p:h")
		let base_dir = MyGetBaseProjectDirectory(curr_dir)
		if base_dir == "" || !a:base_dir ||
		 \ !has_key(g:MyProjectsTerminalCache,base_dir) ||
		 \ !bufexists(g:MyProjectsTerminalCache[base_dir])
			let source_buffer=bufnr('%')
			vertical split
			call MyCreateTerminalWrapper(curr_dir,a:cmd)
			let target_buffer=bufnr('%')
			let b:MyLinkedSourceBuffer=source_buffer
			exe 'buffer ' . source_buffer
			let b:MyLinkedTerminalWrapper=target_buffer
			exe 'buffer' . target_buffer
			if base_dir != ""
				let g:MyProjectsTerminalCache[l:base_dir]=l:target_buffer
			endif
		else
			call MyTerminalSwitchTo(g:MyProjectsTerminalCache[base_dir])
		endif
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

	call MyTerminalWrapper(v:true,"")
	if !exists('b:terminal_job_id')
		return ""
	endif

	call chansend(b:terminal_job_id, join(lines,"\n") . "\n")
	stopinsert
	wincmd p
endfunction

command! -nargs=1 TerminalWrapperMode call SetTerminalWrapperMode('<args>')
nnoremap <C-C><C-C> :call MyTerminalWrapper(v:true,"")<cr>
nnoremap <Esc><C-C><C-C> :call MyTerminalWrapper(v:true,"")<cr>
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

" Txr support

autocmd FileType txr,tl setl keywordprg=:TxrHelp

let g:txr_index_file = $HOME . '/.config/nvim/data/txr-man.index'
command! -nargs=1 TxrHelp :call MyTxrHelp(<q-args>)
function! MyTxrHelp(word)
	let l:xRefString = system(['fgrep', '-m1', a:word, g:txr_index_file])
	if empty(l:xRefString)
		call MyError("Sorry, no entry for ".a:word)
	else
		execute "Man txr"
		let @/ = split(l:xRefString)[0]
		set hlsearch
		call search(@/, 'w')
		redraw
	endif
endfunction

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
		if s:my_find_window(function('s:is_info_window'))
			execute 'silent edit' info#uri#exescape(l:uri)
		else
			execute 'silent split' info#uri#exescape(l:uri)
		endif
	endif
endfunction

function! s:my_find_window(predicate) abort
     if a:predicate()
          return 1
      elseif winnr('$') ==# 1
          return 0
      endif                                                                              

      let l:thiswin = winnr()
      while 1 
          wincmd w
          if a:predicate()
              return 1
          elseif l:thiswin ==# winnr()
              return 0
          endif
       endwhile
endfunction

function! s:is_info_window()
	return &filetype ==# 'info' ||
	     \ &filetype ==# 'help' ||
	     \ &filetype ==# 'dictionary'
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

autocmd FileType info nnoremap <buffer> <Space><Space> :call MyInfoDFSTraverse()<cr>
autocmd FileType info nnoremap <buffer> <A-Left>  :InfoPrev<cr>
autocmd FileType info nnoremap <buffer> <A-Right> :InfoNext<cr>
autocmd FileType info nnoremap <buffer> <A-Up>    :InfoUp<cr>

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

function! MyOrgModeFollowLinkUnderCursor(alt)
	let target = MyOrgModeGetLinkUnderCursor(1)
	if target != ""
		call MyOrgModeFollowLink(l:target,a:alt)
	endif
endfunction

function! MyOrgModeGetLinkUnderCursor(what)
	let l:referencePattern='\v\[\[([^\]]+)\](\[([^\]]+)\])?\]'

	let l:line=getline('.')
	let l:col=col('.')
	let l:start=0

	let l:previewWorkaround = has_key(b:,'PreviewMode') && b:PreviewMode==1 &&
	                        \ has_key(b:,'PreviewModeStowedLine') &&
	                        \ b:PreviewModeStowedLine.linenr == line(".")
	if previewWorkaround
		let l:lineStowed = b:PreviewModeStowedLine.line
	endif

	while l:col>=l:start
		let l:start=match(l:line, l:referencePattern)+1
		let l:end=matchend(l:line, l:referencePattern)

		if l:start<0 || l:end<0
			break
		endif

		if l:col <= l:end && l:col >= l:start
			if previewWorkaround
				let l:link = matchlist(l:lineStowed, l:referencePattern)
			else
				let l:link=matchlist(l:line, l:referencePattern)
			endif
			return l:link[a:what]
		endif

		let l:line=l:line[l:end:]
		let l:col-=l:end
		let l:start=0
		if previewWorkaround
			let l:lineStowed = l:lineStowed[matchend(l:lineStowed, l:referencePattern):]
		endif
	endwhile
	return ""
endfunction

function! MyOrgModeFollowLink(linkString, alt)
	if a:alt
		call MyAlternativeFile("",MyGetCannonicalZetelkasttenFile(a:linkString))
		return
	endif
	let l:openInNeovim='\.\(c\|cpp\|h\|hpp\|scm\|vim\|org\)$'
	echo a:linkString
	if match(a:linkString,"^https\?\:\/\/") != -1
		silent exe "!xdg-open \"" . a:linkString . "\" &"
	elseif match(a:linkString,"^alt:\/") != -1
		call MyOrgModeEditLinkedFile(a:linkString)
	elseif match(a:linkString,"^youtube:\/") != -1
		call jobstart("get-youtube-video ".substitute(a:linkString,"^youtube:\/\/","",""))
	elseif match(a:linkString,"\\.mp4\\|\\.avi\\|\\.mpeg$\\|\\.webm\\|\\.mkv") != -1
		call jobstart('mplayer -really-quiet "'.a:linkString.'"', {'detach':1})
	elseif match(a:linkString,l:openInNeovim) != -1
		call MyOrgModeEditLinkedFile(a:linkString)
	elseif match(a:linkString,"^Redirect:") != -1
		Bdelete
		call MyOrgModeEditLinkedFile(MyGetCannonicalZetelkasttenFile(a:linkString[9:]))
	elseif stridx(a:linkString,"/") == -1
		call MyOrgModeEditLinkedFile(MyGetCannonicalZetelkasttenFile(a:linkString))
	else
		call jobstart("xdg-open \"" . a:linkString . "\"", {'detach':1})
	endif
endfunction

function! MyOrgModeEditLinkedFile(file)
	let shouldInheritPreview = &filetype == "org" &&
				 \ has_key(b:,'PreviewMode') && b:PreviewMode == 1
	exe "edit" a:file

	if &filetype == "org" && l:shouldInheritPreview
		silent call TogglePreviewMode()
	endif
endfunction

function! MyGetCannonicalZetelkasttenFile(link)
	if stridx(a:link,"/") == -1
		let filename = $HOME."/Zetelkastten/".a:link
		if match(a:link,"\.org$") == -1
			let filename .= ".org"
		endif
		return filename
	else
		return a:link
	endif
endfunction

autocmd Filetype org nnoremap <silent> <buffer> <CR> :call MyOrgModeFollowLinkUnderCursor(v:false)<cr>
autocmd Filetype org nnoremap <silent> <buffer> <C-]> :call MyOrgModeFollowLinkUnderCursor(v:false)<cr>
autocmd Filetype org nnoremap <silent> <buffer> <M-]> :call MyOrgModeFollowLinkUnderCursor(v:true)<cr>
autocmd Filetype org nnoremap <silent> <buffer> <M-CR> :call MyOrgModeFollowLinkUnderCursor(v:true)<cr>

autocmd FileType org imap <silent> <buffer> <expr> <CR> MyOrgModeEnterKeyHandler("CR")
autocmd FileType org nnoremap <silent> <buffer> <expr> o MyOrgModeEnterKeyHandler("o")

let g:MyOrgModeEnterKeyReturnString = {
    \	'numbered_list': {
    \		'CR': " _\<Esc>hr\<CR>k^y/\\.\\|)/e+1\<CR>:nohl\<CR>j^Pldl^\<C-A>@A",
    \		'o': "^y/\\.\\|)/e+1\<CR>:nohl\<CR>o_\<Esc>Pldl^\<C-A>@:call MyOrgModeExitPreviewOnInsert(1)\<CR>A",
    \	},
    \	'bullet_list': {
    \		'CR': " _\<Esc>hr\<CR>k^y2lj^Pldl@A",
    \		'o': "^y2lo_\<Esc>^Pldl@:call MyOrgModeExitPreviewOnInsert(1)\<CR>A",
    \	},
    \	'heading': {
    \		'CR': " _\<Esc>hr\<CR>k^yf j^Pldl@A",
    \		'o': "^yf @o\<C-R>\"",
    \	},
    \	'default': {
    \		'CR': "\<CR>",
    \		'o': "o",
    \	}
    \}

function! _MyOrgModeEnterKeyHandler(cmd)
	let line=getline('.')
	if line =~ '^\s*\(\a\|\d\+\)[.)]\(\s\|$\)'
		return g:MyOrgModeEnterKeyReturnString.numbered_list[a:cmd]
	elseif line =~ '^\(\s*[-+]\|\s\+\*\)\(\s\|$\)'
		return g:MyOrgModeEnterKeyReturnString.bullet_list[a:cmd]
	elseif line =~ '^\*\{1,\} '
		return g:MyOrgModeEnterKeyReturnString.heading[a:cmd]
	else
		return g:MyOrgModeEnterKeyReturnString.default[a:cmd]
	endif
endfunction

function! MyOrgModeEnterKeyHandler(cmd)
	let macro = _MyOrgModeEnterKeyHandler(a:cmd)
	if len(macro)==1
		return macro
	else
		let macro = substitute(macro,"@","\<Plug>MyOrgPResume","")
		return "\<Plug>MyOrgPSuspend" . l:macro
	endif
endfunction

" Part of Orgmode: works around the way nvim treats cursor position
" and scrolls surrounding text in the presence of concealed characters.
autocmd CursorMoved *.org,alt://* call PreviewModeUpdate()
autocmd InsertEnter *.org,alt://* call MyOrgModeExitPreviewOnInsert(0)
autocmd InsertLeave *.org,alt://* call PreviewModeUpdate()
autocmd FileType org nnoremap <silent> <buffer> \q :call TogglePreviewMode()<cr>
autocmd FileType org nnoremap <silent> <buffer> <Esc> :call PreviewModeOff()<cr>
autocmd FileType org nnoremap A :call MyOrgModeExitPreviewOnInsert(1)<CR>A

function! MyOrgModeExitPreviewOnInsert(skip_next)
	if has_key(b:,'PreviewMode') && b:PreviewMode == 1
		if has_key(b:, '_MyOrgModeSkipIE')
			unlet b:PreviewModeStowedLine
			unlet b:_MyOrgModeSkipIE
			return
		endif

		let fixed_curpos = MyOrgModeFixedCursorPos()
		call RestoreStowedLine()
		if !a:skip_next
			unlet b:PreviewModeStowedLine
		endif
		call cursor(0, fixed_curpos)
		let v:char = "p"

		if a:skip_next
			let b:_MyOrgModeSkipIE=1
		elseif has_key(b:,'_MyOrgModeSkipIE')
			unlet b:_MyOrgModeSkipIE
		endif
	endif
endfunction

function! MyOrgModeFixedCursorPos()

	if !has_key(b:,'PreviewModeStowedLine') ||
	\  b:PreviewModeStowedLine.linenr != line(".")
		return col(".")
	endif

	let l:line=getline('.')
	let l:stowed_line = b:PreviewModeStowedLine.line

	let l:line_offset = 0
	let l:stowed_offset = 0
	let l:col = col(".")

	while l:col > 0
		let line_link = s:_mymatchlink(line)
		let stowed_link = s:_mymatchlink(stowed_line)

		if l:line_link.start<0 || l:stowed_link.start<0
		                     \ || l:col < l:line_link.start
			return l:stowed_offset + l:col
		elseif l:col <= l:line_link.end
			if stowed_link.description
			   return l:stowed_offset + l:stowed_link.url_length + l:col
			else
			   return l:stowed_offset + l:col
		        endif
		else
			let l:line = l:line[l:line_link.end:]
			let l:line_offset += l:line_link.end
			let l:stowed_line = l:stowed_line[l:stowed_link.end:]
			let l:stowed_offset += l:stowed_link.end
			let l:col -= l:line_link.end
		endif
	endwhile
	return 0
endfunction

function! s:_mymatchlink(line)
	let l:referencePattern='\v\[(\[([^\]]+)\])(\[([^\]]+)\])?\]'

	if match(a:line, l:referencePattern) > 0
		return { 'start': match(a:line, l:referencePattern)+1,
		\        'end': matchend(a:line, l:referencePattern),
		\        'url_length': len(matchlist(a:line, l:referencePattern)[1]),
		\        'description': matchlist(a:line, l:referencePattern)[3]!='',
		\      }
	else
		return { 'start': -1, 'end': -1, 'url_length':0 }
	endif
endfunction

function! PreviewModeUpdate()
	if !has_key(b:,'PreviewMode') || b:PreviewMode != 1
		return
	endif

	let b:PreviewModifedStatus = &modified

	if has_key(b:,'PreviewModeStowedLine') && b:PreviewModeStowedLine.linenr != line(".")
		call RestoreStowedLine()
	endif

	if !has_key(b:,'PreviewModeStowedLine') || b:PreviewModeStowedLine.linenr != line(".")
		let orig_line=getline(".")
		let b:PreviewModeStowedLine = {}
		let b:PreviewModeStowedLine.linenr = line(".")
		let b:PreviewModeStowedLine.line = l:orig_line

		if orig_line != ""
			let cursor_proxy = "🕅"
			let line = l:orig_line[:col(".")-1] . cursor_proxy . l:orig_line[col("."):]
			let line = substitute(line,'\v\['.cursor_proxy.'\[([^\]]+)\]\[([^\]]+)\]\]','[['.cursor_proxy.'\2]]',"g")
			let line = substitute(line,'\v\[\[([^\]]*)'.cursor_proxy.'([^\]]*)\]\[([^\]]+)\]\]','[['.cursor_proxy.'\3]]',"g")
			let line = substitute(line,'\v\[\[([^\]]+)\]\[([^\]]+)\]\]','[[\2]]',"g")
			let cursor_pos = stridx(line, cursor_proxy)
			" Note that cursor_proxy we chose takes 4 bytes
			let line = l:line[:l:cursor_pos-1] . l:line[l:cursor_pos+4:]

			if orig_line != l:line
				undojoin
				call setline(".",l:line)
				call RestoreModifiedStatus()
			endif
			call cursor(0, cursor_pos)
		endif
	endif
endfunction

function! RestoreStowedLine()
	if b:PreviewModeStowedLine.line != getline(b:PreviewModeStowedLine.linenr)
		undojoin
		call setline(b:PreviewModeStowedLine.linenr,b:PreviewModeStowedLine.line)
		call RestoreModifiedStatus()
	endif
endfunction

function! RestoreModifiedStatus()
	if !b:PreviewModifedStatus
		set nomodified
	endif
endfunction

function! TogglePreviewMode()
	if has_key(b:,'PreviewMode')
		let b:PreviewMode = b:PreviewMode==0?1:0
	else
		let b:PreviewMode = 1
	endif

	if b:PreviewMode == 0
		if has_key(b:,'PreviewModeStowedLine')
			call RestoreStowedLine()
			unlet b:PreviewModeStowedLine
		endif
	else
		let b:PreviewModifedStatus = &modified
	endif

	echo "Preview mode ".(b:PreviewMode?"on":"off")
endfunction

function! PreviewModeOff()
	if has_key(b:,'PreviewMode') && b:PreviewMode == 1
		call TogglePreviewMode()
	endif
endfunction

" Restore the current line before writing file to disk
autocmd BufWritePre *.org call MyOrgRestoreBeforeWrite()
function! MyOrgRestoreBeforeWrite()
	if has_key(b:,'PreviewMode') && b:PreviewMode == 1 &&
	\  has_key(b:,'PreviewModeStowedLine')
		call RestoreStowedLine()
	endif
endfunction

" These are for use in key mappings that change buffer content
" and might have adverse interactions with the Preview mode logic.
nnoremap <Plug>MyOrgPSuspend :call MyOrgModeSuspendPreview()<CR>
inoremap <Plug>MyOrgPSuspend <Esc>:call MyOrgModeSuspendPreview()<CR>a
nnoremap <Plug>MyOrgPResume :call MyOrgModeResumePreview()<CR>
inoremap <Plug>MyOrgPResume <Esc>:call MyOrgModeResumePreview()<CR>a

function! MyOrgModeSuspendPreview()
	if has_key(b:,'PreviewMode') && b:PreviewMode == 1
		let b:PreviewMode = 2
	endif
endfunction

function! MyOrgModeResumePreview()
	if has_key(b:,'PreviewMode') && b:PreviewMode == 2
		let b:PreviewMode = 1
	endif
endfunction

" Orgmode links autocompletion in insert mode
autocmd FileType org inoremap <silent> <expr> <buffer> <C-P> MyOrgLinkAutocomplete()

function! MyOrgLinkAutocomplete()
	let line_text = getline(".")[:col(".")-2]
	let base_pos = match(line_text,'\[\[[^\]]*$')
	if base_pos > -1
		return("\<C-R>=_MyOrgLinkAutocomplete(".base_pos.")\<CR>")
	else
		return "\<C-P>"
	endif
endfunction

function! _MyOrgLinkAutocomplete(base_pos)
	let prefix = getline(".")[a:base_pos+2:col(".")-2]
	let compres = MyZetelkasttenAutocomplete(prefix, getline("."), col("."))
	call complete(a:base_pos+3,compres)
	return ''
endfunction

" yank an orgmode link to register
autocmd FileType org nnoremap <silent> <buffer> yal :call MyOrgModeYankLink(v:register)<CR>
autocmd FileType org nnoremap <silent> <buffer> p :call MyOrgModePut(v:register, "p")<CR>
autocmd FileType org nnoremap <silent> <buffer> P :call MyOrgModePut(v:register, "P")<CR>

function! MyOrgModeYankLink(register)
	let link = MyOrgModeGetLinkUnderCursor(0)
	if link != ""
		call setreg(a:register,l:link)
		echo link
	endif
endfunction

function! MyOrgModePut(register, cmd)
	if has_key(b:,'PreviewMode') && b:PreviewMode == 1
		let savedview = winsaveview()
		if has_key(b:,'PreviewModeStowedLine')
			call MyOrgModeExitPreviewOnInsert(0)
		endif
		exe "norm!" "\"".a:register.a:cmd
		call PreviewModeUpdate()
		call winrestview(l:savedview)
	else
		exe "norm!" "\"".a:register.a:cmd
	endif
endfunction

" Navigate between diary entries
function! MyEditDiary(what)
	
	let directory=expand("%:p:h")
	let file_list=glob(directory.'/*',v:false,v:true)
		    \ ->sort("MyEditDiaryCompare")
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

function! MyEditDiaryCompare(f1,f2)
	let s1=a:f1[-8:-5].a:f1
	let s2=a:f2[-8:-5].a:f2
	return l:s1>l:s2?1:-1
endfunction

autocmd BufNewFile,BufRead */Zetelkastten/Daily\ Log/* nnoremap <silent> <buffer> <A-Left> :call MyEditDiary("prev")<cr>
autocmd BufNewFile,BufRead */Zetelkastten/Daily\ Log/* nnoremap <silent> <buffer> <A-Right> :call MyEditDiary("next")<cr>
command! -nargs=? -complete=customlist,MyZetelkasttenAutocomplete 
       \ Note call ZetelkasttenFrontEnd(<f-args>)

function! ZetelkasttenFrontEnd(...)
	if a:0==0
		exe "edit " . $HOME . "/Zetelkastten/Daily Log/" . strftime("%m-%d-%Y") . ".org"
		return
	endif

	let cmd="find $HOME/Zetelkastten -name Apropos -prune -o -not -type d -name "
	let cmd.="'".a:1."*' -printf '%f\t%p\n' | sed 's/\.org\t/\t/' | sort -t$\'\t\' -k1,1 | cut -f2"

	let files=split(system(cmd),"\n")
	if len(files)>0
		exe "edit ".fnameescape(files[0])
	else
		exe "edit ".fnameescape($HOME . "/Zetelkastten/" . a:1 . ".org")
	endif
endfunction

function! MyZetelkasttenAutocomplete(arglead, cmdline, cursorpos)
	let cmd="find $HOME/Zetelkastten -name Apropos -prune -o -not -type d -name "
	let cmd.="'".a:arglead."*' -printf '%f\\n' | sort -r"
	return split(system(cmd),"\n")->map('substitute(v:val,"\.org$","","")')
endfunction

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
		let result=system(external_cmd)->trim()
		if result==""
			let result=finddir('.hg/..', a:dir.';')
		endif
		return result
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

" When writing file, automatically create parent directories if they do not exist
autocmd BufWritePre,FileWritePre * call MyAutoMkdir()
function! MyAutoMkdir()
	let dir=expand("<afile>:p:h")
	if dir !~ '^[^/:]*://' && dir !~ '^Dictionary:'
		if !isdirectory(dir)
			echo "Making directory ".dir."\n"
			call mkdir(dir,"p")
		endif
	endif
endfunction

" Open current file's directory in Netrw like vinegar
nmap <silent> <expr> - MyRevealCurrentFileInNetrw()
function! MyRevealCurrentFileInNetrw()
	if &filetype != "netrw"
		if expand("%:t") == ""
			return ":Explore\<CR>"
		else
			return ":Explore\<CR>/" . expand("%:t") . "\<CR>:nohl\<CR>"
		endif
	else
		return "-"
	endif
endfunction

function! GetNetrwfile()
	if &filetype != "netrw"
		return ""
	endif
	let abs_file = b:netrw_curdir . '/' . getline(".")
	let rel_file = fnamemodify(abs_file,":.")
	return fnameescape(rel_file)
endfunction

autocmd Filetype netrw nnoremap <buffer> ~ :edit ~/<CR>
autocmd Filetype netrw nnoremap <buffer> <expr> . ":\<C-U> ".GetNetrwfile()."\<Home>"
autocmd Filetype netrw nnoremap <buffer> <silent> y. :<C-U>:call setreg(v:register,b:netrw_curdir.'/'.getline("."))<CR>
autocmd Filetype netrw cnoremap <buffer> <expr> <C-R><C-F> GetNetrwfile()

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

	if !s:my_find_window(function('s:is_info_window'))
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
	silent keepjumps exe "read" "!".b:dict_prg." ".l:word
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

" Dictionary selection menu
autocmd FileType dictionary nnoremap \, :call MyDictionarySelectionMenu()<cr>
function! MyDictionarySelectionMenu()
	if MyStartMenu("Select Dictionary")
		call append('$',['   Dictionaries:',''])
		call append('$',MyMenuButton(0)."Meriam-Webster")
		call MyMenuRegister(line('$'),0,"call MyDict_sl('webster')")
		call append('$',MyMenuButton(1)."Cambridge")
		call MyMenuRegister(line('$'),1,"call MyDict_sl('cambridge')")
		call append('$',MyMenuButton(2)."Google define")
		call MyMenuRegister(line('$'),2,"call MyDict_sl('google')")
		call append('$',MyMenuButton(3)."Google translate")
		call MyMenuRegister(line('$'),3,"call MyDict_sl('translate')")
		call append('$',MyMenuButton(4)."Dict service")
		call MyMenuRegister(line('$'),4,"call MyDict_sl('dict')")
		call append('$','')
		nnoremap <silent> <buffer> q :Bdelete<cr>
		call MyMenuFinish()
	endif
endfunction

function! MyDict_sl(dictionary)
	norm 
	exe "Dict @".a:dictionary
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
		nnoremap <silent> <buffer> d :call MyBufferSelectionDelete()<cr>
		call MyMenuFinish()
	endif
endfunction

function! MyBufferSelectionDelete()
	if has_key(b:MyMenu.entries, line('.'))
		exe substitute(b:MyMenu.entries[line('.')].command,'^bu','Bdelete',"")
		Bdelete
		call MyBufferSelectionMenu()
	endif
endfunction

" Open alternative file for the current buffer
autocmd BufReadCmd alt://* call MyAltFileLoad(expand('<afile>'))
function! MyAltFileLoad(url)
	let l:altfilename = system("sha1sum",a:url)
	let l:altfilename = substitute(l:altfilename," .*$",".org","")
	let l:filename = $HOME."/Zetelkastten/Apropos/".l:altfilename

	if filereadable(l:filename)
		silent keepjumps exe "read" l:filename
		silent keepjumps 1delete _
		let redirect = matchlist(getline(1),'\v\[\[Redirect:(.*)\]\]')
		if redirect != []
			let b:CanonicalZetelkasttenFile = MyGetCannonicalZetelkasttenFile(l:redirect[1])
			%delete _
			if filereadable(b:CanonicalZetelkasttenFile)
			   silent keepjumps exe "read" b:CanonicalZetelkasttenFile
			   silent keepjumps 1delete _
			endif
		endif
		silent keepjumps norm gg
		setlocal nomodified
	endif

	set filetype=org
endfunction

autocmd BufWriteCmd alt://* call MyAltFileWrite(expand('<afile>'))
function! MyAltFileWrite(url)
	let l:altfilename = system("sha1sum",a:url)
	let l:altfilename = substitute(l:altfilename," .*$",".org","")

	if exists("b:CanonicalZetelkasttenFile")
		let l:filename = b:CanonicalZetelkasttenFile
	else
		let l:filename = $HOME."/Zetelkastten/Apropos/".l:altfilename
	endif

	exe "write!" l:filename
	setlocal nomodified
endfunction

command! -nargs=? Alternative call MyAlternativeFile(<q-args>, expand("%:p"))
function! MyAlternativeFile(modifier, file)
	if a:file =~# '^alt://'
		exe "edit" substitute(a:file, '^alt://\(([^)]*)\)\?', "", "")
	else
		call MyOrgModeEditLinkedFile("alt://".(a:modifier==""?"":"(".a:modifier.")").a:file)
	endif
endfunction

" Execute shell command in terminal buffer à la Emacs compile/recompile
command! -nargs=? -complete=shellcmd Term call MyExecuteInTerminal(<q-args>)
function! MyExecuteInTerminal(...)
	if !s:my_find_window(function('s:is_my_terminal'))
		top split
		term
		let b:exe_terminal = 1
		nnoremap <buffer> gg gg0/ivan@ivan-laptop:<cr>:nohl<cr>zt
		nnoremap <buffer> <silent> q :bdelete!<cr>
	endif
	if exists("b:terminal_job_id")
		set scrollback=1
		set scrollback=-1
		if a:1 != ""
			call chansend(b:terminal_job_id, "".a:1."")
			stopinsert
		else
			call chansend(b:terminal_job_id, "")
		endif
	endif
endfunction

function! s:is_my_terminal()
	return exists("b:exe_terminal")
endfunction

" Calendar picker
function! DaysInMonth(m,y)
	return 31-(a:m-2?(a:m-1)%7%2:and(a:y,a:y%25?3:15)?3:2)
endfunction

function! Month(year, month, opts)
	let table={ 'year': a:year, 'month': a:month, 'opts': a:opts }
	let day=system('date -d'.a:year.'-'.a:month.'-01 "+%u"')->trim()
	let day=day%7
	let date=1
	let week=1
	let lastdate=DaysInMonth(a:month, a:year)
	while !(date>lastdate)
		let table[week.day]=date
		let week+=day==6
		let day=(day+1)%7
		let date+=1
	endwhile
	return table
endfunction

function! s:userMark(month,day)
	if has_key(a:month.opts,"marks")
		let date=a:month.year.'-'.a:month.month.'-'.a:month[a:day]
		return has_key(a:month.opts.marks,date)?a:month.opts.marks[date]:" "
	else
		return " "
	endif
endfunction

function! Week(number, month)
	let result=""
	let day=0
	while day<7
		if has_key(a:month,a:number.day)
		   let result.=printf("%2s%s",a:month[a:number.day],
		                            \ s:userMark(a:month,a:number.day))
		else
		   let result.="   "
		endif
		let day+=1
	endwhile
	return result
endfunction

function! Center(string, line_length)
	let lpadding=repeat(" ",(a:line_length-len(a:string))/2)
	let rpadding=repeat(" ",a:line_length-len(a:string)-len(lpadding))
	return l:lpadding.a:string.l:rpadding
endfunction

function! _Calendar(year, opts={})
	call append('$',Center(a:year,64))
	call _ThreeMonthsCalendar(a:year,1,a:opts)
	call _ThreeMonthsCalendar(a:year,4,a:opts)
	call _ThreeMonthsCalendar(a:year,7,a:opts)
	call _ThreeMonthsCalendar(a:year,10,a:opts)
endfunction

let MonthName=["January","February","March",
              \"April","May","June",
              \"July","August","September",
              \"October","November","December"]

function! _ThreeMonthsCalendar(year, month, opts={})
	call append('$',Center(g:MonthName[a:month-1],20)."  ".
	              \ Center(g:MonthName[a:month],20)."  ".
                      \ Center(g:MonthName[a:month+1],20))
	call append("$",repeat("Su Mo Tu We Th Fr Sa  ",3))

	let Month1=Month(a:year,a:month,a:opts)
	let Month2=Month(a:year,a:month+1,a:opts)
	let Month3=Month(a:year,a:month+2,a:opts)
	let week=1
	while week<7
		call append("$", Week(week,Month1)." ".
		               \ Week(week,Month2)." ".
		               \ Week(week,Month3))
		let week+=1
	endwhile
	call append("$",'')

endfunction

function! _SingleMonthCalendar(year, month, opts={})
	let Month1=Month(a:year,a:month,a:opts)
	call append("$",Center(g:MonthName[a:month-1],20))
	call append("$","Su Mo Tu We Th Fr Sa")
	call append("$",Week(1,Month1))
	call append("$",Week(2,Month1))
	call append("$",Week(3,Month1))
	call append("$",Week(4,Month1))
	call append("$",Week(5,Month1))
	call append("$",'')
endfunction

function! SingleMonthCalendar(year, month, opts={})
	call SetupCallendarBuffer({'type': 1, 'year': a:year, 'month': a:month}, a:opts)
	call append('$',Center(a:year,20))
	call _SingleMonthCalendar(a:year, a:month, a:opts)
endfunction

function! ThreeMonthsCalendar(year, month, opts={})
	call SetupCallendarBuffer({'type': 3, 'year': a:year, 'month': a:month}, a:opts)
	call append('$',Center(a:year,64))
	call _ThreeMonthsCalendar(a:year, a:month, a:opts)
endfunction

function! Calendar(year, opts={})
	call SetupCallendarBuffer({'type':12, 'year':a:year},a:opts)
	call _Calendar(a:year, a:opts)
endfunction

function! SetupCallendarBuffer(type,opts)
	enew
	file Calendar
	silent! setlocal noswapfile buftype=nofile
	set filetype=pcalendar
	let b:pcalendar={'type': a:type, 'opts': a:opts}
	nnoremap <buffer> <silent> <CR> :call MyCallendarSelectDate()<cr>
	nnoremap <buffer> <silent> <A-Left> :call MyCallendarPrev()<cr>
	nnoremap <buffer> <silent> <A-Right> :call MyCallendarNext()<cr>
	nnoremap <buffer> <silent> q :Bdelete!<cr>
	autocmd startify CursorMoved <buffer> call MyCalendarFixCursorPosition()
endfunction

function! MyCalendarFixCursorPosition()
	let oldcol=has_key(b:pcalendar,"newcol")?b:pcalendar.newcol:2
	let b:pcalendar.newcol=col(".")
	let linepos=line(".")
	let colpos=col(".")
	if l:linepos<4 || l:linepos>37
		return 0
	endif

	if index([13,22,31],linepos)>-1
		let linepos-=3
		if trim(getline(linepos)[22*(colpos/22):22*(1+colpos/22)-1])==""
			let linepos-=1
		endif
		while colpos>0 && getline(linepos)[colpos-1]!~'[0-9]'
			let colpos-=1
		endwhile
	elseif trim(getline(linepos)[22*(colpos/22):22*(1+colpos/22)-1])==""
		let linepos+=1
		if trim(getline(linepos)[22*(colpos/22):22*(1+colpos/22)-1])==""
			let linepos+=3
		else
			let linepos+=2
		endif
		while colpos<64 && getline(linepos)[colpos-1]!~'[0-9]'
			let colpos+=1
		endwhile
	endif

	if colpos%22==21
		let colpos+=colpos>oldcol?2:-1
	endif
	if colpos%22==0
		let colpos+=colpos>oldcol?2:-2
	endif

	let slot=getline(linepos)[22*(colpos/22):22*(1+colpos/22)-1]
	if slot[0:1]=~'[ 0-9][0-9]' && trim(slot[colpos%22-1:])=="" && colpos==oldcol
		let dir=-1
	elseif slot[18:19]=~'[ 0-9][0-9]' && trim(slot[0:colpos%22-1])=="" && colpos==oldcol
		let dir= 1
	else
		let dir=b:pcalendar.newcol>oldcol?1:-1
	endif

	if (colpos%22)%3==1 && oldcol-colpos==1 && colpos>1
		let colpos-=2
	endif

	while getline(linepos)[colpos-1]!~'[0-9]' && colpos>1 && colpos<64
		let colpos+=dir
	endwhile
	let colpos+=(colpos%22)%3==1?1:0

	let b:pcalendar.newcol=l:colpos
	call cursor(linepos, colpos)
endfunction

function! MyCallendarSelectDate()
	let result=MyCallendarGetSelectedDate()
	if result!="" && has_key(b:pcalendar.opts,"selection_cb")
		call b:pcalendar.opts.selection_cb(result)
	endif
endfunction

function! MyCallendarGetSelectedDate()
	let curline=getline(".")
	let pos=col(".")
	if pos>1 && curline[pos-1] =~ '[0-9]' && curline[pos-2] =~ '[0-9]'
		let pos-=1
	endif
	if has_key(b:pcalendar.opts,"returnOnlyLinks") &&
	 \ b:pcalendar.opts.returnOnlyLinks &&
	 \ curline[pos-1:] !~ '[ 0-9][0-9]_'
		return ""
	endif
	if curline[pos-1:] !~ '[ 0-9][0-9][@_+* ]'
		return ""
	endif
	let day=trim(substitute(curline[pos-1:pos],"[@_*+]$","",""))
	let cline=line(".")-1
	while cline>0
		let slot=getline(cline)[22*(pos/22):22*(1+pos/22)]
		let month=matchlist(slot,'\v^ +([A-Z][a-z]*) +$')
		if month != []
			break
		endif
		let cline-=1
	endwhile
	if cline==0 || index(g:MonthName,month[1])==-1
		return ""
	endif
	let month=index(g:MonthName,month[1])+1
	return b:pcalendar.type.year."-".month."-".day
endfunction

function! MyCallendarPrev()
	if &filetype!='pcalendar'
		return
	endif
	%delete
	if b:pcalendar.type.type == 1
		let b:pcalendar.type.month=max([1,b:pcalendar.type.month-1])
		call _SingleMonthCalendar(b:pcalendar.type.year,
		                        \ b:pcalendar.type.month,
		                        \ b:pcalendar.opts)
	elseif b:pcalendar.type.type == 3
		let b:pcalendar.type.month=max([1,b:pcalendar.type.month-3])
		call _ThreeMonthsCalendar(b:pcalendar.type.year,
		                        \ b:pcalendar.type.month,
		                        \ b:pcalendar.opts)
	elseif b:pcalendar.type.type == 12
		let b:pcalendar.type.year=max([1,b:pcalendar.type.year-1])
		call _Calendar(b:pcalendar.type.year,
		             \ b:pcalendar.opts)
	endif
endfunction

function! MyCallendarNext()
	if &filetype!='pcalendar'
		return
	endif
	%delete
	if b:pcalendar.type.type == 1
		let b:pcalendar.type.month=min([12,b:pcalendar.type.month+1])
		call _SingleMonthCalendar(b:pcalendar.type.year,
		                        \ b:pcalendar.type.month,
		                        \ b:pcalendar.opts)
	elseif b:pcalendar.type.type == 3
		let b:pcalendar.type.month=min([12,b:pcalendar.type.month+3])
		call _ThreeMonthsCalendar(b:pcalendar.type.year,
		                        \ b:pcalendar.type.month,
		                        \ b:pcalendar.opts)
	elseif b:pcalendar.type.type == 12
		let b:pcalendar.type.year=b:pcalendar.type.year+1
		call _Calendar(b:pcalendar.type.year,
		             \ b:pcalendar.opts)
	endif
endfunction

command! -bang -nargs=? Calendar
	\ :call MyCalendarCommand(<q-bang>, <q-args>)

function! MyCalendarCommand(bang, year)
	let l:year=a:year==""?strftime("%Y"):a:year
	if a:bang=="!"
		split
	endif
	call ZetelkasttenCalendar(l:year)
endfunction

" Zetelkastten daily log: calendar view
function! ZetelkasttenCalendar(year)
	let Zetelkastten=expand("~/Zetelkastten/Daily Log/")
	let file_list=glob(Zetelkastten.'*',v:false,v:true)
	let zetel_marks={}
	for file in l:file_list
		let date=substitute(file,'\v(.*)/([0-9-]+).org','\2',"")
		let date=substitute(date,'\v([0-9][0-9])-([0-9][0-9])-([0-9][0-9][0-9][0-9])','\3-\1-\2',"")
		let date=substitute(date,'^0',"","")
		let date=substitute(date,"-0","-","g")
		let l:zetel_marks[l:date]="_"
	endfor
	call Calendar(a:year, {'marks': zetel_marks, 'selection_cb': function('ZetelkasttenCalendar_cb')})
endfunction

function! s:_padn(string)
	return len(a:string)==1?"0".a:string:a:string
endfunction

function! ZetelkasttenCalendar_cb(date)
	let date_comp=matchlist(a:date, '\v([0-9][0-9][0-9][0-9])-([1-9][0-9]?)-([1-9][0-9]?)')
	let filename=s:_padn(s:_padn(date_comp[2])."-".s:_padn(date_comp[3])."-".date_comp[1])
	execute 'edit '.expand("~/Zetelkastten/Daily Log/").l:filename.".org"
endfunction

" Vimscript abbreviations
function! s:_VimScriptAbbrev(opening,closing)
	exe "iabbrev <buffer> <expr> " . a:opening . ' ' .
	\   'getline(".")[:col(".")] =~ "^[\t ]*' . a:opening . '$"?' .
	\   '"' . a:opening . '\<CR>.\<Backspace>\<CR>' . a:closing . '\<Up>\<Up>":' .
	\   '"' . a:opening . '"'
endfunction

auto FileType vim call <SID>_VimScriptAbbrev("if","endif")
auto FileType vim call <SID>_VimScriptAbbrev("for","endfor")
auto FileType vim call <SID>_VimScriptAbbrev("while","endwhile")
auto FileType vim call <SID>_VimScriptAbbrev("try","endtry")
auto FileType vim call <SID>_VimScriptAbbrev("function!","endfunction")

" Wcd integration
function! MyWcd(arguments)
	function! s:MyWcdOnTerminalExit() closure
		exe 'silent! bd! ' . buffer_nr
		let go_filename = (exists("$WCDHOME")?$WCDHOME:$HOME) . '/bin/wcd.go'
		let result = readfile(go_filename,'',10)
		for line in result
			if line =~ '^cd '
				call MyWcd_change2dir(line[3:])
			endif
		endfor
	endfunction

	if a:arguments =~ '^-g\>\|[\t ]-g\>'
		bot split
		enew
		let buffer_nr = bufnr("%")
		call termopen("wcd.exec " . a:arguments,
		\    {'on_exit':{job,status -> s:MyWcdOnTerminalExit()}})
		return
	endif

	let result=system("wcd.exec -o " . a:arguments)
	if result =~ '^-> '
		call MyWcd_change2dir(result[3:len(result)-2])
		return
	endif
	let result = substitute(result,'\nPlease choose one[^\n]*',"","")
	try
		echo result
	finally
		echo "Please choose one:"
		let response=input(":")
	endtry
	let lines=split(result,"\n")
	for line in lines
		let fields = matchlist(line,'\v^([0-9]+)[\t ]*(.*)$')
		if !empty(fields)
			if fields[1] == l:response ||
			\  fields[1] == char2nr(l:response)-char2nr('a')+1
				call MyWcd_change2dir(fields[2])
			endif
		endif
	endfor
endfunction

function! MyWcd_change2dir(directory)
	let s:MyDelayedMsg = a:directory
	call timer_start(10, "<SID>MyShowDelayedMsg")
	exe "cd" fnameescape(a:directory)
endfunction

function! s:MyShowDelayedMsg(timer_id)
	echo s:MyDelayedMsg
endfunction

command! -nargs=1 Wcd call MyWcd('<args>')
cabbr <expr> wcd getcmdtype() == ":" && getcmdpos() == 4?"Wcd":"wcd"

" TeX/Latex support
let g:MyLatexCmd = "latexmk -pdf -pvc"
auto FileType tex nnoremap <buffer> <C-C><C-C> :update \| call MyTerminalWrapper(v:false,g:MyLatexCmd . " " . shellescape(expand("%")))<CR>

" Graphviz support
let g:MyGraphvizCmd = "graphvizmk -pvc"
auto FileType dot nnoremap <buffer> <C-C><C-C> :update \| call MyTerminalWrapper(v:false,g:MyGraphvizCmd . " " . shellescape(expand("%")))<CR>
