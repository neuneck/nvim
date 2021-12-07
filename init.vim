" Neovim configuration file
" Julian Schweizer

" Define the python host program to keep pynvim around
let g:python_host_prog = expand('$HOME/.virtualenvs/vim2/bin/python')
let g:python3_host_prog = expand('$HOME/.virtualenvs/vim/bin/python3')

" Use ALL the colors
set termguicolors

" Plugins
call plug#begin()

""" EYECANDY
" Color scheme
Plug 'drewtempelmeyer/palenight.vim'
"
" Git info in sign column
Plug 'airblade/vim-gitgutter'
" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline_powerline_fonts=1
let g:airline_theme='palenight'
" Rainbow colors
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1
"
""" FUNCTIONALITY
" Tree navigation
Plug 'scrooloose/nerdtree'
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '__pycache__$']     " Ignore files in NERDTree
let NERDTreeWinSize=40
autocmd VimEnter * if !argc() | NERDTree | endif  " Load NERDTree if no file opened
nmap " :NERDTreeToggle<CR>
"
" Syntax etc for many languages
Plug 'sheerun/vim-polyglot'
"
" Class/function browser
Plug 'majutsushi/tagbar'
nmap ' :TagbarToggle<CR>
"
" Highlight coverage report lines
Plug 'mgedmin/coverage-highlight.vim'     " Highlight lines form a coverage report
nnoremap <c-h> :ToggleCoverage<CR><CR>

""" CODING
" Linting etc
Plug 'psf/black', { 'branch': 'stable' }
nnoremap <c-B> :Black<CR>

Plug 'dense-analysis/ale'
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'python': ['autopep8', 'remove_trailing_lines', 'trim_whitespace'],
    \}
let g:ale_linters = {
   \ 'python': ['pyflakes', 'pydocstyle', 'pycodestyle']
   \}
let g:airline#extensions#ale#enabled = 1
nnoremap <c-]> :ALEGoToDefinition<CR>
nnoremap <c-n> :ALENext<CR>
nnoremap <c-p> :ALEPrevious<CR>
nnoremap <c-f> :ALEFix<CR>
nnoremap <c-a> :ALEToggle<CR>

" Autocompletion
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'deoplete-plugins/deoplete-jedi'
" Note: config below, since plug#end needs to happen before configuration

" Python virtualenv support
Plug 'jmcantrell/vim-virtualenv'
let g:airline#extensions#virtualenv#enabled = 1

call plug#end()

" Autocompete config
let g:deoplete#enable_at_startup = 1
" Use ALE and also some plugin 'foobar' as completion sources for all code.
call deoplete#custom#option('sources', {
\ '_': ['ale', 'jedi'],
\})
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" No backup/swap files
set nobackup 	                            " no backup files
set nowritebackup                           
set noswapfile 	                            " no swap files

" Color scheme
set background=dark
colorscheme palenight
let g:palenight_terminal_italics=1

" Enable filetype dependent configurations
:filetype on
:filetype plugin on
:filetype indent on

" Make tabs behave
autocmd FileType python set tabstop=4 softtabstop=4 shiftwidth=4 
autocmd FileType yaml set tabstop=2 softtabstop=2 shiftwidth=2 
set expandtab 
set smarttab autoindent

" Persist undo actions beyond a single session
set undodir=~/.nvim/undo
set undofile

" Use tab / shift+tab to navigate buffers
nnoremap <TAB> :bnext<CR>
nnoremap <S-TAB> :bprevious<CR>

" highlight 'long' lines (>= 80 symbols) in python files
augroup vimrc_autocmds
  autocmd!
  autocmd FileType python,rst,c,cpp highlight Excess ctermbg=DarkGrey guibg=Black
  autocmd FileType python,rst,c,cpp match Excess /\%81v.*/
  autocmd FileType python,rst,c,cpp set nowrap
  autocmd FileType python,rst,c,cpp set colorcolumn=88
augroup END

" Various
set number ruler
set showmatch
set enc=utf-8
set clipboard=unnamed
set splitright
set scrolloff=5
set sidescrolloff=5
set mouse=a
set laststatus=0
set updatetime=300
