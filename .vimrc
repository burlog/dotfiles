"= Simple options ==============================================================
set nocompatible               " IMproved!
set backspace=indent,eol,start " Over autoindent, over lines, over start of ins
set viminfo='50,<500           " Store X marks, store regs shorter then X lines
set history=1000               " History length
set wrap                       " Wrap long lines
set showbreak=....             " Wrapped line mark
set linebreak                  " Wrap at the end of the word
set showmatch                  " Show matched brackets
set display=lastline,uhex      " Show last line, show binary chars as <hex>
set ignorecase                 " Ignore case during search
set nosmartcase                " Sounds good but sucks \C is better alternative
set selection=exclusive        " Last char in selecion is ommited from it
set hlsearch                   " Highlight the search results
set incsearch                  " Highlight the search during writting the query
set noshowmode                 " Don't show mode
set showcmd                    " Show command in last line
set laststatus=2               " Show status line for every buffer
set wildchar=<Tab>             " Complete commands with Tab key
set wildmenu                   " Show menu for commands completion
set wildmode=longest:list,full " Mode of the completion menu
set directory=$HOME/tmp        " Directory for swap files
set backupdir=$HOME/tmp        " Directory for backup files
set backup                     " Do backup files
set encoding=utf-8             " Use UTF-8 encoding for everything
set winminheight=0             " Allow zero line sized buffers
set winminwidth=0              " Allow zero column sized buffers
set modelines=0                " Turn off modelines
set pumheight=10               " Show X items in popup menus
set scrolloff=5                " Scroll X lines before buffer boundaries
set autoread                   " Reload unchanged files automatically
set clipboard+=unnamed         " Use separate clipboard from X
set undofile                   " Use undofile which turns persisten undo on
set undodir=$HOME/tmp          " Where should be persisten file placed
set timeoutlen=250             " Set escape mapping timeout to Xms
set ttimeoutlen=-1             " Set escape timeout to Xms
set noequalalways              " Don't resize all windows after closing
set diffopt+=,vertical         " Open diff in vertical split
set pastetoggle=<F12>          " Toggle for paste
set shiftwidth=4               " Default indent size
set expandtab                  " I don't like tabs
set softtabstop=4              " Tab size
set tabstop=4                  " Tab size
set autoindent                 " Copy indent
set switchbuf=split            " Open windows in new window
set winfixheight               " Don't automatically change windows height
set path+=/usr/local/include   " Adds /usr/local/include to include search path
set include=^\\s*#\\s*include\\s*\\(\"\\\|<mime\\\|<szn\\\|<html\\\|<frpc\\\|<urilib\\\|<sump\\\|<resolver\\\|<probe\\\|<mcache\\\|<css\\\|<content-cleaner\\\|<aeros\\)
set foldmethod=marker          " Use vim triple { markers to denote folded blocks
set foldcolumn=1               " Adds extra column left edge of window to indicate folds
set fillchars="vert:\|,fold: " " Sets what characters are used to draw vertical lines and folds
set completeopt-=preview       " Remove preview option from completion options

"= Gui settings ================================================================

" cursor change: SI=insert-mode, SR=replace-mode, EI=normal/command-mode
let &t_SI = "\<Esc>]50;CursorShape=1;CustomCursorColor=\#ff5f00\x7"
let &t_SR = "\<Esc>]50;CursorShape=1;CustomCursorColor=\#afffff\x7"
let &t_EI = "\<Esc>]50;CursorShape=1;CustomCursorColor=\#00ffd7\x7"
au VimEnter * silent execute '!echo -ne "\e]50;CursorShape=1;CustomCursorColor=\#00ffff\x7"' | redraw!
au VimLeave * silent execute '!echo -ne "\e]50;CursorShape=1;CustomCursorColor=\#ff5500\x7"' | redraw!

"= Key mapping =================================================================
" Insert mode mappings
imap <C-A>        <Home>
imap <C-E>        <End>
imap <A-Down>     <C-O><A-Down>
imap <A-Up>       <C-O><A-Up>
imap <A-Left>     <C-O><A-Left>
imap <A-Right>    <C-O><A-Right>
imap <A-PageDown> <Esc><A-PageDown>
imap <A-PageUp>   <Esc><A-PageUp>
imap [1;1C    <C-O>:tabnext<CR>
imap [1;1D    <C-O>:tabprevious<CR>
imap <A-F1>       <C-O>:call AddDoc()<CR>
imap <F1>         <C-O>:YcmCompleter FixIt<CR>
imap <F3>         <C-O>:call ToggleSignColumn()<CR>
imap <F5>         <C-O>:GundoToggle<CR>
imap <F4>         <C-O>:Gdiff<CR>
imap <F7>         <C-O>:retab<CR>
imap <F8>         <C-O>:StripWhitespace<CR>

" Normal mode mappings
map <C-E>         <End>
map <A-Down>      <C-w><Down>
map <A-Up>        <C-w><Up>
map <A-Left>      <C-w><Left>
map <A-Right>     <C-w><Right>
map <A-PageDown>  <C-w><Down><C-w><C-_>
map <A-PageUp>    <C-w><Up><C-w><C-_>
map <C-Tab>       :tabnext<CR>
map [1;1C     :tabnext<CR>
map [1;1D     :tabprevious<CR>
map <A-F1>        :call AddDoc()<CR>a
map <F1>          :YcmCompleter FixIt<CR>
map <C-F2>        :YcmForceCompileAndDiagnostics<CR>
map <F2>          :YcmShowDetailedDiagnostic<CR>
map <C-F3>        :YcmCompleter GetType<CR>
map <F3>          :call ToggleSignColumn()<CR>
map <F4>          :Gdiff<CR>
map <F5>          :GundoToggle<CR>
map <F7>          :retab<CR>
map <F8>          :StripWhitespace<CR>
map ]a            :ArgWrap<CR>
map ]e            :call GotoNextSign("YcmError", "YcmWarning", "errormarker_error", "errormarker_warning")<CR>

" Visual mode mappings
vnoremap < <gv
vnoremap > >gv

" Command line mappings
cmap <C-A>        <Home>

" "= Vim-plug plugins " ========================================================
call plug#begin()

" The tons of syntax highlighting and indentation rules
Plug 'sheerun/vim-polyglot'
source $HOME/.vim/custom/polyglot.vim

" Wrapping and unwrapping function arguments
Plug 'https://git.foosoft.net/alex/vim-argwrap.git'
source $HOME/.vim/custom/argwrap.vim

" Alternate between header and source files
Plug 'vim-scripts/a.vim'

" Displays the man page of the word under the cursor in vim
Plug 'dkasak/manpageview'

" Highlighting of the trailing whitespace and stripping it
Plug 'ntpeters/vim-better-whitespace'

" Replacing selected text with preserving the register
Plug 'romgrk/replace.vim'
source $HOME/.vim/custom/replace.vim

" Aligning text by a certain character
Plug 'junegunn/vim-easy-align'

" More text objects for Vim, like arguments, quotes, etc.
Plug 'wellle/targets.vim'

" Multiple cursors in Vim
Plug 'mg979/vim-visual-multi'

" Change the surrounding of the text
Plug 'tpope/vim-surround'

" Manipulating function arguments
Plug 'PeterRincker/vim-argumentative'
source $HOME/.vim/custom/argumentative.vim

" Shows the color inline
Plug 'ap/vim-css-color'

" Global undo mapped on <F5>
Plug 'sjl/gundo.vim'
source $HOME/.vim/custom/gundo.vim

" Git integration
Plug 'tpope/vim-fugitive'
source $HOME/.vim/custom/fugitive.vim

" Online shows the modified lines in the gutter (against the git HEAD)
Plug 'airblade/vim-gitgutter'
source $HOME/.vim/custom/gitgutter.vim

" Color table
Plug 'guns/xterm-color-table.vim'

" Language agnostic code commenting
Plug 'tomtom/tcomment_vim'
source $HOME/.vim/custom/tcomment.vim

" YouCompleteMe plugin
Plug 'Valloric/YouCompleteMe', {'do': './install.py --clangd-completer'}
source $HOME/.vim/custom/ycm.vim

" Copilot plugin
source $HOME/.vim/custom/copilot.vim
Plug 'github/copilot.vim'

" The ultimate snippet expansion engine for Vim
Plug 'SirVer/ultisnips'
source $HOME/.vim/custom/ultisnips.vim

" The statusline plugin
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
source $HOME/.vim/custom/airline.vim

" Injects dev icons into some plugins like airline so it should be loaded
" at the end of the plugins list
Plug 'ryanoasis/vim-devicons'
source $HOME/.vim/custom/devicons.vim

call plug#end()


"= Some options that must be after all plugins =================================
filetype plugin indent on      " Turn on filetype plugins
syntax on                      " Turn on syntax highlighting
colorscheme burlog             " The best colorscheme ever
if has('termguicolors')
    set termguicolors          " Display gui colors on terminal
endif

" draw columns over 80 with red color
autocmd FileType c,cpp,python execute "setlocal colorcolumn=" . join(range(81, 256), ",")

" show cursorline when entering the window
autocmd BufEnter,BufNew,WinEnter * setlocal cursorline
" hide cursorline when leaving the window
autocmd BufLeave,WinLeave        * setlocal nocursorline

" set maximum length of the line for text files
autocmd FileType txt setlocal textwidth=78

" force tabs in web files
autocmd FileType css,html,xml,xhtml,rss
    \ setlocal noexpandtab |
    \ setlocal shiftwidth=8 |
    \ setlocal tabstop=8 |
    \ setlocal softtabstop=8

" force tabs in makefiles and automakefiles
autocmd FileType,BufRead,BufNewFile am,automake
    \ setlocal noexpandtab |
    \ setlocal shiftwidth=4 |
    \ setlocal tabstop=4 |
    \ setlocal softtabstop=4

" force mail filetype for rfc822 files
autocmd BufRead,BufNewFile *.rfc822 setlocal filetype=mail

" open diff when commiting
autocmd BufRead,BufNewFile COMMIT_EDITMSG execute "call OpenGitDiff()"

" allows using % command for angle brackets
autocmd FileType c,cpp setlocal matchpairs+=<:>

" include my functions
source $HOME/.vim/custom/functions.vim

"= Abbreviations "==============================================================
autocmd FileType cpp abbreviate strign string
autocmd FileType cpp abbreviate scok sock
autocmd FileType cpp abbreviate delctype decltype
autocmd FileType python abbreviate sefl self
