" Based on  Bailey Ling's dark.vim theme.

scriptencoding utf-8

" Each entry consists of [guifg, guibg, ctermfg, ctermbg, opts]
let g:airline#themes#burlog#palette = {}

" Active window in normal mode
let g:airline#themes#burlog#palette.normal = {
\  'airline_a':                  ['#c2c2c2', '#303030', 249, 236],
\  'airline_b':                  ['#b2b2b2', '#000087', 249,  18],
\  'airline_c':                  ['#000000', '#00afff',   0,  39],
\  'airline_warning':            ['#000000', '#ffaf00',   0, 202],
\  'airline_error':              ['#000000', '#ff0000',   0, 202],
\  'airline_s':                  ['#000000', '#ffdf00',   0, 220],
\  'airline_x':                  ['#000000', '#000087',   0,  18],
\  'airline_y':                  ['#000000', '#005fdf',   0,  26],
\  'airline_z':                  ['#c2c2c2', '#303030', 249, 236, 'bold'],
\}

" Active tabline in normal mode
let g:airline#themes#burlog#palette.tabline = {
\  'airline_tabsel':             ['#000000', '#005f00',   0,  22],
\  'airline_tabsel_right':       ['#000000', '#005f00',   0,  22],
\  'airline_tabmod':             ['#000000', '#005f00',   0,  22],
\  'airline_tabmod_right':       ['#000000', '#005f00',   0,  22],
\  'airline_tab':                ['#000000', '#444444',   0, 238],
\  'airline_tab_right':          ['#000000', '#444444',   0, 238],
\  'airline_tabmod_unsel':       ['#000000', '#444444',   0, 238],
\  'airline_tabmod_unsel_right': ['#000000', '#444444',   0, 238],
\  'airline_tabfill':            ['#000000', '#303030', 249, 236],
\  'airline_tablabel':           ['#000000', '#666666',   0, 242],
\}

" Active window in insert mode
let g:airline#themes#burlog#palette.insert = {
\  'airline_a': ['#c2c2c2', '#303030', 249, 236],
\  'airline_c': ['#000000', '#00af00',   0, 34],
\  'airline_b': ['#b2b2b2', '#000087', 249,  18],
\}

" Active window in replace mode
let g:airline#themes#burlog#palette.replace = {
\  'airline_c': ['#000000', '#ff5f00',   0, 202],
\}

" Active window in visual mode
let g:airline#themes#burlog#palette.visual = {
\  'airline_a': ['#c2c2c2', '#303030', 249, 236],
\  'airline_c': ['#000000', '#ffdf00',   0, 220],
\  'airline_b': ['#b2b2b2', '#000087', 249,  18],
\}

" Active window in select mode
let g:airline#themes#burlog#palette.select = {
\  'airline_c': ['#000000', '#ffdf00',   0, 220],
\}

" Inactive window
let g:airline#themes#burlog#palette.inactive = {
\  'airline_a':         ['#666666', '#303030', 242, 236],
\  'airline_b':         ['#666666', '#444444', 242, 238],
\  'airline_c':         ['#303030', '#666666', 236, 242],
\  'airline_s':         ['#ffdf00', '#666666',   0, 220],
\  'airline_x':         ['#303030', '#666666', 236, 242],
\  'airline_y':         ['#303030', '#666666', 236, 242],
\  'airline_z':         ['#666666', '#303030', 242, 236, 'bold'],
\}

" Custom accents
let g:airline#themes#burlog#palette.accents = {
\  'darkred':    ['#870000', '',  88, '', 'bold'],
\  'lightgreen': ['#afff00', '', 154, '', 'bold'],
\  'darkgreen':  ['#005f00', '',  22, '', 'bold'],
\  'exgreen':    ['#87af00', '',  22, '', 'bold'],
\  'ochre':      ['#af8700', '', 136, '', 'bold'],
\}
