let g:csv_autocmd_arrange = 1
au BufRead,BufWritePost *.csv :let b:csv_arrange_align = 'l*'
