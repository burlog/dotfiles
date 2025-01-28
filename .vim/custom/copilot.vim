imap <silent><script><expr> <CR> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

imap w <Plug>(copilot-accept-word)
imap e <Plug>(copilot-accept-line)
imap <C-L> <Plug>(copilot-next)
imap <C-K> <Plug>(copilot-previous)
imap <C-P> <Plug>(copilot-suggest)
