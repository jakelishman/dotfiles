syn clear shFunctionOne shFunctionTwo shFunctionThree shFunctionFour
syn clear shFunctionKey shFunction

syn keyword shFunctionKey function
    \ skipwhite skipnl nextgroup=shFunction
syn match shFunction /[a-zA-Z_0-9:][-a-zA-Z_0-9:]*/ contained keepend
syn match shFunction /[a-zA-Z_0-9:][-a-zA-Z_0-9:]*\s*()/me=e-2

hi link shFunction Function
hi link shFunctionKey Keyword
