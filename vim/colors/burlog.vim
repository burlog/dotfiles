" Use black background
set background=dark

" vim visuals
highlight StatusLine term=bold cterm=bold          ctermfg=236  ctermbg=236 guifg=#aaaaaa guibg=#303030
highlight StatusLineNC term=bold cterm=bold        ctermfg=236  ctermbg=236 guifg=#303030 guibg=#303030
highlight VertSplit term=none cterm=none                        ctermbg=236 guifg=#303030 guibg=#303030
highlight SignColumn                                            ctermbg=236               guibg=#303030
highlight WildMenu                                 ctermfg=236  ctermbg=12  guifg=#303030 guibg=#ffcc00
highlight CursorLine cterm=none                                 ctermbg=235               guibg=#2c2c2c
highlight CursorColumn cterm=none                               ctermbg=235               guibg=#2c2c2c
highlight ColorColumn term=none                    ctermfg=202  ctermbg=0   guifg=#af0000 guibg=#000000
highlight Pmenu                                    ctermfg=249  ctermbg=0   guifg=#b2b2b2 guibg=#010101
highlight PmenuSel                                 ctermfg=0    ctermbg=45  guifg=#ffffff guibg=#333333
highlight PmenuSbar                                             ctermbg=249               guibg=#010101
highlight PmenuThumb                                            ctermbg=45                guibg=#828282
highlight Visual      term=reverse                              ctermbg=94                guibg=#4d3d00
highlight FoldColumn  term=standout                ctermfg=0    ctermbg=242 guifg=#bbbbbb guibg=#303030
highlight Folded      term=standout                ctermfg=0    ctermbg=242 guifg=#bbbbbb guibg=#303030
highlight DiffAdd     term=reverse                              ctermbg=22                guibg=#084d00
highlight DiffChange  term=reverse                              ctermbg=94                guibg=#662500
highlight DiffDelete  term=none  gui=none          ctermfg=255  ctermbg=196 guifg=#ffebe6 guibg=#b32400
highlight DiffText    term=reverse cterm=none gui=none          ctermbg=6                 guibg=#006680
highlight MultiCur                                 ctermfg=0    ctermbg=216 guifg=#000000 guibg=#ffc299
highlight MultiVisual                              ctermfg=0    ctermbg=123 guifg=#000000 guibg=#cce6ff
highlight GitGutterAdd                             ctermfg=22   ctermbg=236 guifg=#084d00 guibg=#303030
highlight GitgutterChangeDelete                    ctermfg=94   ctermbg=236 guifg=#662500 guibg=#303030
highlight GitGutterChange                          ctermfg=94   ctermbg=236 guifg=#662500 guibg=#303030
highlight GitGutterDelete                          ctermfg=196  ctermbg=236 guifg=#b32400 guibg=#303030

" spellchecker and other checkers like ycm is
highlight SpellBad   cterm=underline gui=undercurl              ctermbg=9   guifg=#df0000               guisp=Red
highlight SpellCap   cterm=underline gui=undercurl              ctermbg=12  guifg=#ffcc00               guisp=Blue
highlight SpellRare  cterm=underline gui=undercurl              ctermbg=13  guifg=#df0000               guisp=Magenta
highlight SpellLocal cterm=underline gui=undercurl              ctermbg=14  guifg=#df0000               guisp=Cyan
highlight YcmWarningSign                           ctermfg=220  ctermbg=220 guifg=#ffcc00 guibg=#303030
highlight YcmErrorSign                             ctermfg=9    ctermbg=236 guifg=#df0000 guibg=#303030
highlight link CompileError YcmErrorSign
highlight link CompileWarning YcmWarningSign
highlight CompileErrorLine cterm=none term=none
highlight CompileWarningLine cterm=none term=none

" syntax
highlight Error      cterm=bold                    ctermfg=202  ctermbg=124 guifg=#000000 guibg=#af0000
highlight Special                                  ctermfg=1                guifg=#e0b3ff
highlight Type       term=none                     ctermfg=82               guifg=#5fff00
highlight PreProc                                  ctermfg=66               guifg=#5f8787
highlight Search                                                ctermbg=220               guibg=#ffcc00
highlight Constant                                 ctermfg=147              guifg=#afafff
highlight Comment                                  ctermfg=31               guifg=#0087af
highlight Identifier cterm=none                    ctermfg=33               guifg=#0099ff
highlight ExtraWhitespace                                       ctermbg=124               guibg=#af0000

" custom syntax from polyglot and me
highlight cppCustomNamespace                       ctermfg=136              guifg=#af8700
highlight cCustomClass                             ctermfg=70               guifg=#11a000
highlight jsDomElemFuncs                           ctermfg=34               guifg=#00af00
highlight jsCssStyles                              ctermfg=202              guifg=#b34100
highlight jsDotNotation                            ctermfg=34               guifg=#11a000
highlight link cCustomOperator Statement
highlight link cppSTLnamespace cppCustomNamespace
highlight link jsThis jsReturn
highlight link jsPrototype jsFunction
highlight link jsGlobalObjects jsFunction
highlight link jsBuiltins jsFunction
highlight link jsFuncCall Identifier
highlight link jsOperator NONE
highlight link jsDomElemAttrs jsDomElemFuncs
highlight link jsHtmlElemAttrs jsDomElemFuncs
highlight link jsClassListFuncs jsDomElemFuncs
highlight link pythonImport Include
highlight link diffAdded DiffAdd
highlight link diffRemoved DiffDelete
highlight link agitDiffRemove DiffDelete
highlight link agitDiffAdd DiffAdd
highlight link multiple_cursors_cursor MultiCur
highlight link multiple_cursors_visual MultiVisual

