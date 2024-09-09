set background=dark
colorscheme dogrun

set shortmess=atI
set cursorline
set ruler
set title
set showmode
set nocompatible
set cmdheight=2
set mouse=a
filetype plugin on
filetype indent on

if has("syntax")
	syntax on
endif

if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif

set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
