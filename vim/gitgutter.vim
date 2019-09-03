let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0

set updatetime=100

let g:gitgutter_sign_added = ""
let g:gitgutter_sign_modified = ""
let g:gitgutter_sign_removed = ""
let g:gitgutter_sign_modified_removed = ""

map ]c <Plug>GitGutterNextHunk
map [c <Plug>GitGutterPrevHunk
map ]x <Plug>GitGutterUndoHunk

