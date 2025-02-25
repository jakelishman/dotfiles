" Reformat include lines.
syn clear pythonInclude
syn keyword pythonInclude import nextgroup=pythonIncludeModule,pythonIncludeModuleDot skipnl skipwhite
syn keyword pythonInclude from nextgroup=pythonIncludeModule,pythonIncludeModuleDot skipnl skipwhite
syn keyword pythonIncludeContinuation import contained
syn keyword pythonIncludeAs as
syn match pythonIncludeModule /\h\w*/
    \ nextgroup=pythonIncludeModuleDot,pythonIncludeContinuation
    \ skipwhite contained
syn match pythonIncludeModuleDot /\.\+/
    \ nextgroup=pythonIncludeModule,pythonIncludeContinuation
    \ skipwhite contained
hi! def link pythonInclude Operator
hi! def link pythonIncludeAs Operator
hi! def link pythonIncludeContinuation Operator
hi! def link pythonIncludeModule Namespace

syn match pythonNumber #\v<(([0-9][0-9_]*)?\.)?[0-9][0-9_]*([eE][+-][0-9][0-9_]*)?#

" Make string highlighting accurate for how Python 3 is interpreted.
syn clear pythonEscape pythonString pythonRawString
syn match pythonEscape +\\$+
syn match pythonEscape +\\[\x00-\x7f]+ contained
syn match pythonEscape +\\x\x\{2}+ contained
syn match pythonEscape +\\\o\{2,3}+ contained
syn match pythonStringEscape +\\N{.\+}+ contained
syn match pythonStringEscape +\\u\x\{4}+ contained
syn match pythonStringEscape +\\U\x\{8}+ contained
syn region pythonString
    \ start=+[fFuU]\=\z(['"]\)+ end=+\z1+ keepend skip=+\\\\\|\\\z1+
    \ contains=pythonEscape,pythonStringEscape,@Spell
syn region pythonString
    \ start=+[fFuU]\=\z('''\|"""\)+ end=+\z1+ keepend skip=+\\\\\|\\\z1+
    \ contains=pythonEscape,pythonStringEscape,pythonSpaceError,@Spell
syn region pythonString
    \ start=+\([rR]\|[rR][fF]\|[fF][rR]\)\z(['"]\)+ skip=+\\\\\|\\\z1+ end=+\z1+
    \ contains=@Spell oneline display
syn region pythonString
    \ start=+\([rR]\|[rR][fF]\|[fF][rR]\)\z('''\|"""\)+ end=+\z1+
    \ contains=pythonSpaceError,@Spell
syn region pythonByteString
    \ start=+[bB]\z(['"]\)+ end=+\z1+ keepend skip=+\\\\\|\\\z1+
    \ contains=pythonEscape,@Spell
syn region pythonByteString
    \ start=+[bB]\z('''\|"""\)+ end=+\z1+ keepend skip=+\\\\\|\\\z1+
    \ contains=pythonEscape,pythonSpaceError,@Spell
syn region pythonByteString
    \ start=+\([bB][rR]\|[rR][bB]\)\z(['"]\)+ keepend skip=+\\\\\|\\\z1+ end=+\z1+
    \ contains=@Spell oneline display
syn region pythonByteString
    \ start=+\([bB][rR]\|[rR][bB]\)\z('''\|"""\)+ end=+\z1+ keepend
    \ contains=pythonSpaceError,@Spell
hi! def link pythonStringEscape pythonEscape
hi! def link pythonEscape Special
hi! def link pythonString String
hi! def link pythonByteString String

" Match a python docstring as as a foldable comment region.
" The funny capitalisation is so that the built-in Python indenter will
" recognise it as a 'string' type for the purposes of ignoring indentation.
syn region pythonDocString start=+^\s*[uU]\?[fF]\?"""+ end=+"""+
    \ fold
    \ keepend excludenl
    \ contains=pythonEscape,@Spell,pythonSpaceError
syn region pythonDocString start=+^\s*[uU]\?[fF]\?'''+ end=+'''+
    \ fold
    \ keepend excludenl
    \ contains=pythonEscape,@Spell,pythonSpaceError
syn region pythonDocString start=+^\s*[rR][uU]\?[fF]\?"""+ end=+"""+
    \ fold
    \ keepend excludenl
    \ contains=@Spell,pythonSpaceError
syn region pythonDocString start=+^\s*[rR][uU]\?[fF]\?'''+ end=+'''+
    \ fold
    \ keepend excludenl
    \ contains=@Spell,pythonSpaceError
hi! link Folded Comment
hi! def link pythonDocString Comment

" Make the pseudo-builtin idenfitier 'self' highlight as comment - it's so
" frequently used and rather unimportant.
syn keyword pythonSelf cls self
hi! def link pythonSelf Comment

" Match words before '.' as being a namespace construct, so highlight them as
" such.
syn match pythonClass /\h\w*\./me=e-1 containedin=pythonDecoratorName
hi! def link pythonClass Namespace
" Make things which lexically look like a function call get coloured in the
" correct colours.  For some reason this rule can match too eagerly within
" nested contexts (like in Markdown or rST files), unless we don't allow it in
" 'nextgroup' rules.
syn match pythonFunctionInferred /\h\w*(/me=e-1

" Delete python 2-specific keywords from the pythonStatement group
syn clear pythonStatement
syn keyword pythonStatement as assert break continue del global
syn keyword pythonStatement lambda nonlocal pass return with
syn keyword pythonStatement yield nextgroup=pythonYieldFrom skipwhite
syn keyword pythonStatement def nextgroup=pythonFunction skipwhite
syn keyword pythonStatement class nextgroup=pythonClass skipwhite
syn keyword pythonYieldFrom from contained
hi! def link pythonYieldFrom pythonStatement

" Overwrite the highlighting of 'None', 'True' and 'False' to be literals rather
" than the default 'Statement'.
syn keyword Constant None
syn keyword Boolean True False

" Messy exception matching.
syn match pythonExceptions #\v<\h\w*(Error|Exception)># display
    \ containedin=pythonIncludeLine

syn match pythonComparison /\v([=<>]\=?|!\=)/

syn match pythonOperator
    \ #\v[^\+\*\-/\%]([\+\*\-/\%]|\*\*|//)[^\+\*\-/\%]#me=e-1,ms=s+1
hi! def link pythonOperator Operator
hi! def link pythonDecorator Operator
hi! def link pythonComparison Operator
hi! def link pythonFunctionInferred pythonFunction

" Define the folding function for the docstrings.
if !exists('*PythonDocstringFoldText')
    function PythonDocstringFoldText()
        let spaces = matchstr(getline(v:foldstart), "^\\s*")
        return spaces.'"""docstring""" (' . (v:foldend - v:foldstart + 1).')'
    endfunction
endif

" Turn on docstring syntax folding.
setlocal foldmethod=syntax
setlocal foldtext=PythonDocstringFoldText()
