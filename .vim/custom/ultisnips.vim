" some predefined variables
let g:snips_author = "Michal Bukovsky <michal.bukovsky@firma.seznam.cz>"
let g:snips_email = "michal.bukovsky@firma.seznam.cz"
let g:snips_github = "https://gihub.com/burlog"

" this collides with tab completion in YCM, so set it to unused key
let g:UltiSnipsExpandTrigger = "<A-F6>"
let g:UltiSnipsListSnippets = "<F6>"

" when snippet is expanded and it contains a placeholder, the cursor will be
" positioned at the first placeholder, use <C-M> to jump to the next one
let g:UltiSnipsJumpForwardTrigger = "<C-M>"
" use <C-B> to jump to the previous placeholder
let g:UltiSnipsJumpBackwardTrigger = "<C-B>"
" where are my snippets stored
let g:UltiSnipsSnippetDirectories = ["/home/burlog/.vim/custom/snippets/"]
" use double quotes for python strings in snippets
let g:ultisnips_python_quoting_style = "double"
" open edit split vertically
let g:UltiSnipsEditSplit = "vertical"
