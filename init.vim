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
  call dein#add('HiPhish/info.vim', {'on_cmd': 'Info'})

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

" Add Hoc Plugins
  call dein#add('tyru/capture.vim')
  call dein#add('tpope/vim-commentary')
  call dein#add('mhinz/vim-startify')
  call dein#add('junegunn/vim-peekaboo')
  call dein#add('dyng/ctrlsf.vim', {'on_cmd': 'CtrlSF<Space>'})

  call dein#end()
  call dein#save_state()

endif

" Open new vertical window to the right
set splitright

" No status line if there's just one window
set laststatus=1

" Colorscheme
highlight CursorLine ctermbg=239 cterm=NONE
highlight VertSplit ctermfg=7
highlight StatusLineNC ctermfg=7

" Gitgutter plugin configuration
highlight! link SignColumn LineNr
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

" NerdTree plugin configuration
nnoremap <silent> <A-f> :NERDTreeToggle<cr>
let NERDTreeMinimalUI=1

" Close NERDTree if it's the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" DelimitMate (autoclosing) plugin configuration
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1

" Source current file when editing vim script
auto FileType vim nnoremap <buffer> <C-C><C-C> :update \| source %<cr>

" Allways start terminal in insert mode
autocmd BufEnter term://* startinsert
autocmd TermOpen * startinsert
tnoremap <Esc><Esc> <C-\><C-N>

" Utility functions
function! MyError(msg)
	echohl ErrorMsg
	echomsg a:msg
	echohl NONE
	let v:errmsg = a:msg
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
		if elapsed_time > 2
			return "\b"
		endif
	endif
	return ':call MySmartBackspace_normal()'
endfunction

nnoremap <Backspace> :call MySmartBackspace_normal()<cr>
tnoremap <expr> <Backspace> MySmartBackspace_terminal()
