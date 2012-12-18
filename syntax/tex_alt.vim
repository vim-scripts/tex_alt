if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif
scriptencoding utf-8


" = brew ================================================================================


" save some
let s:save_iskeyword=&iskeyword

" has to be the first so that I can override it later
syn	include @R syntax/r.vim
syn	region texaltR start="<%" keepend end="%>" contains=@R

" restore some
let &iskeyword=s:save_iskeyword


" = definitions =========================================================================


" - syntactic ---------------------------------------------------------------------------


" command
syn region texaltCmd start="\\" skip="}{" end="[} \n]"
	\ contains=texaltCmdCont,texaltCmdName,texaltCmdOpts
syn match texaltCmdCont "{\zs.\{-}\ze}"
	\ contained
	\ contains=texaltCmd,texaltEnvName,@texaltSmnFormatC
syn match texaltCmdName "\\\zs.\{-}\ze[\[\]{} \n]"
	\ contained
	\ contains=texaltEnvItem,texaltFormat,texaltPreproc
syn match texaltCmdOpts "\[\zs.\{-}\ze\]"
	\ contained
	\ contains=texaltCmd,@texaltSmnFormatC

" comment
syn region texaltComment start="%" end="\n"
	\ oneline

" environment
syn region texaltEnv matchgroup=texaltCmd start="\\\zsbegin" end="\\\zeend"
	\ contains=texaltEnv
	\ fold
syn keyword texaltEnvName abstract align array center description displaymath document enumerate equation equation* eqnarray figure flushleft flushright itemize list math minipage picture quotation quote subfigure tabbing table tabular theorem titlepage verbatim verse
	\ contained
syn keyword texaltEnvItem item
	\ contained

" formatting
syn keyword texaltFormat bigskip centering frenchspacing hskip labelsep medskip noindent raggedleft raggedright smallskip vskip
	\ contained

" preproc
syn keyword texaltPreproc documentclass include input newcommand newfontfamily renewcommand setcounter setlength setmainfont setmainlanguage setotherlanguages usepackage
	\ contained


" special
syn match texaltSpecial "[&$]"


" - semantic ----------------------------------------------------------------------------


" footnote
syn region texaltSmnFnote matchgroup=texaltCmd start="\\footnote.\{-}{" end="}"
	\ contains=@texaltSmnFormatC

" formatting & reference
syn cluster texaltSmnFormatC contains=texaltSmnBf,texaltSmnBfIt,texaltSmnIt,texaltSmnLng,texaltSmnRef,texaltSmnSc,texaltSmnSkip,texaltSmnSub,texaltSmnSup,texaltSmnTilde
syn region texaltSmnLng matchgroup=texaltSmnFormat start="\\\(text.\{-}\|t..\){" end="}"
	\ contains=@texaltSmnFormatC
	\ transparent	" text.\{-} must be before textbf and textit
syn region texaltSmnBf matchgroup=texaltSmnFormat start="\\\(textbf\|b\){" end="}"
	\ contains=@texaltSmnFormatC
	\ transparent
syn region texaltSmnBfIt matchgroup=texaltSmnFormat start="\\bi{" end="}"
	\ contains=@texaltSmnFormatC
	\ transparent
syn region texaltSmnIt matchgroup=texaltSmnFormat start="\\\(textit\|i\){" end="}"
	\ contains=@texaltSmnFormatC
syn region texaltSmnRef matchgroup=texaltSmnFormat start="\\\(eq\|page\)\=ref{" end="}"
syn region texaltSmnSc matchgroup=texaltSmnFormat start="\\sc{" end="}"
	\ contains=@texaltSmnFormatC
	\ transparent
syn region texaltSmnSub matchgroup=texaltSmnFormat start="\\sub{" end="}"
	\ contains=@texaltSmnFormatC
	\ transparent
syn region texaltSmnSup matchgroup=texaltSmnFormat start="\\sup{" end="}"
	\ contains=@texaltSmnFormatC
	\ transparent

" skips
syn match texaltSmnSkip "\\\(h\|m\|v\)skip [0-9]\+\(\(c\|mm\)\|pt\|in\)\( \(pl\|min\)us [0-9]\+\(fil\|\(c\|mm\)\|pt\|in\)\)*"

" structure
syn region texaltSmnStruct matchgroup=texaltCmd start="\\\(title\|part\|chapter\|\(sub\(sub\)\=\)\=section\|\(sub\)\=paragraph\)\*\={" end="}"
	\ contains=texaltCmd,@texaltSmnFormatC

" tilde and hyphenation
syn match texaltSmnTilde "[^[:space:]]\zs\(\~\|\\-\)\ze[^[:space:]]"


" = highlighting ========================================================================


let b:current_syntax = "tex_alt"

" syntactic
hi def link texaltCmd		Delimiter
hi def link texaltCmdCont	Normal
hi def link texaltCmdName	Function
hi def link texaltCmdOpts	Debug
hi def link texaltComment	Comment
hi def link texaltEnvItem	Statement
hi def link texaltEnvName	Statement
hi def link texaltFormat	Comment
hi def link texaltPreproc	PreProc
hi def link texaltSpecial	Special
" semantic
hi def link texaltSmnFnote	String
hi def link texaltSmnIt		Underlined
hi def link texaltSmnRef	Constant
hi def link texaltSmnFormat	Ignore
hi def link texaltSmnSkip	Ignore
hi def link texaltSmnStruct	Typedef
hi def link texaltSmnTilde	Ignore


" = known bugs ==========================================================================
" tabular could be better
