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
set splitright                 " Open windows on right side
set winfixheight               " Don't automatically change windows height
set path+=/usr/local/include   " Adds /usr/local/include to include search path
set include=^\\s*#\\s*include\\s*\\(\"\\\|<mime\\\|<szn\\\|<html\\\|<frpc\\\|<urilib\\\|<sump\\\|<resolver\\\|<probe\\\|<mcache\\\|<css\\\|<content-cleaner\\\|<aeros\\)

"= Gui settings ================================================================

" cursor change: SI=insert-mode, SR=replace-mode, EI=normal/command-mode
let &t_SI = "\<Esc>]50;CursorShape=1;CustomCursorColor=\#ff5f00\x7"
let &t_SR = "\<Esc>]50;CursorShape=1;CustomCursorColor=\#afffff\x7"
let &t_EI = "\<Esc>]50;CursorShape=3;CustomCursorColor=\#ffd700\x7"
au VimEnter * silent execute '!echo -ne "\e]50;CursorShape=3;CustomCursorColor=\#ffd700\x7"' | redraw!
au VimLeave * silent execute '!echo -ne "\e]50;CursorShape=1;CustomCursorColor=0\x7"' | redraw!

"= Key mapping =================================================================
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
imap <F1>         <C-O>:call OpenPreview()<CR><C-O>:YcmCompleter FixIt<CR>
imap <F3>         <C-O>:call ToggleSignColumn()<CR>
imap <F5>         <C-O>:GundoToggle<CR>
imap <F4>         <C-O>:Gdiff<CR>
imap <F7>         <C-O>:retab<CR>
imap <F8>         <C-O>:StripWhitespace<CR>
imap <F10>        <Esc>:call Make()<CR><CR><C-W>p
imap <A-F11>      <C-O>:Tlist<CR>
imap @sa      <C-O>:ArgWrap<CR>

map <C-E>         <End>
map <A-Down>      <C-w><Down>
map <A-Up>        <C-w><Up>
map <A-Left>      <C-w><Left>
map <A-Right>     <C-w><Right>
map <A-PageDown>  <C-w><Down><C-w>200+
map <A-PageUp>    <C-w><Up><C-w>200+
map <C-Tab>       :tabnext<CR>
map [1;1C     :tabnext<CR>
map [1;1D     :tabprevious<CR>
map <A-F1>        :call AddDoc()<CR>a
map <F1>          :call OpenPreview()<CR>:YcmCompleter FixIt<CR>
map <F2>          :YcmForceCompileAndDiagnostics<CR>
map <C-F2>        :YcmShowDetailedDiagnostic<CR>
map <F3>          :call ToggleSignColumn()<CR>
map <F4>          :Gdiff<CR>
map <F5>          :GundoToggle<CR>
map <F7>          :retab<CR>
map <F8>          :StripWhitespace<CR>
map <F10>         :call Make()<CR><C-W>p
map <A-F11>       :Tlist<CR>
map @sa       :ArgWrap<CR>
map ]e            :call GotoNextSign("YcmError", "YcmWarning", "errormarker_error", "errormarker_warning")<CR>
map [w            :cprev<CR>
map ]w            :cnext<CR>

cmap <C-A>        <Home>

vnoremap < <gv
vnoremap > >gv

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)

"= Vundle and Pathogen plugins =================================================
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'sjl/gundo.vim'
source $HOME/.vim/gundo.vim

Plugin 'tpope/vim-fugitive'
source $HOME/.vim/vim-fugitive.vim

Plugin 'burlog/yealine.vim'
source $HOME/.vim/yealine.vim

Plugin 'Valloric/YouCompleteMe'
source $HOME/.vim/ycm.vim

Plugin 'rdnetto/YCM-Generator'

Plugin 'sheerun/vim-polyglot'
source $HOME/.vim/vim-polyglot.vim

Plugin 'xolox/vim-misc'

Plugin 'xolox/vim-session'
source $HOME/.vim/vim-session.vim

Plugin 'laurentgoudet/vim-howdoi'

source $HOME/.vim/utlisnips.vim
Plugin 'SirVer/ultisnips'

Plugin 'vim-scripts/taglist.vim'

Plugin 'ntpeters/vim-better-whitespace'

Plugin 'vim-scripts/a.vim'

Plugin 'mh21/errormarker.vim'
source $HOME/.vim/errormarker.vim

Plugin 'dkasak/manpageview'

Plugin 'ap/vim-css-color'

Plugin 'cohama/agit.vim'

Plugin 'matze/vim-move'
source $HOME/.vim/move.vim

Plugin 'romgrk/replace.vim'
source $HOME/.vim/replace.vim

Plugin 'terryma/vim-multiple-cursors'

Plugin 'FooSoft/vim-argwrap'

Plugin 'junegunn/vim-easy-align'

Plugin 'tomtom/tcomment_vim'

Plugin 'airblade/vim-gitgutter'
source $HOME/.vim/gitgutter.vim

Plugin 'yssl/QFEnter'

Plugin 'tpope/vim-surround'

Plugin 'chrisbra/csv.vim'
source $HOME/.vim/csv.vim

Plugin 'PeterRincker/vim-argumentative'
source $HOME/.vim/argumentative.vim

call vundle#end()

"= Some options that must be after vundle =====================================
filetype plugin indent on      " Turn on filetype plugins
syntax on                      " Turn on syntax highlighting
colorscheme burlog             " The best colorscheme ever
if has('termguicolors')
    set termguicolors          " Display gui colors on terminal
endif

autocmd FileType c,cpp,python execute "setlocal colorcolumn=" . join(range(81, 256), ",")
autocmd BufLeave,WinLeave        * setlocal nocursorline     " Hide current line
autocmd BufEnter,BufNew,WinEnter * setlocal cursorline       " Show current line

autocmd FileType c,cpp,python,js syntax match ExtraWhitespace "^ *\t\+\s*\<"
autocmd FileType txt setlocal textwidth=78
autocmd FileType css,html,xml,xhtml,rss
    \ setlocal noexpandtab |
    \ setlocal shiftwidth=8 |
    \ setlocal tabstop=8 |
    \ setlocal softtabstop=8

autocmd BufRead,BufNewFile *.rfc822 setlocal filetype=mail

autocmd BufRead,BufNewFile COMMIT_EDITMSG execute "call OpenGitDiff()"

autocmd FileType c,cpp setlocal matchpairs+=<:>

source $HOME/.vim/my.vim

"= Abbreviations "==============================================================
autocmd FileType cpp abbreviate strign string
autocmd FileType python abbreviate sefl self

