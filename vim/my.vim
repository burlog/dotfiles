
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

autocmd FileType qf call s:FixQFWin()
function s:FixQFWin()
    silent setlocal nowinfixheight
    silent resize 35
    silent setlocal winfixheight
endfunction

autocmd BufAdd * call s:OpenPreviewOnRight()
function s:OpenPreviewOnRight()
    if &previewwindow && !get(w:, "fix_preview_pos_done", 0)
        silent wincmd L
        silent vertical resize 60
        silent setlocal winfixwidth
        silent setlocal nowinfixheight
        let w:fix_preview_pos_done = 1
    endif
endfunction

function! OpenPreview()
    silent pedit [] " this one must start with [ char due to ycm s:ClosePreviewWindowIfNeeded
    silent wincmd P
    silent setlocal previewwindow
    silent setlocal noreadonly
    silent setlocal nomodifiable
    silent setlocal buftype=nofile
    silent setlocal bufhidden=wipe
    silent setlocal noswapfile
    silent setlocal winfixwidth
    silent wincmd p
endfunction

autocmd BufEnter * call SetSyntaxForPreview(bufnr("%"))
function SetSyntaxForPreview(current_bufno)
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
                return
            endif
        endif
    endfor
    if first_one < line("$")
        call setpos(".", [0, first_one, 1, 0])
        return
    endif
    echom "No signs found: " . string(a:000)
endfunction

function! Make()
    let git_dir = fugitive#extract_git_dir(fnamemodify(bufname("%"), ":p"))
    if git_dir != ""
        let repo = fugitive#repo(git_dir).tree()
        let build = repo . "/" . "build"
        if getfsize(build) == 0
            execute "make! -j 4 -C " . build
            call OpenPreview()
            copen
            return
        endif
    endif
    echom "I can't find the build dir, sorry"
endfunction

