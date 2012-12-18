" make sure the plugin hasn't been loaded yet and save something
if exists("b:did_tex_alt_ftplugin") || version < 700
	finish
endif
let b:did_tex_alt_ftplugin = 1
let s:cpo_save = &cpo
set cpo&vim


" - config ------------------------------------------------------------------------------


" LaTeX flavour
let b:tex_alt_flavour = "xelatex"
" auto update tags on file open and save?
let b:tex_alt_auto_tags = 1


" =======================================================================================


" - autocommands & maps -----------------------------------------------------------------

" update tags on file open and save
if b:tex_alt_auto_tags
	autocmd! BufRead,BufWrite *.tex call <SID>GenerateTags()
endif

" compile and open the quickfix window
nnoremap <F9> :w<CR>:silent make % \| redraw! \| cw<CR>
nnoremap <F12> :TagbarToggle<CR>


" - completion --------------------------------------------------------------------------


" custom completion (see below)
setlocal completefunc=TexAltAutoComplete
" let the user keep typing after the menu pops up,
"	and open the menu even if there is nothing to match against yet
setlocal completeopt=longest,menuone
" make sure traditional LaTeX labels are understood
setlocal iskeyword+=:,-
" set the location of the dictionary
let s:dictPath = fnameescape (expand("<sfile>:h") . "/tex_alt.dict")
if &dictionary == ""
	let &dictionary = s:dictPath
else
	let &dictionary = &dictionary . "," . s:dictPath
endif
" smaller popup
setlocal pumheight=20
" auto completion popup
inoremap \ \<C-x><C-u><C-n>
inoremap <expr> { <SID>CheckComplKeyword()
" alternative key shortcut for completion
inoremap <expr> <CR>	pumvisible() ? "\<C-y>" : "\<CR>"


" - options -----------------------------------------------------------------------------


filetype indent off
" can be longer than the general setting which has to be lower because of xml
setlocal synmaxcol=3000
" exclude from autocompletion in file selection
setlocal wildignore=*.aux,*.dvi,*.log,*.pdf

" compilation
let &makeprg = b:tex_alt_flavour . " -file-line-error -interaction=nonstopmode $*"
" let quickfix know where the errors are in TeX’s output
setlocal errorformat=%f:%l:\ %m


" - tagbar ------------------------------------------------------------------------------


let g:tagbar_autofocus=1		" focus on open tagbar
let g:tagbar_left=1				" show on the left
let g:tagbar_width=20			" the default 40 is too wide
let g:tagbar_type_tex_alt = {
	\ 'ctagstype'	: 'tex_alt',
	\ 'kinds'		: [
		\ 's:sections',
		\ 'l:labels',
		\ 'g:graphics'
	\ ],
	\ 'sort'		: 0,
\ }



" =======================================================================================

" - s:CheckComplKeyword -----------------------------------------------------------------

function! s:CheckComplKeyword ()
	" Note: All new keywords must be added here, not just
	"	to TexAltAutoComplete below.
	if getline('.') =~ '\(include\(graphics\)\=\|input\|ref\)$'
		return "{\<C-x>\<C-u>\<Down>"
	else
		return "{"
	endif
endfunction

" - s:GenerateTags ----------------------------------------------------------------------

function! s:GenerateTags ()
	silent exe ":!ctags " . expand("%:p:h") . "/*.tex &> /dev/null &"
endfunction

" - TexAltAutoComplete ------------------------------------------------------------------

function! TexAltAutoComplete (findstart, base)
	" The function is run twice:
	"	the first time, it finds out what kind of completion is required,
	"	and the second time it does the actual completion.
	" This function will only do any work if it’s run immediately
	"	after the trigger (\ or {) is typed.
	" Note: If ever to be extended, the new keywords must also be added
	"	to s:CheckComplKeyword above.
	if a:findstart		" the first run
		if getline('.') =~ "\\\\$"
			let s:complMode = 'dict'
			return col('.')-1
		elseif getline('.') =~ 'includegraphics{$'
			let s:complMode = "incl-gr"
			return col('.')-1
		elseif getline('.') =~ '\(include\|input\){$'
			let s:complMode = "incl-tex"
			return col('.')-1
		elseif getline('.') =~ 'ref{$'
			let s:complMode = "ref"
			return col('.')-1
		else
			return -3
		endif
	else				" the second run
		if s:complMode == "dict"
			let tmp = split (&dictionary, ",")
			let res = []
			for i in tmp
				let res = res + readfile (i)
			endfor
			return res
		elseif s:complMode == "incl-gr"
			setlocal wildignore-=*.pdf
			let tmp = split (globpath('.','*.eps\|gif\|jpeg\|jpg\|pdf\|png'))
			setlocal wildignore+=*.pdf
			let res = []
			for i in tmp
				call add (res, i[2:-1])
			endfor
			return res
		elseif s:complMode == "incl-tex"
			let tmp = split (globpath('.','*.tex'))
			let res = []
			for i in tmp
				call add (res, i[2:-5])
			endfor
			return res
		elseif s:complMode == "ref"
			let tmp = filter (taglist ("^"), 'v:val["kind"]=="l"')
			let res = []
			for i in tmp
				call add (res, {"word":i["name"], "menu":i["filename"]})
			endfor
			return res
		else
			return []
		endif
	endif
endfunction


" =======================================================================================


let &cpo = s:cpo_save
finish
