if exists("b:did_ftplugin_jake")
    finish
endif
let b:did_ftplugin_jake = 1

function RustFilterQuickFix()
    let out = []
    let keep = 1
    for entry in getqflist()
        if entry.type ==? "E" || entry.type ==? "W"
            let keep = 1
        elseif entry.type ==? "I" || entry.type ==? "N"
            let keep = 0
        endif
        if keep
            call add(out, entry)
        endif
    endfor
    call setqflist(out, "r")
endfunction

augroup RustCargoQuickFixHooks
    autocmd QuickfixCmdPost make call RustFilterQuickFix()
augroup END
