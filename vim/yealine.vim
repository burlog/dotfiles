let g:yealine_colors = {
\    "Base":            [0, 242],
\    "BaseCurrent":     [0, 250],
\    "Buffer":          [243, 236],
\    "Readonly":        [0, 160],
\    "Modified":        [0, 220],
\    "Paste":           [0, 220],
\    "Syntax":          [[248, 238], [249, 18]],
\    "Position":        [[248, 238], [249, 18]],
\    "ModeNormal":      [0, 39],
\    "ModeInsert":      [0, 34],
\    "ModeReplace":     [0, 202],
\    "ModeVisual":      [0, 220],
\    "ModeCommand":     [0, 39],
\    "ModeSelect":      [0, 220],
\    "TabBase":         [0, 240],
\    "TabClose":        [246, 236],
\    "TabEntryCurrent": [0, 22],
\    "TabEntry":        [[245, 236], [245, 238]],
\}

let g:yealine_left_boxes =  [
\    "yealine#boxes#Buffer",
\    "yealine#boxes#Syntax",
\    "YealineFilename",
\]
"\    "YeaLineSyntaxCheck",
let g:yealine_right_boxes = [
\    "yealine#boxes#Paste",
\    "yealine#boxes#Readonly",
\    "YeaLineCommitted",
\    "yealine#boxes#Modified",
\    "yealine#boxes#Position",
\    "yealine#boxes#CurrentChar"
\]
let g:yealine_separator_inverse = 1
let g:yealine_separators = ["\ue0b0", "\ue0b2"]
let g:yealine_middle_color_function = "YealineMiddleColor"

let g:yealine_tab_separator_inverse = 1
let g:yealine_tab_separators = g:yealine_separators
let g:yealine_tab_left_boxes =  ["yealine#boxes#TabEntry"]
let g:yealine_tab_right_boxes = ["yealine#boxes#TabClose"]

let s:repo_cache = {}
autocmd BufWritePost,BufNew * let s:committed = 0

function! s:make_buffer_list()
    let res = []
    for bufno in range(0, bufnr('$'))
        let name = bufname(bufno)
        if name != "" && buflisted(bufno) && (getbufvar(bufno, "&buftype") == "")
            call add(res, [bufno, name, fnamemodify(name, ":p")])
        endif
    endfor
    return res
endfunction

function! s:get_repo(path)
    for [tree, repo] in items(s:repo_cache)
        if a:path =~ "^" . tree
            return repo
        endif
    endfor
    let git_dir = fugitive#extract_git_dir(a:path)
    if git_dir != ""
        let repo = fugitive#repo(git_dir)
        let tree = repo.tree()
        let branch = systemlist(repo.git_command("-C", tree, "rev-parse", "--abbrev-ref", "HEAD"))[0]
        let s:repo_cache[tree] = [repo, tree, branch]
        return s:repo_cache[tree]
    endif
    return [{}, "", ""]
endfunction

function! s:make_committed_cache()
    let files = {}
    for [bufno, buftitle, filename] in s:make_buffer_list()
        let [repo, tree, branch] = s:get_repo(filename)
        if len(repo)
            if !has_key(files, tree)
                let files[tree] = [repo, branch, []]
            endif
            call add(files[tree][2], filename)
        endif
    endfor
    let s:committed_cache = {}
    for [tree, entry] in items(files)
        let [repo, branch, filenames] = entry
        let filenames = filter(filenames, "getfsize(v:val) >= 0")
        let prefix = branch == "master"? "" : branch . " "
        for line in systemlist(repo.git_command("-C", tree, "status", "--porcelain", "--") . " " . join(filenames, " "))
            let [status, file_spec] = [line[0:2], line[3:len(line)]]
            let [filename_index, filename] = (file_spec =~ " -> ")? split(file_spec, " -> "): ["", file_spec]
            let s:committed_cache[tree . "/" . filename] = [prefix, status[1]]
        endfor
        for filename in filenames
            if !has_key(s:committed_cache, filename)
                if filereadable(filename)
                    let s:committed_cache[filename] = [prefix, " "]
                else
                    let s:committed_cache[filename] = [prefix, "?"]
                endif
            endif
        endfor
    endfor
endfunction

function! YeaLineCommitted(active, bufno)
    let now = strftime("%s")
    if getbufvar(a:bufno, "&buftype") == ""
        if get(s:, "committed", 0) < (now - 30000000)
            let s:committed = now
            call s:make_committed_cache()
        endif
        let filename = yealine#boxes#GetBufferFilename(a:bufno)
        if filename != "" && has_key(s:committed_cache, filename)
            let [prefix, status] = s:committed_cache[filename]
            if status == "?"
                if getbufvar(a:bufno, "&modified")
                    return [yealine#BaseColor(a:active), ""]
                endif
                return [[0,  52], prefix . "✶"]
            elseif status == " "
                return [[0,  22], prefix . "✔"]
            elseif status[0] == "M"
                if getbufvar(a:bufno, "&modified")
                    return [yealine#BaseColor(a:active), ""]
                endif
                return [[0,  136], prefix . "+"]
            elseif status[0] == "D"
                return [[0, 52], prefix . "✘"]
            endif
        endif
    endif
    return [yealine#BaseColor(a:active), ""]
endfunction

function! YeaLineSyntaxCheckFormat(entries)
    if !len(a:entries)
        return [yealine#BaseColor(a:active), ""]
    endif

    let entry = a:entries[0]
    let location = entry.location
    let text = len(entry.text) > 20? entry.text[:19] . "…" : entry.text
    let res = location.line_num . ":" . location.column_num . ": " . text
    let cnt = len(a:entries)
    if cnt > 1
        let res = res . " (" . cnt . ")"
    endif
    return res
endfunction

function! YeaLineSyntaxCheck(active, bufno)
    if exists(":YcmRestartServer")
        let filetype = getbufvar(a:bufno, "&filetype")
        if exists("g:ycm_filetype_whitelist")
            let whitelist_allows = has_key(g:ycm_filetype_whitelist, "*") || has_key(g:ycm_filetype_whitelist, &filetype)
            let blacklist_allows = !has_key(get(g:, "ycm_filetype_blacklist", {}), &filetype)
            if whitelist_allows && blacklist_allows
                let errors = youcompleteme#GetErrorsForBuffer(a:bufno)
                if !len(errors)
                    let warnings = youcompleteme#GetWarningsForBuffer(a:bufno)
                    if !len(warnings)
                        return [yealine#BaseColor(a:active), ""]
                    endif
                    return [[0, 3], YeaLineSyntaxCheckFormat(warnings)]
                endif
                return [[0, 160], YeaLineSyntaxCheckFormat(errors)]
            endif
        endif
    endif
    return [yealine#BaseColor(a:active), ""]
endfunction

function YealineFilename(active, bufno)
    let name = bufname(a:bufno)
    if name != ""
        let name = fnamemodify(name, ':~:.')
    else
        let name = "[No filename]"
    endif
    if a:active
        let current_mode_color = yealine#boxes#Mode(a:active, a:bufno)[0]
        return [current_mode_color, name]
    endif
    return [yealine#BaseColor(0), name]
endfunction

function! YealineMiddleColor(active, bufno)
    if a:active
        let current_mode_color = yealine#boxes#Mode(a:active, a:bufno)[0]
        return current_mode_color
    endif
    return yealine#BaseColor(a:active)
endfunction

