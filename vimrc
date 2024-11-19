autocmd FileType python,c,shell,bash,vim,cpp setlocal sw=4 ts=4 sts=4
autocmd FileType tex,lua setlocal sw=2 ts=2 sts=2

syntax on
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

set nowrap
set termguicolors
set fileformat=unix
set fileformats=unix
set number
set numberwidth=5
set signcolumn=number
set hidden
set ignorecase
set smartcase
set incsearch
set noerrorbells
set novisualbell
set mouse=a
set clipboard+=unnamedplus
set encoding=utf-8
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set list
set listchars=tab:►\ ,trail:·
set scrolloff=4
set tw=0
set indentexpr=
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
set laststatus=2
set autochdir
set cursorline
set completeopt=menu,menuone,noselect
set whichwrap+=<,>,h,l

let mapleader = " "
nnoremap <silent> jk <esc>
vnoremap <silent> jk <esc>
nnoremap <silent> H <s-up>
nnoremap <silent> L <s-down>
nnoremap <silent> <leader>v <c-v>
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> S :w<Return>
nnoremap <silent> Q :q<Return>
nnoremap <silent> ss :split<Return><C-w>w
nnoremap <silent> sv :vsplit<Return><C-w>w
nnoremap <silent> <Space> <C-w>w
nnoremap <silent> sq <C-w>q
nnoremap <silent> sh <C-w>h
nnoremap <silent> sk <C-w>k
nnoremap <silent> sj <C-w>j
nnoremap <silent> sl <C-w>l
nnoremap <silent> s<left> <C-w>5<
nnoremap <silent> s<right> <C-w>5>
nnoremap <silent> s<up> <C-w>5+
nnoremap <silent> s<down> <C-w>-
