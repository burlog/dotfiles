let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:gitgutter_override_sign_column_highlight = 0

let g:gitgutter_sign_added = ""
let g:gitgutter_sign_modified = ""
let g:gitgutter_sign_removed = ""
let g:gitgutter_sign_modified_removed = ""

map ]c :call gitgutter#utility#set_buffer(bufnr("%"))<CR>:GitGutterNextHunk<CR>
map [c :call gitgutter#utility#set_buffer(bufnr("%"))<CR>:GitGutterPrevHunk<CR>

