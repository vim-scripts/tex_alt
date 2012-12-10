" make sure the plugin hasn't been loaded yet and save something
if exists("b:did_tex_alt_ftplugin") || version < 700
	finish
endif
let b:did_tex_alt_ftplugin = 1
let s:cpo_save = &cpo
set cpo&vim


" - config ------------------------------------------------------------------------------


let b:tex_alt_flavour = "xelatex"


" =======================================================================================

" - maps --------------------------------------------------------------------------------


" compile and open the quickfix window
nnoremap <F9> :w<CR>:silent make % \| redraw! \| cw<CR>
nnoremap <F12> :TagbarToggle<CR>


" - settings ----------------------------------------------------------------------------


filetype indent off
" autocomplete in \ref’s with C-n
setlocal iskeyword+=:,-
" can be longer than the general setting which has to be lower because of xml
setlocal synmaxcol=3000
" exclude from autocompletion in file selection
setlocal wildignore=*.aux,*.dvi,*.log,*.pdf

" compilation
let &makeprg = b:tex_alt_flavour . " -file-line-error -interaction=nonstopmode $*"
" let quickfix know where the errors are in TeX’s output
setlocal errorformat=%f:%l:\ %m

" autofolding
" let tex_fold_enable=1
" set foldmethod=indent
" syn sync fromstart


" - tagbar ------------------------------------------------------------------------------


let g:tagbar_autofocus=1		" focus on open tagbar
let g:tagbar_left=1				" show on the left
let g:tagbar_width=20			" the default 40 is too wide
let g:tagbar_type_tex_alt = {
	\ 'ctagstype'	: 'tex_alt',
	\ 'kinds'		: [
		\ 's:sections',
		\ 'l:labels',
	\ ],
	\ 'sort'		: 0,
\ }



" =======================================================================================


let &cpo = s:cpo_save
finish
