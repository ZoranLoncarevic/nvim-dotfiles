" Personal version of org-mode

" Inline markup {{{1
" *bold*, /italic/, _underline_, +strike-through+, =code=, ~verbatim~
syntax region org_bold      matchgroup=org_border_bold start="[^ \\]\zs\*\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs\*\|\(^\|[^\\]\)\@<=\*\S\@="     end="[^ \\]\zs\*\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs\*\|[^\\]\zs\*\S\@="  concealends oneline
syntax region org_italic    matchgroup=org_border_ital start="[^ \\]\zs\/\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs\/\|\(^\|[^\\]\)\@<=\/\S\@="     end="[^ \\]\zs\/\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs\/\|[^\\]\zs\/\S\@="  concealends oneline
syntax region org_underline matchgroup=org_border_undl start="[^ \\]\zs_\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs_\|\(^\|[^\\]\)\@<=_\S\@="        end="[^ \\]\zs_\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs_\|[^\\]\zs_\S\@="     concealends oneline
syntax region org_code      matchgroup=org_border_code start="[^ \\]\zs=\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs=\|\(^\|[^\\]\)\@<==\S\@="        end="[^ \\]\zs=\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs=\|[^\\]\zs=\S\@="     concealends oneline
syntax region org_code      matchgroup=org_border_code start="[^ \\]\zs`\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs`\|\(^\|[^\\]\)\@<=`\S\@="        end="[^ \\]\zs'\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs'\|[^\\]\zs'\S\@="     concealends oneline
syntax region org_verbatim  matchgroup=org_border_verb start="[^ \\]\zs\~\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs\~\|\(^\|[^\\]\)\@<=\~\S\@="     end="[^ \\]\zs\~\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs\~\|[^\\]\zs\~\S\@="  concealends oneline
syntax region org_strikethrough  matchgroup=org_border_strike start="[^ \\]\zs+\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs+\|\(^\|[^\\]\)\@<=+\S\@="     end="[^ \\]\zs+\|\(\(^\|[^\\]\)\zs\(\\\\\)\+\)\zs+\|[^\\]\zs+\S\@="  concealends oneline

hi def org_bold      term=bold      cterm=bold      gui=bold
hi def org_italic    term=italic    cterm=italic    gui=italic
hi def org_underline term=underline cterm=underline gui=underline
hi def org_strikethrough term=strikethrough cterm=strikethrough gui=strikethrough

hi link org_border_bold org_bold
hi link org_border_ital org_italic
hi link org_border_undl org_underline

" Headings: {{{1
let g:org_heading_highlight_colors = ['Title', 'Constant', 'Identifier', 'Statement', 'PreProc', 'Type', 'Special']
let g:org_heading_highlight_levels = len(g:org_heading_highlight_colors)

unlet! s:i s:j s:contains
let s:i = 1
let s:j = len(g:org_heading_highlight_colors)
let s:contains = ' contains=org_bold,org_italic,org_underline,org_code,org_verbatim'
let s:contains = s:contains . ',org_shade_stars'
syntax match org_shade_stars /^\*\{2,\}/me=e-1 contained
hi def link org_shade_stars Ignore

while s:i <= g:org_heading_highlight_levels
	exec 'syntax match org_heading' . s:i . ' /^\*\{' . s:i . '\}\s.*/' . s:contains
	exec 'hi def link org_heading' . s:i . ' ' . g:org_heading_highlight_colors[(s:i - 1) % s:j]
	let s:i += 1
endwhile
unlet! s:i s:j s:contains

syntax match org_H1 "^#.\+$" 
syntax match org_H2 "^##.\+$" 
syntax match org_H3 "^###.\+$" 
syntax match org_H4 "^####.\+$" 

highlight org_H1 ctermfg=2
highlight link org_H2 StorageClass
highlight link org_H3 StorageClass
highlight link org_H4 StorageClass

" htmlLink
" Hyperlinks: {{{1
syntax match hyperlink	"\[\{2}[^][]*\(\]\[[^][]*\)\?\]\{2}" contains=hyperlinkBracketsLeft,hyperlinkURL,hyperlinkBracketsRight containedin=ALL
syntax match hyperlinkBracketsLeft	contained "\[\{2}#\?"     conceal
syntax match hyperlinkURL		contained "[^][]*\]\["    conceal
syntax match hyperlinkBracketsRight	contained "\]\{2}"        conceal
hi def link hyperlink Underlined

" Bullet Lists: {{{1
" Ordered Lists:
" 1. list item
" 1) list item
" a. list item
" a) list item
syn match org_list_ordered "^\s*\(\a\|\d\+\)[.)]\(\s\|$\)" nextgroup=org_list_item
hi def link org_list_ordered Identifier

" Unordered Lists:
" - list item
" * list item
" + list item
" + and - don't need a whitespace prefix
syn match org_list_unordered "^\(\s*[-+]\|\s\+\*\)\(\s\|$\)" nextgroup=org_list_item
hi def link org_list_unordered Identifier

" Definition Lists:
" - Term :: expl.
" 1) Term :: expl.
syntax match org_list_def /.*\s\+::/ contained
hi def link org_list_def PreProc

syntax match org_list_item /.*$/ contained contains=org_subtask_percent,org_subtask_number,org_subtask_percent_100,org_subtask_number_all,org_list_checkbox,org_bold,org_italic,org_underline,org_code,org_verbatim,org_timestamp,org_timestamp_inactive,org_list_def
syntax match org_list_checkbox /\[[ X-]]/ contained
hi def link org_list_bullet Identifier
hi def link org_list_checkbox     PreProc
