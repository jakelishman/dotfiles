" Reformat include lines.
syn clear pythonInclude
syn keyword pythonIncludeStatement as from import contained
syn match pythonIncludeLine /^\(import\|from\).*$/
    \ contains=pythonIncludeStatement
hi link pythonIncludeLine Namespace
hi link pythonIncludeStatement PreProc

" Match a python docstring as as a foldable comment region.
syn region pythonDocstring start=+^\s*[uU]\?[rR]\?"""+ end=+"""+
    \ fold
    \ keepend excludenl
    \ contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
syn region pythonDocstring start=+^\s*[uU]\?[rR]\?'''+ end=+'''+
    \ fold
    \ keepend excludenl
    \ contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
hi! link Folded Comment
hi link pythonDocstring Comment

" Make the pseudo-builtin idenfitier 'self' highlight as comment - it's so
" frequently used and rather unimportant.
syn keyword pythonSelf cls self
hi link pythonSelf Comment

" Match words before '.' as being a namespace construct, so highlight them as
" such.
syn match pythonClass /\h\+\./me=e-1
hi link pythonClass Namespace
" Make things which lexically look like a function call get coloured in the
" correct colours.
syn match pythonFunction /\h\+(/me=e-1

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
