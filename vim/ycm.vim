let g:ycm_extra_conf_globlist = ["~/git/email/*", "~/git/rus/*", "~/git/github/*", "~/git/tech_dev/*", "~/git/kde/*/", "~/git/generic/resolver/.ycm_extra_conf.py", "~/git/generic/mtd*/.ycm_extra_conf.py", "!~/*"]
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_key_list_select_completion = ["<Down>"]
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_allow_changing_updatetime = 0
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_open_loclist_on_ycm_diags = 0
let g:ycm_open_quickfix_list_on_fix_it = 0
let g:ycm_always_populate_location_list = 0
let g:ycm_error_symbol = ""
let g:ycm_warning_symbol = ""
let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_goto_buffer_command = "split"
let g:ycm_auto_trigger = 1
let g:ycm_key_invoke_completion = "<C-Tab>"
let g:ycm_use_ultisnips_completer = 1
let g:ycm_filetype_whitelist = {"cpp": 1, "c": 1, "python": 1, "javascript": 1}
let g:ycm_global_ycm_extra_conf = "~/.vim/ycm-default-extra_conf.py"
let g:ycm_server_python_interpreter = "/usr/bin/python3"

let g:ycm_filetype_blacklist = {}

let g:ulti_expand_or_jump_res = 0

let s:ycm_filetype_list = join(keys(g:ycm_filetype_whitelist), ",")

sign define SignColumnVisible text=** texthl=Search

execute "autocmd FileType " . s:ycm_filetype_list . " map ]d :YcmCompleter GoTo<CR>"
execute "autocmd FileType " . s:ycm_filetype_list . " autocmd BufEnter * :call PlaceDefaultSign(0)"

function! FallbackComplete(findstart, base)
    let Func = function(&omnifunc != ""? &omnifunc: "")

    if a:findstart
        let start = Func(a:findstart, a:base)
        if start >= 0
            return start
        endif
        return col(".") - 1
    endif

    let results = Func(a:findstart, a:base)
    if type(results) == type({}) && has_key(results, "words")
        if len(results.words)
            return results
        endif
    elseif len(results)
        return results
    endif

    if index(["html", "xml"], &filetype) >= 0
        let context = matchstr(strpart(getline("."), 0, col(".") - 1), "<\/")
        if context != ""
            let opentag = xmlcomplete#GetLastOpenTag("b:unaryTagsStack")
            if opentag =~ "^" . a:base
                return [opentag.">"]
            endif
        endif
    endif

    call feedkeys("\<C-E>\<C-N>", "nt")
    return []
endfunction

autocmd FileType * call RegisterFallbackComplete()
function! RegisterFallbackComplete()
    if !has_key(g:ycm_filetype_whitelist, &filetype)
        if &omnifunc != ""
            let &completefunc = "FallbackComplete"
        endif
    endif
endfunction

function! MyCleverTab()
    let current_line = strpart(getline("."), 0, col(".") - 1)
    if current_line =~ "^\\s*$"
        echom "Tab"
        return "\<Tab>"
    endif
    if has_key(g:ycm_filetype_whitelist, &filetype)
        let g:ycm_pummenu_closed = 0
    endif
    if pumvisible()
        echom "Next"
        return "\<C-N>"
    elseif has_key(g:ycm_filetype_whitelist, &filetype)
        if current_line =~ "\\(\\.\\|->\\|::\\)\\w*$"
            if !s:InsideCommentOrString()
                if current_line !~ "s\.$"
                    echom "YCMAutoInvokeContinue"
                    return "\<C-X>\<C-U>"
                endif
            endif
        endif
        call UltiSnips#ExpandSnippet()
        if g:ulti_expand_res == 1
            let g:ycm_pummenu_closed = 1
            echo "Ultisnips"
            return ""
        endif
        echom "Keyword" . strftime('%c')
        return "\<C-N>\<C-X>\<C-I>"
    elseif &completefunc == "FallbackComplete"
        call UltiSnips#ExpandSnippet()
        if g:ulti_expand_res == 1
            let g:ycm_pummenu_closed = 1
            echo "Ultisnips"
            return ""
        endif
        echom "OmniWithFallback"
        return "\<C-X>\<C-U>"
    endif
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 1
        let g:ycm_pummenu_closed = 1
        echo "Ultisnips"
        return ""
    endif
    echo "FallbackKeyword"
    return "\<C-N>"
endfunction
inoremap <silent><Tab> <C-R>=MyCleverTab()<CR>

function! s:InsideCommentOrString()
  let syntax_group = synIDattr(synIDtrans(synID(line("."), col(".") - 1, 1)), "name")
  if stridx(syntax_group, "Comment") > -1
    return 1
  endif
  if stridx(syntax_group, "String") > -1
    return 2
  endif
  return 0
endfunction

"execute "autocmd FileType " . s:ycm_filetype_list . " autocmd CursorMovedI * call s:CleverInvoke()"
"function! s:CleverInvoke()
"    if !s:InsideCommentOrString()
"        let char = strpart(getline("."), col(".") - 2, 1)
"        if char == "."
"            echom "YCMAutoInvoke"
"            let g:ycm_pummenu_closed = 0
"            call feedkeys("\<C-F3>", "m")
"        else
"            let prev_char = strpart(getline("."), col(".") - 3, 1)
"            if prev_char == "-" && char == ">"
"                echom "YCMAutoInvoke"
"                let g:ycm_pummenu_closed = 0
"                call feedkeys("\<C-F3>", "m")
"            elseif prev_char == ":" && char == ":"
"                echom "YCMAutoInvoke"
"                let g:ycm_pummenu_closed = 0
"                call feedkeys("\<C-F3>", "m")
"            endif
"        endif
"    endif
"endfunction
"
execute "autocmd FileType " . s:ycm_filetype_list . " autocmd CompleteDone * call s:CleverInvokeDone()"
function! s:CleverInvokeDone()
    let g:ycm_pummenu_closed = 1
endfunction

