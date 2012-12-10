if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif
scriptencoding utf-8


" =======================================================================================


" brew
" has to be the first so that I can override it later
syn	include @R syntax/r.vim
syn	region texaltR start="<%" keepend end="%>" contains=@R


" =======================================================================================


" comments
syn region	texaltComment start="%" end="\n" contains=texaltTodo oneline

" document structure
syn region	texaltDocStruct matchgroup=texaltDocStructMG start="\\\(title\|abstract\|part\|chapter\|\(sub\)\{,2}section\|\(sub\)\=paragraph\)\*\={" end="}" fold contains=texaltFormat,texaltIndex,texaltItalics,texaltLabel,texaltPhantom,texaltR,texaltRef,texaltShortsHyph,texaltTipa,texaltTodo,texaltTransp

" footnotes and captions
syn region	texaltCapt matchgroup=texaltFnoteMG start="\\caption\=.\=\(\[.\{-}\]\)\={" end="}" transparent contains=texaltComment,texaltFormat,texaltFormatEnv,texaltIndex,texaltItalics,texaltLabel,texaltPhantom,texaltR,texaltRef,texaltShortsHyph,texaltTipa,texaltTodo,texaltTransp
syn region	texaltFnote matchgroup=texaltFnoteMG start="\\footnote\(mark\|text\)\=.\=\(\[.\{-}\]\)\={" end="}" transparent fold contains=texaltComment,texaltFormat,texaltFormatEnv,texaltIndex,texaltItalics,texaltLabel,texaltPhantom,texaltR,texaltRef,texaltShortsHyph,texaltTipa,texaltTodo,texaltTransp
syn match	texaltFnoteMG "\\footnotemark.\="

" formatting (my shortcuts, environs; \sup)
syn region	texaltFormat matchgroup=texaltFormatMG start="\\\(b\|bi\|emph\|sc\|sout\|sub\|sup\|t..\|text..\)\(\[.\{-}\]\)\={" end="}" transparent contains=texaltComment,texaltFormat,texaltIndex,texaltItalics,texaltPhantom,texaltR,texaltRef,@texaltShorts,texaltTipa,texaltTodo concealends
syn region	texaltFormatEnv matchgroup=texaltFormatMG start="\\\(begin\|end\){" end="}" contains=texaltFormatTab concealends
syn match	texaltFormatEnv "&\|\\>\|\\=\|\\\\"
syn match	texaltFormatHyph "\\-"
syn region	texaltFormatItem matchgroup=texaltFormatEnv start="\\item\[\=" end="\]\= " transparent
syn match	texaltFormatNoInd "\\noindent"
syn match	texaltFormatMG "\\kern.\{-}\(cm\|em\|en\|ex\|mm\|pt\)" conceal
syn match	texaltFormatSkip "\\\(small\|med\|big\)skip"
syn match	texaltFormatTab "{\( \|c\|l\|r\|p{.\{-}}\)*}" conceal
syn region	texaltItalics matchgroup=texaltFormatMG start="\\\(i\|textit\){" end="}" contains=texaltComment,texaltFormat,texaltIndex,texaltPhantom,texaltR,@texaltShorts,texaltTipa,texaltTodo concealends
syn region	texaltPhantom matchgroup=texaltFormatMG start="\\phantom{" end="}" contains=texaltFormat,texaltIndex,texaltItalics,texaltR,texaltRef,@texaltShorts,texaltTipa concealends
syn region	texaltTipa matchgroup=texaltFormatMG start="\\\(lowa\|uppa\)\(\[.\{-}\]\)\={.\{-}}{" end="}" contains=texaltPhantom transparent concealends

" indices
syn region	texaltIndex matchgroup=texaltFormatMG start="\\index{.\{-}}" end="}" contains=texaltPhantom transparent concealends

" macros
syn region	texaltMacro matchgroup=texaltMacroMG start="\\\(addtocounter\|documentclass\|include\|new\(command\|counter\|fontfamily\)\|renewcommand\|set\(counter\|length\)\|setmain\(font\|language\)\|setotherlanguages\|usepackage\)\(\[\|{\)" skip="}\[\|}{" end="}" transparent contains=texaltMacroHlp
syn match	texaltMacroHlp "\]{\|}\[\|}{" contained

" math mode
syn region	texaltMaths matchgroup=texaltMathsMG start="\$" end="\$" transparent

" references
syn match	texaltLabel "\\label{.\{-}}" conceal
syn region	texaltRef matchgroup=texaltRefMG start="\\\(page\)\=ref{" end="}" concealends

" todo
syn match	texaltTodo "\\\(#\|@\|\$\)"


" =======================================================================================


" highlighting
let b:current_syntax = "tex_alt"
hi! def link texaltComment			Comment
hi! def link texaltDocStruct		Statement
hi! def link texaltDocStructMG		Type
hi! def link texaltFnoteMG			Statement
hi! def link texaltFormatEnv		Special
hi! def link texaltFormatEnvCont	Special
hi! def link texaltFormatHyph		SpecialComment
hi! def link texaltFormatItem		Special
hi! def link texaltFormatMG			SpecialComment
hi! def link texaltFormatNoInd		SpecialComment
hi! def link texaltFormatSkip		SpecialComment
hi! def link texaltFormatTab		SpecialComment
hi! def link texaltItalics			Underlined
hi! def link texaltLabel			SpecialComment
hi! def link texaltMacroHlp			PreProc
hi! def link texaltMacroMG			PreProc
hi! def link texaltMaths			Special
hi! def link texaltMathsMG			Special
hi! def link texaltPhantom			SpecialComment
hi! def link texaltRef				Constant
hi! def link texaltShorts			Constant
hi! def link texaltTodo				Todo
