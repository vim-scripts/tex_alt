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


" - autocommands ------------------------------------------------------------------------


" update tags on file open and save
if b:tex_alt_auto_tags
	autocmd! BufRead,BufWrite *.tex call <SID>GenerateTags()
endif


" - maps --------------------------------------------------------------------------------


" compile and open the quickfix window
nnoremap <F9> :w<CR>:silent make % \| redraw! \| cw<CR>
nnoremap <F12> :TagbarToggle<CR>
nnoremap <silent> <Leader>w :set wrap!<CR>

" reasonable moving thrgough wrapped lines
noremap <Up> gk
noremap <Down> gj
noremap <expr> <Home> &wrap ? "g\<Home>" : "^"
noremap <expr> <End> &wrap ? "g\<End>" : "$"
inoremap <expr> <Up> pumvisible() ? "\<Up>" : "\<C-o>gk"
inoremap <expr> <Down> pumvisible() ? "\<Down>" : "\<C-o>gj"
inoremap <expr> <Home> &wrap ? "\<C-o>g\<Home>" : "\<C-o>^"
inoremap <expr> <End> &wrap ? "\<C-o>g\<End>" : "\<C-o>$"


" - completion --------------------------------------------------------------------------


" custom completion (see below)
setlocal completefunc=TexAltAutoComplete
" let the user keep typing after the menu pops up,
"	and open the menu even if there is nothing to match against yet
setlocal completeopt=longest,menuone
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
inoremap <buffer> \ \<C-x><C-u>
inoremap <buffer> { {<C-x><C-u>
" alternative key shortcut for completion
exe 'ino <buffer> <expr> <Tab> pumvisible() ? "\<C-y>" : "' . maparg("<Tab>", "i") . '"'


" - options -----------------------------------------------------------------------------


filetype indent off
" can be longer than the general setting which has to be lower because of xml
setlocal synmaxcol=3000
" exclude from autocompletion in file selection
setlocal wildignore=*.aux,*.dvi,*.log,*.pdf
" this is probably more often needed
setlocal wrap

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

" - TexAltAutoComplete ------------------------------------------------------------------

function! TexAltAutoComplete (findstart, base)
	" The function is run twice:
	"	the first time, it finds out what kind of completion is required,
	"	and the second time it does the actual completion.
	" This function will only work properly if it’s run immediately
	"	after the trigger is typed (\ or {).
	if a:findstart		" the first run
		let line = getline('.')[0:col('.')-2]
		if line =~ "\\\\$"
			let s:complMode = 'dict'
			return col('.')-1
		elseif line =~ 'includegraphics{$'
			let s:complMode = "incl-gr"
			return col('.')-1
		elseif line =~ '\(include\|input\){$'
			let s:complMode = "incl-tex"
			return col('.')-1
		elseif line =~ 'ref{$'
			let s:complMode = "ref"
			return col('.')-1
		else
			return -3
		endif
	else				" the second run
		let res = []
		if s:complMode == "dict"
			let tmp = split (&dictionary, ",")
			for i in tmp
				let res = res + readfile (i)
			endfor
		elseif s:complMode == "incl-gr"
			setlocal wildignore-=*.pdf
			let tmp = split (globpath('.','*.eps\|gif\|jpeg\|jpg\|pdf\|png'))
			setlocal wildignore+=*.pdf
			for i in tmp
				call add (res, i[2:-1])
			endfor
		elseif s:complMode == "incl-tex"
			let tmp = split (globpath('.','*.tex'))
			for i in tmp
				call add (res, i[2:-5])
			endfor
		elseif s:complMode == "ref"
			let tmp = filter (taglist ("^"), 'v:val["kind"]=="l"')
			for i in tmp
				call add (res, {"word":i["name"], "menu":i["filename"]})
			endfor
		endif
		if res != []
			call feedkeys ("\<Down>", "n")
		endif
		return res
	endif
endfunction

" - s:GenerateTags ----------------------------------------------------------------------

function! s:GenerateTags ()
	let tmp = expand ("%:p:h")
	silent exe ":!rm -rf ".tmp."/tags; ctags -R ".tmp."/*.tex &> /dev/null &"
endfunction


" =======================================================================================


let &cpo = s:cpo_save
finish
