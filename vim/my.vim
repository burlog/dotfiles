
function! AddDoc()
    let indent = matchstr(getline("."), "^\\s*")
    let save_cursor = getcurpos()
    if &filetype == "cpp"  || &filetype == "c"
        call append(line(".") - 1, indent . "/** ")
        call append(line(".") - 1, indent . " */")
        let save_cursor[2] = len(indent) + 5
    else
        call append(line(".") - 1, indent . "# ")
        let save_cursor[2] = len(indent) + 2
    endif
    call setpos('.', save_cursor)
endfunction

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

function! PlaceDefaultSign(bufno)
    let bufno = a:bufno? a:bufno : bufnr("%")
    if !getbufvar(l:bufno, "burlog_default_sign", 0)
        execute "sign place 77889911 line=99999 name=SignColumnVisible buffer=" . l:bufno
        call setbufvar(l:bufno, "burlog_default_sign", 1)
    endif
endfunction

let g:toggle_sign_columns_shown = 1

function! ToggleSignColumn()
    GitGutterToggle
    let g:ycm_enable_diagnostic_signs = !g:ycm_enable_diagnostic_signs
    if g:toggle_sign_columns_shown
        :sign unplace *
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

autocmd BufEnter * call SetSyntaxForPreview(bufnr("%"))
function! SetSyntaxForPreview(current_bufno)
    for winno in range(0, winnr('$'))
        if getwinvar(winno, "&previewwindow")
            let bufno = winbufnr(winno)
            let current_filetype = getbufvar(a:current_bufno, "&filetype")
            if has_key(g:ycm_filetype_whitelist, current_filetype)
                call setbufvar(bufno, "&syntax", current_filetype)
                return
            endif
        endif
    endfor
endfunction

function! ErrorColumn()
    redir => diag
    silent execute "YcmShowDetailedDiagnostic"
    redir END
    return str2nr(split(split(split(diag, "\n")[0])[0], ":")[-1])
endfunction

function! GotoNextSign(...)
    redir => signs
    silent execute "sign place buffer=" . bufnr("%")
    redir END
    let cur = line(".")
    let first_one = line("$") + 1

    for sign_line in filter(split(signs, "\n")[2:], "v:val =~# '='")
        let components = split(sign_line)
        let name = split(components[2], "=")[1]
        let line_number = str2nr(split(components[0], '=')[1])
        if index(a:000, name) != -1
            if line_number < first_one
                let first_one = line_number
            endif
            if line_number > cur
                call setpos(".", [0, line_number, 1, 0])
                call setpos(".", [0, line_number, ErrorColumn(), 0])
                return
            endif
        endif
    endfor
    if first_one < line("$")
        call setpos(".", [0, first_one, 1, 0])
        call setpos(".", [0, first_one, ErrorColumn(), 0])
        return
    endif
    echom "No signs found: " . string(a:000)
endfunction

" =============================================================== Layout

let g:layout_preview_arranged = 0
let g:layout_quickfix_arranged = 0

autocmd WinEnter * call s:ProtectPreview()
function! s:ProtectPreview()
    if pumvisible()
        return
    endif
    if g:layout_preview_arranged
        if g:layout_quickfix_arranged
            if &previewwindow
                silent wincmd j
            endif
        else
            if &previewwindow
                silent wincmd h
            endif
        endif
    endif
endfunction

function! IsPreviewOpened()
    for nr in range(1, winnr('$'))
        if getwinvar(nr, "&previewwindow") == 1
            return 1
        endif
    endfor
    return 0
endfunction

autocmd BufWinLeave * call s:LeavePreview()
function! s:LeavePreview()
    if &bt == "quickfix"
        let g:layout_quickfix_arranged = 0
        let g:layout_preview_arranged = 0
        if IsPreviewOpened()
            silent wincmd P
            silent let p = winnr()
            silent wincmd p
            silent execute p . "close"
        endif
    endif
endfunction

autocmd User YcmQuickFixOpened call s:SetLayoutByQuickFix()
function! s:SetLayoutByQuickFix()
    " fired when no layout set and YCMComplete GoTo found more than one destinations
    if g:layout_quickfix_arranged
        return
    endif
    let g:layout_quickfix_arranged = 1

    if g:layout_preview_arranged
        let g:layout_preview_arranged = 0
        silent wincmd P
        let p = winnr()
        silent wincmd p
        silent execute p . "close"
    endif
    let g:layout_preview_arranged = 1
    silent wincmd L
    silent setlocal nowinfixheight
    silent setlocal winfixwidth
    silent resize 60
    silent setlocal winfixheight
    silent pedit [] " this one must start with [ char due to ycm s:ClosePreviewWindowIfNeeded
    silent wincmd P
    silent vertical resize 60
    silent setlocal previewwindow
    silent setlocal noreadonly
    silent setlocal nomodifiable
    silent setlocal buftype=nofile
    silent setlocal bufhidden=wipe
    silent setlocal noswapfile
    silent setlocal winfixwidth
    silent wincmd p
endfunction

autocmd WinEnter * call s:SetLayoutByCompletion()
function! s:SetLayoutByCompletion()
    " fired when no layout set and completion requested
    if &previewwindow
        if bufname(bufnr("")) == "diff"
            return
        endif
        if g:layout_preview_arranged
            return
        endif
        let g:layout_preview_arranged = 1
        silent wincmd L
        silent vertical resize 60
        silent setlocal winfixwidth
        silent setlocal winfixheight
    endif
endfunction

function! Make()
    let git_dir = fugitive#extract_git_dir(fnamemodify(bufname("%"), ":p"))
    if git_dir != ""
        let repo = fugitive#repo(git_dir).tree()
        let build = repo . "/" . "build"
        if getfsize(build) == 0
            execute "make! -j 1 -C " . build
            "call s:SetLayoutByMake()
            copen
            return
        endif
    endif
    echom "I can't find the build dir, sorry"
endfunction

