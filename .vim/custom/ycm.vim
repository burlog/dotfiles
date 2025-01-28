" diagnostics options
let g:ycm_show_diagnostics_ui = 1                              " enable diagnostics at all
let g:ycm_enable_diagnostic_signs = 1                          " enable diagnostic signs in the sign column
let g:ycm_enable_diagnostic_highlighting = 1                   " enable diagnostic highlighting
let g:ycm_echo_current_diagnostic = 1                          " enable diagnostic echo to the command line
let g:ycm_always_populate_location_list = 0                    " don't populate the location list with diagnostics
let g:ycm_open_loclist_on_ycm_diags = 0                        " don't open the location list with diagnostics
let g:ycm_error_symbol = ""                                   " set the error symbol
let g:ycm_warning_symbol = ""                                 " set the warning symbol
let g:ycm_max_diagnostics_to_display = 30                      " set the maximum number of diagnostics to display
let g:ycm_show_detailed_diag_in_popup = 1                      " show detailed diagnostics in a popup
" let g:ycm_key_detailed_diagnostics = ""

" completion options
let g:ycm_auto_trigger = 1                                     " automatically displays identifier/semantic completion
let g:ycm_min_num_of_chars_for_completion = 99                 " turn off identifier completion
let g:ycm_complete_in_comments = 1                             " allow completion in comments
let g:ycm_complete_in_strings = 0                              " don't allow completion in strings
let g:ycm_use_ultisnips_completer = 0                          " don't use UltiSnips for completion (the MyCleverTab function will handle this)
let g:ycm_collect_identifiers_from_comments_and_strings = 0    " don't collect identifiers from comments and strings
let g:ycm_collect_identifiers_from_tags_files = 0              " don't collect identifiers from tags files
let g:ycm_seed_identifiers_with_syntax = 0                     " don't seed identifiers with syntax
let g:ycm_key_invoke_completion = "<C-f>"                      " invoke completion with <C-f>
let g:ycm_key_list_select_completion = ["<Down>"]              " do not include <Tab> in the list of keys to select completion
let g:ycm_key_list_previous_completion = ["<Up>"]              " do not include <S-Tab> in the list of keys to select previous completion
let g:ycm_add_preview_to_completeopt = 0                       " do not show preview window when completion menu is open
let g:ycm_autoclose_preview_window_after_completion = 0        " close preview window after completion
let g:ycm_autoclose_preview_window_after_insertion = 0         " close preview window after insertion
let g:ycm_disable_signature_help = 1                           " do not show signature help after left paren
let g:ycm_update_diagnostics_in_insert_mode = 0                " do not update diagnostics in insert mode

" other options
let g:ycm_use_clangd = 1                                       " use clangd as the language server
let g:ycm_log_level = 'info'                                   " set the log level to info
let g:ycm_enable_semantic_highlighting = 1                     " enable semantic source code highlighting
let g:ycm_goto_buffer_command = "split"                        " open the definition in a new window above the current window
let g:ycm_auto_hover = ''                                      " no doc popup on the CursorHold event

" clangd options
let g:ycm_clangd_args = [
\    "--header-insertion=never",
\    "--completion-style=detailed",
\    "--background-index",
\    "--clang-tidy",
\]

" list of filetypes for whic YCM should be enabled
let g:ycm_filetype_whitelist = {
\    "cpp": 1,
\    "c": 1,
\    "python": 1,
\    "javascript": 1
\}

" list of filetypes for which YCM should be disabled (enable for all filetypes)
let g:ycm_filetype_blacklist = {}

" get the list of filetypes for which YCM should be enabled
let s:ycm_filetype_list = join(keys(g:ycm_filetype_whitelist), ",")
" define mapping to jump to the definition of the identifier under the cursor
execute "autocmd FileType " . s:ycm_filetype_list . " map ]d :rightbelow vertical YcmCompleter GoTo<CR>"
" show/hide signature help (commented out because doesn't work if the " signature help is disabled)
" execute "autocmd FileType " . s:ycm_filetype_list . " imap <silent> <C-l> <Plug>(YCMToggleSignatureHelp)"
" show/hide hover doc popup
execute "autocmd FileType " . s:ycm_filetype_list . " map <silent> K <Plug>(YCMHover)"

" always show the sign column
sign define SignColumnVisible text=** texthl=Search
execute "autocmd FileType " . s:ycm_filetype_list . " autocmd BufEnter * :call PlaceDefaultSign(0)"

" syntax highlighting for semantic source code highlighting
highlight YCM_hi_namespace        term=none
highlight YCM_hi_type             term=none
highlight YCM_hi_class            term=none
highlight YCM_hi_enum             term=none
highlight YCM_hi_enum_value       term=none
highlight YCM_hi_class            term=none
highlight YCM_hi_template_type    term=none
highlight YCM_hi_argument         term=none
highlight YCM_hi_variable         term=none
highlight YCM_hi_member_variable  term=none
highlight YCM_hi_unknown          term=none
highlight YCM_hi_function         term=none
highlight YCM_hi_method           term=none
highlight YCM_hi_macro            term=none
highlight YCM_hi_keyword          term=none
highlight YCM_hi_comment          term=none
highlight YCM_hi_constant         term=none
highlight YCM_hi_regexp           term=none
highlight YCM_hi_operator         term=none
highlight YCM_hi_decorator        term=none

" set the highlight group for each token type
let s:my_ycm_highlight_group = {
\    "namespace": "YCM_hi_namespace",
\    "type": "YCM_hi_type",
\    "class": "YCM_hi_class",
\    "enum": "YCM_hi_enum",
\    "interface": "YCM_hi_keyword",
\    "struct": "YCM_hi_class",
\    "typeParameter": "YCM_hi_template_type",
\    "parameter": "YCM_hi_argument",
\    "variable": "YCM_hi_variable",
\    "property": "YCM_hi_member_variable",
\    "enumMember": "YCM_hi_enum_value",
\    "event": "YCM_hi_unknown",
\    "function": "YCM_hi_function",
\    "method": "YCM_hi_method",
\    "macro": "YCM_hi_macro",
\    "keyword": "YCM_hi_keyword",
\    "modifier": "YCM_hi_unknown",
\    "comment": "YCM_hi_comment",
\    "string": "YCM_hi_constant",
\    "number": "YCM_hi_constant",
\    "regexp": "YCM_hi_regexp",
\    "operator": "YCM_hi_operator",
\    "decorator": "YCM_hi_decorator",
\}
for token_type in keys(s:my_ycm_highlight_group)
    call prop_type_add("YCM_HL_" . token_type, {"highlight": s:my_ycm_highlight_group[token_type]})
endfor

" use <Tab> to insert a tab character at the beginning of a line, expand
" snippets, or navigate completion menu
function! MyCleverTab()
    let current_line = strpart(getline("."), 0, col(".") - 1)
    if current_line =~ "^\\s*$"
        echom "Tab"
        return "\<Tab>"
    endif
    if has_key(g:ycm_filetype_whitelist, &filetype)
        let g:ycm_pummenu_closed = 0
    endif
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 1
        echom "Ultisnips"
        return ""
    endif
    if pumvisible()
        echom "<C-N>"
        return "\<C-N>"
    endif
    call feedkeys("\<C-F>")
    echom "<C-F>"
    return ""
endfunction
imap <Tab> <C-R>=MyCleverTab()<CR>

" when completion menu is closed, set g:ycm_pummenu_closed to 1
autocmd CompleteDone * let g:ycm_pummenu_closed = 1

function! ColorizeClangOutput(output)
  " Define highlight groups for different components
  highlight ErrorHighlight guifg=red
  highlight NoteHighlight guifg=cyan
  highlight FileHighlight guifg=blue
  highlight LineColHighlight guifg=yellow

  " Split the output into lines
  let lines = split(a:output, "\n")

  " Process each line
  for line in lines
    let parts = []
    let current_line = ""

    " Highlight file paths (e.g., /path/to/file.cpp:line:col)
    if line =~ '\v(\S+\.h|\S+\.cpp|\S+\.c|\S+\.hpp):\d+:\d+:'
      let current_line .= '\e[FileHighlight]' . matchstr(line, '\v(\S+\.h|\S+\.cpp|\S+\.c|\S+\.hpp):\d+:\d+:')
      call add(parts, current_line)
      let line = substitute(line, '\v(\S+\.h|\S+\.cpp|\S+\.c|\S+\.hpp):\d+:\d+:', '', 'g')
    endif

    " Highlight line and column numbers
    if line =~ '\v:\d+:\d+:'
      let current_line = '\e[LineColHighlight]' . matchstr(line, '\v:\d+:\d+:')
      call add(parts, current_line)
      let line = substitute(line, '\v:\d+:\d+:', '', 'g')
    endif

    " Highlight errors
    if line =~ '\<error\>'
      let current_line = '\e[ErrorHighlight]' . matchstr(line, '\<error\>')
      call add(parts, current_line)
      let line = substitute(line, '\<error\>', '', 'g')
    endif

    " Highlight notes
    if line =~ '\<note\>'
      let current_line = '\e[NoteHighlight]' . matchstr(line, '\<note\>')
      call add(parts, current_line)
      let line = substitute(line, '\<note\>', '', 'g')
    endif

    " Print the colorized parts
    for part in parts
      echohl None
      echom part
    endfor

    " Print the rest of the line (after the matched parts)
    if len(line) > 0
      echohl None
      echom line
    endif
  endfor
endfunction

function! ShowColoredDiagnostics()
  let output = execute('YcmShowDetailedDiagnostic')
  call ColorizeClangOutput(output)
endfunction

