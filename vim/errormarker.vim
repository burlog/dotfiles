let g:errormarker_disablemappings = 1
let g:errormarker_errortextgroup = "CompileError"
let g:errormarker_warningtextgroup = "CompileWarning"
let g:errormarker_errorgroup = "CompileErrorLine"
let g:errormarker_warninggroup = "CompileWarningLine"
let g:errormarker_errortext = "⭿⮀"
let g:errormarker_warningtext = "⭿⮀"

autocmd FileType c,cpp let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat
autocmd FileType c,cpp autocmd CursorMoved,CursorMovedI * ErrorAtCursor
