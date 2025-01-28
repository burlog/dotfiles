" Enable experimental implementation
let g:airline_experimental = 1

" The best colorscheme ever
let g:airline_theme = 'burlog'

" Enable only the extensions I want
let g:airline_extensions = [
\    'ycm',
\    'branch',
\    'tabline',
\]
" call add(s:loaded_ext, 'poetv')
" call add(s:loaded_ext, 'virtualenv')

" Enable powerline fonts
let g:airline_powerline_fonts = 1

" Disable alt separators for inactive windows
let g:airline_inactive_alt_sep = 0

" Do not show the empty sections
let g:airline_skip_empty_sections = 1

" Custom separators
let g:airline_left_sep = "\UE0BC"
let g:airline_left_alt_sep = ""
let g:airline_right_sep = "\UE0BA"
let g:airline_right_alt_sep = ""

" Redifine symbols
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.dirty = ""
let g:airline_symbols.notexists = "\U2009"
let g:airline_symbols.branch = "\U2009"

" Do not hide sections in inactive windows
let g:airline_inactive_collapse = 0

" Allow tabline
let g:airline#extensions#tabline#enabled = 1

" Do not show buffers in the tabline
let g:airline#extensions#tabline#show_buffers = 0

" Tab title formatter
let g:airline#extensions#tabline#formatter = 'short_path'

" Overflow character
let g:airline#extensions#tabline#overflow_marker = '…'

" Do not show the close button
let g:airline#extensions#tabline#show_close_button = 0

" Do not show buffers on the right side of the tabline
let g:airline#extensions#tabline#show_splits = 0

" Show tabline for two and more tabs
let g:airline#extensions#tabline#tab_min_count = 2

" Do now define any mapping for accessing buffers
let g:airline#extensions#tabline#buffer_idx_mode = 0

" Use this icon as tab label
let g:airline#extensions#tabline#tabs_label = '󰓩'

" Refresh the statusline on YCM diagnostic updates
autocmd User YcmDiagnosticUpdated :AirlineRefresh!
" Refresh the statusline on GitGutter updates
autocmd User GitGutter :AirlineRefresh!
" Hotfix for the searchcount plugin which is not correctly updating the
" statusline for active window when the search is done
autocmd CmdlineLeave * call timer_start(100, {-> execute('AirlineRefresh')})

" Returns the icon for the current file type or the first 5 characters of the
" file type if the icon is not found
function! WebDevIconsGetFileTypeSymbolWithFallback() abort
    let l:icon = WebDevIconsGetFileTypeSymbol()
    if l:icon == g:WebDevIconsUnicodeDecorateFileNodesDefaultSymbol
        let l:type = strcharpart(&filetype, 0, 5)
        if l:type != ''
            return l:type
        endif
        return ''
    endif
    return l:icon
endfunction

function! SearchCountStatus() abort
    return airline#extensions#searchcount#status()
endfunction

"= Custom parts ================================================================

" Define the string used for flags
let s:flag_string = "\U2009\U2b24"

" Returns the current git hunks summary
function! GitHunkSummaryAPart()
    let [a,m,r] = GitGutterGetHunkSummary()
    if a == 0
        return ''
    endif
    return printf('✚%d', a)
endfunction
function! GitHunkSummaryMPart()
    let [a,m,r] = GitGutterGetHunkSummary()
    if m == 0
        return ''
    endif
    return printf('●%d', m)
endfunction
function! GitHunkSummaryRPart()
    let [a,m,r] = GitGutterGetHunkSummary()
    if r == 0
        return ''
    endif
    return printf('−%d', r)
endfunction
function! GitHunkSummaryEPart()
    let vcf_config = getbufvar(bufnr(), 'buffer_vcs_config', {})
    if has_key(vcf_config, 'git')
        if vcf_config['git'].untracked != ''
            return printf('✚%d', line('$'))
        endif
    endif
    return ''
endfunction

" Returns the filename of the buffer for mutable buffers
function! RWFilenamePart()
    if &readonly
        return ''
    endif
    return expand('%:f')
endfunction

" Returns the filename of the buffer for immutable buffers
function! ROFilenamePart()
    if &readonly
        return expand('%:f')
    endif
    return ''
endfunction

" Returns the readonly status of the buffer
function! ReadOnlyPart()
    let l:ro = airline#parts#readonly()
    if l:ro == g:airline_symbols.readonly
        return s:flag_string
    endif
    return ''
endfunction

" Returns the modified status of the buffer
function! ModifiedPart()
    if &modified
        return s:flag_string
    endif
    return ''
endfunction

" Returns the paste mode status
function! PastePart()
    if &paste
        return s:flag_string
    endif
    return ''
endfunction

" Function to define custom parts
function! DefineCustomParts()
    call airline#parts#define_function('git-hunk-summary-a', 'GitHunkSummaryAPart')
    call airline#parts#define_function('git-hunk-summary-m', 'GitHunkSummaryMPart')
    call airline#parts#define_function('git-hunk-summary-r', 'GitHunkSummaryRPart')
    call airline#parts#define_function('git-hunk-summary-e', 'GitHunkSummaryEPart')
    call airline#parts#define_function('b_readonly', 'ReadOnlyPart')
    call airline#parts#define_function('b_filename_rw', 'RWFilenamePart')
    call airline#parts#define_function('b_filename_ro', 'ROFilenamePart')
    call airline#parts#define_function('b_modified', 'ModifiedPart')
    call airline#parts#define_function('b_paste', 'PastePart')
endfunction

" Function to map custom parts to accents
function! DefineCustomAccents()
    call airline#parts#define_accent('git-hunk-summary-a', 'exgreen')
    call airline#parts#define_accent('git-hunk-summary-m', 'ochre')
    call airline#parts#define_accent('git-hunk-summary-r', 'darkred')
    call airline#parts#define_accent('git-hunk-summary-e', 'darkgreen')
    call airline#parts#define_accent('b_readonly', 'red')
    call airline#parts#define_accent('b_filename_ro', 'darkred')
    call airline#parts#define_accent('b_modified', 'green')
    call airline#parts#define_accent('b_paste', 'yellow')
    call airline#parts#define_accent('searchcount', 'yellow')
endfunction

"= Statusline ==================================================================

" Function to initialize the airline
function! AirlineInit()
    " define custom parts
    call DefineCustomParts()
    " define accents
    call DefineCustomAccents()

    " section: a
    let g:airline_section_a = airline#section#create([
    \    '%2.2n',
    \])

    " section: b
    let g:airline_section_b = airline#section#create([
    \    '%>%-5.5{WebDevIconsGetFileTypeSymbolWithFallback()}',
    \])

    " section: c
    let g:airline_section_c = airline#section#create([
    \    'b_filename_rw',
    \    'b_filename_ro',
    \])

    " section: s
    let g:airline_section_s = airline#section#create([
    \    '%{SearchCountStatus()}',
    \])

    " section: x
    let g:airline_section_x = airline#section#create([
    \    'b_modified',
    \    'b_readonly',
    \    'b_paste',
    \])

    " section: y
    let g:airline_section_y = airline#section#create([
    \    'git-hunk-summary-a',
    \    'git-hunk-summary-r',
    \    'git-hunk-summary-m',
    \    'git-hunk-summary-e',
    \    'branch',
    \])

    " section: z
    let g:airline_section_z = airline#section#create([
    \    "\Ue0a1%4.4l/%-4.4L \Ue0a3%3.3c",
    \])

    " redraw because of the custom parts with accents are drawn in weird way
    AirlineRefresh
endfunction
autocmd User AirlineAfterInit call AirlineInit()

" Custom layout of the sections
let g:airline#extensions#default#layout = [
\    ['a', 'b', 'c',],
\    ['warning', 'error', 's', 'x', 'y', 'z',]
\]
