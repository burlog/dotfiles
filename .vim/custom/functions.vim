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

if filereadable(expand("~/.openai.env"))
  for line in readfile(expand("~/.openai.env"))
    if line =~# '^\s*$' | continue | endif   " skip empty lines
    if line =~# '^\s*#' | continue | endif   " skip comments

    let parts = split(line, '=')
    if len(parts) == 2
      execute 'let $'.parts[0].' = "'.parts[1].'"'
    endif
  endfor
endif

" Minimal plugin to generate a commit message from staged diff using Copilot LLM.
function! s:GetDiffText()
    for b in range(1, bufnr('$'))
        if bufname(b) ==# 'diff'
            return join(getbufline(b, 1, '$'), "\n")
        endif
    endfor
    return ""
endfunction

function! GenCommitMsg()
    let l:diff = s:GetDiffText()

    if empty(l:diff)
        echo "No diff buffer named 'diff' found."
        return
    endif

    if empty($OPENAI_API_KEY)
        echohl ErrorMsg | echom "OPENAI_API_KEY is not set" | echohl None
        return
    endif

    let l:prompt =
        \ "Generate a concise git commit message in ENGLISH."
        \ . " Respond with only the commit message, no explanations."
        \ . " Focus on what changed and why."
        \ . " Use conventional commit style"
        \ . " (feat:, fix:, docs:, style:, build:, ci:, refactor:, perf:, test:, chore:)."
        \ . " Keep lines under 72 characters."
        \ . " Never ever include diff in answer."
        \ . " Never ever quote the message."
        \ . " The diff is below:\n\n"
        \ . l:diff

    " Build JSON request safely
    let l:req = {
                \ 'model': 'sellma-small',
                \ 'messages': [
                \   {'role': 'user', 'content': l:prompt}
                \ ]
                \ }

    " Write JSON to a temp file (avoids shell quoting issues)
    let l:tmp = tempname()
    call writefile([json_encode(l:req)], l:tmp)

    " Curl command reading JSON from file
    let l:cmd = [
                \ 'curl', '-sS',
                \ '-H', '"X-Private 1"',
                \ '-H', '"Content-Type: application/json"',
                \ '-H', '"Authorization: Bearer ' . $OPENAI_API_KEY . '"',
                \ '--data-binary', '@' . l:tmp,
                \ 'https://llm-proxy.seznam.net:443/v1/chat/completions'
                \ ]

    let l:raw = system(join(l:cmd, ' '))

    " Validate JSON
    try
        let l:res = json_decode(l:raw)
    catch
        echohl ErrorMsg | echom "OpenAI JSON decode error" | echohl None
        echom l:raw
        return
    endtry

    if type(l:res) != type({})
        echohl ErrorMsg | echom "OpenAI API error: " . string(l:res) | echohl None
        return
    endif

    if !has_key(l:res, 'choices')
        echohl ErrorMsg | echom "OpenAI API error: " . string(l:res) | echohl None
        return
    endif

    let l:text = l:res.choices[0].message.content

    return l:text . "\n\n\n"
endfunction

function! GenCommitMsgToFile()
    " Get the diff text
    let l:diff = s:GetDiffText()
    if empty(l:diff)
        echo "No diff buffer named 'diff' found."
        return
    endif

    let l:commit_msg = GenCommitMsg()

    " Open COMMIT_EDITMSG buffer
    let l:filename = expand(".git/COMMIT_EDITMSG")
    if empty(l:filename)
        echohl ErrorMsg | echom "Cannot find COMMIT_EDITMSG file" | echohl None
        return
    endif

    " Open the commit message buffer
    execute 'edit ' . fnameescape(l:filename)

    " Insert generated message
    call setline(1, split(l:commit_msg, "\n"))

    " Move cursor to top
    normal! gg
endfunction

command! GenCommitMsg call GenCommitMsg()
command! GenCommitMsgToFile call GenCommitMsgToFile()

let g:gitdiff_opened = 0

" Opens a new window with the diff of the current repository.
function! OpenGitDiff()
    if g:gitdiff_opened
        return
    endif
    let g:gitdiff_opened = 1
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
    call GenCommitMsgToFile()
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


