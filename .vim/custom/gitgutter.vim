" disable gitgutter default key mappings
let g:gitgutter_map_keys = 0

" set gitgutter sings priority to lower than YCM
let g:gitgutter_priority = 1

" update gitgutter every 100ms
set updatetime=100

" use the arrow symbols for the gitgutter signs
let g:gitgutter_sign_added = ""
let g:gitgutter_sign_removed = ""
let g:gitgutter_sign_modified = ""
let g:gitgutter_sign_modified_removed = ""

" map keys to navigate hunks
map ]c <Plug>(GitGutterNextHunk)
map [c <Plug>(GitGutterPrevHunk)
map ]x <Plug>(GitGutterUndoHunk)
