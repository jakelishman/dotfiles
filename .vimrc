set fileformats=unix,dos
set nocompatible
filetype off

"" Configure Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/syntastic'
Plugin 'fsharp/vim-fsharp'
Plugin 'lervag/vimtex'

call vundle#end()

"" Configure solarized to work correctly
syntax enable
set background=dark
colorscheme solarized

"" Set file encoding
set fileencodings=utf-8

"" Set indenting to work correctly
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent

"" Enable line numbers (and relative numbers)
set number
set relativenumber
"" Highlight the current line.
set cursorline

"" Set smart casings in search functions
set ignorecase
set smartcase

"" Set text geometry and scrolling
set scrolloff=4
set textwidth=80

"" Remove both audible and visual bells
"" These must be set in _gvimrc too
set vb
set t_vb=

"" Show the command (e.g. `"ay2j`) as it's being typed
set showcmd

"" Make backspace behave sensibly
set backspace=indent,eol,start

"" Set statusline to be actually useful.
set laststatus=2
set statusline=%t%r%m\ %y[%{&ff}]%h%=%c,%l/%L\ %P

filetype plugin indent on
syntax on
