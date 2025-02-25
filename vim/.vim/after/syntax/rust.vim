" Add automatic folding to Rust documentation comments.  Modified from
" https://github.com/rust-lang/rust.vim/issues/40#issuecomment-286655046
setlocal foldmethod=expr
setlocal foldexpr=s:GetRustFold()
setlocal foldtext=s:RustFoldText()

function! s:IndentLevel()
    return indent(v:lnum) / (&shiftwidth ?? &tabstop)
endfunction

function! s:GetRustFold()
    let this_indent = s:IndentLevel()
    if getline(v:lnum) =~? '\v^\s*(//[/!]|#\[doc)'
        return this_indent + 1
    endif
    return 0
endfunction

function! s:RustFoldText()
    let prefix = matchstr(getline(v:foldstart), "\\v^\\s*//[/!]")
    return prefix . ' [folded documentation] (' . (v:foldend - v:foldstart + 1) . ')'
endfunction
