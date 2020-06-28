" Reformat include lines.
syn clear pythonInclude
syn keyword pythonIncludeStatement as from import contained
syn match pythonIncludeModule
    \ +\.*\(\h\w*\(\.\h\w*\)*\)\=+ contained
syn match pythonIncludeLine /^\s*\(import\|from\)\>.*$/
    \ contains=pythonIncludeStatement,pythonIncludeModule
hi link pythonIncludeStatement Operator
hi link pythonIncludeModule Namespace

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
    \ start=+\([rR]\|[rR][fF]\|[fF][rR]\)\z(['"]\)+ end=+\z1+
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
    \ start=+\([bB][rR]\|[rR][bB]\)\z(['"]\)+ end=+\z1+ keepend
    \ contains=@Spell oneline display
syn region pythonByteString
    \ start=+\([bB][rR]\|[rR][bB]\)\z('''\|"""\)+ end=+\z1+ keepend
    \ contains=pythonSpaceError,@Spell
hi link pythonStringEscape pythonEscape
hi link pythonEscape Special
hi link pythonString String
hi link pythonByteString String

" Match a python docstring as as a foldable comment region.
syn region pythonDocstring start=+^\s*[uU]\?[rR]\?[fF]\?"""+ end=+"""+
    \ fold
    \ keepend excludenl
    \ contains=pythonEscape,@Spell,pythonSpaceError
syn region pythonDocstring start=+^\s*[uU]\?[rR]\?[fF]\?'''+ end=+'''+
    \ fold
    \ keepend excludenl
    \ contains=pythonEscape,@Spell,pythonSpaceError
hi! link Folded Comment
hi link pythonDocstring Comment

" Make the pseudo-builtin idenfitier 'self' highlight as comment - it's so
" frequently used and rather unimportant.
syn keyword pythonSelf cls self
hi link pythonSelf Comment

" Match words before '.' as being a namespace construct, so highlight them as
" such.
syn match pythonClass /\h\w*\./me=e-1 containedin=pythonDecoratorName
hi link pythonClass Namespace
" Make things which lexically look like a function call get coloured in the
" correct colours.
syn match pythonFunction /\h\w*(/me=e-1

" Delete python 2-specific keywords from the pythonStatement group
syn clear pythonStatement
syn keyword pythonStatement as assert break continue del global
syn keyword pythonStatement lambda nonlocal pass return with
syn keyword pythonStatement yield nextgroup=pythonYieldFrom skipwhite
syn keyword pythonStatement class def nextgroup=pythonFunction skipwhite
syn keyword pythonYieldFrom from contained
hi link pythonYieldFrom pythonStatement

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
hi link pythonOperator Operator
hi link pythonDecorator Operator
hi link pythonComparison Operator

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
