syn region pythonDocstring start=+^\s*[uU]\?[rR]\?"""+ end=+"""+
    \ fold
    \ keepend excludenl
    \ contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
syn region pythonDocstring start=+^\s*[uU]\?[rR]\?'''+ end=+'''+
    \ fold
    \ keepend excludenl
    \ contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError

hi link pythonDocstring Comment

setlocal foldmethod=syntax
setlocal foldtext=PythonDocstringFoldText()
