" Vim configuration file "

" Enable mouse support "
set mouse=a

" Enable syntax highlighting "
syntax on

" Enable line numbers "
set number

" Enable highlight search pattern "
set hlsearch

" Enable smart case search sensitivity "
set ignorecase
set smartcase

" Indentation using spaces "
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent

" Show matching brackets () {} [] "
set showmatch

" Remove trailing whitespace from Python and Fortran files "
autocmd BufWritePre *.py,*.f90,*.f95,*.for :%s/\s\+$//e

" Enable true color support "
set termguicolors

" Set colorscheme "
colorscheme GruberDarker
highlight Normal ctermbg=NONE guibg=#11111B
