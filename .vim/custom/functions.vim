"= Development """===============================================================

" Inserts doxygen comment above the current line.
function! AddDoc()
    let indent = matchstr(getline("."), "^\\s*")
    let saved_cursor_pos = getcurpos()
    if &filetype == "cpp"  || &filetype == "c"
        call append(line(".") - 1, indent . "/** ")
        call append(line(".") - 1, indent . " */")
        let saved_cursor_pos[2] = len(indent) + 5
    else
        call append(line(".") - 1, indent . "# ")
        let saved_cursor_pos[2] = len(indent) + 2
    endif
    call setpos('.', saved_cursor_pos)
endfunction

"= Signs column """=============================================================

" Returns the column of the error.
function! ErrorColumn(default_column)
    let l:ycm_show_detailed_diag_in_popup = g:ycm_show_detailed_diag_in_popup
    let g:ycm_show_detailed_diag_in_popup = 0
    redir => diag
    silent execute "YcmShowDetailedDiagnostic"
    redir END
    let g:ycm_show_detailed_diag_in_popup = l:ycm_show_detailed_diag_in_popup
    let tmp = split(split(split(diag, "\n")[-1])[0], ":")
    if len(tmp) >= 3
        return str2nr(tmp[2])
    endif
    return a:default_column
endfunction

" Moves to the next error/warning sign.
function! GotoNextSign(...)
    redir => signs
    silent execute "sign place group=* buffer=" . bufnr("%")
    redir END
    let cur = line(".")
    let first_one = line("$") + 1

    for sign_line in filter(split(signs, "\n")[2:], "v:val =~# '='")
        let components = split(sign_line)
        let name = split(components[3], "=")[1]
        let line_number = str2nr(split(components[0], '=')[1])
        if index(a:000, name) != -1
            if line_number < first_one
                let first_one = line_number
            endif
            if line_number > cur
                let column = col(".")
                call setpos(".", [0, line_number, 1, 0])
                call setpos(".", [0, line_number, ErrorColumn(column), 0])
                return
            endif
        endif
    endfor
    if first_one < line("$")
        let column = col(".")
        call setpos(".", [0, first_one, 1, 0])
        call setpos(".", [0, first_one, ErrorColumn(column), 0])
        return
    endif
    echom "No signs found: " . string(a:000)
endfunction

let g:toggle_sign_columns_shown = 1

function! PlaceDefaultSign(bufno)
    let bufno = a:bufno? a:bufno : bufnr("%")
    if !getbufvar(l:bufno, "burlog_default_sign", 0)
        execute "sign place 77889911 line=99999 name=SignColumnVisible buffer=" . l:bufno
        call setbufvar(l:bufno, "burlog_default_sign", 1)
    endif
endfunction

function! ToggleSignColumn()
    GitGutterToggle
    let g:ycm_enable_diagnostic_signs = !g:ycm_enable_diagnostic_signs
    if g:ycm_enable_diagnostic_signs
        :YcmForceCompileAndDiagnostics
    endif
    if g:toggle_sign_columns_shown
        :sign unplace * group=*
        pclose
        cclose
        lclose
    endif
    let g:toggle_sign_columns_shown = !g:toggle_sign_columns_shown
    for bufno in range(0, bufnr("$"))
        let burlog_default_sign = getbufvar(bufno, "burlog_default_sign", -1)
        if burlog_default_sign == 1
            call setbufvar(bufno, "burlog_default_sign", 0)
        elseif burlog_default_sign == 0
            call PlaceDefaultSign(bufno)
        endif
    endfor
endfunction

"= GIT """======================================================================

" Opens a new window with the diff of the current repository.
function! OpenGitDiff()
    silent belowright pedit diff
    silent wincmd P
    silent r ! git diff --cached
    silent setlocal syntax=diff
    silent setlocal readonly
    silent setlocal nomodifiable
    silent setlocal buftype=nofile
    silent setlocal bufhidden=hide
    silent setlocal noswapfile
    silent normal gg
    silent wincmd p
    silent resize 20
endfunction

"= VIM debug ""=================================================================

" Prints the syntax group of the token under the cursor.
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" Prints the stack of syntax groups of the token under the cursor.
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


