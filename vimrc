set fileformats=unix,dos
set nocompatible
filetype off

"" Configure Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Vundle package manager.
Plugin 'gmarik/Vundle.vim'

" Syntax checker integrations (rust, latex, C)
Plugin 'scrooloose/syntastic'

" NERDTree file browser (and git symbols)
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" Git gutter symbols to show changes.
Plugin 'airblade/vim-gitgutter'

" Delete surrounding brackets `ds)`.
Plugin 'tpope/vim-surround'

" Language-specific plugins.
Plugin 'fsharp/vim-fsharp'
Plugin 'lervag/vimtex'
Plugin 'rust-lang/rust.vim'
call vundle#end()

" Set MacVim options
if has("gui_running") && has("gui_macvim")
    set guifont=MonacoB:h13
    set lines=45
    set columns=87

    " Remove toolbars
    set guioptions-=r
    set guioptions-=L
endif

"" Configure solarized to work correctly
syntax enable
set background=dark
" Force enable italics in our modified version of solarized.vim
if $TERM_PROGRAM =~ "iTerm.app"
    set t_Co=16
    set t_ZH=[3m
    set t_ZR=[23m
    let g:solarized_italic=1
    let g:solarized_termcolors=16
endif
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
set colorcolumn=81

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
set statusline=%t%r%m\ %y[%{&ff}]%h\ %=\ %c,%l/%L\ %P

"" Set the filling characters for various gutters.
" stl   the status line of the current window (no filling, because it's visible)
" stlnc the status line of unfocussed windows ('-' for visibility)
" vert  the vertical window separator
set fillchars=stl:\ ,stlnc:-,vert:\|,fold:\ ,diff:-

"" Configure vimtex to do what we want.
" Don't open the quickfix window if there are only warnings.
let g:vimtex_quickfix_open_on_warning=0

" Set latexmk compiler options
" Puts build files (including the output) into './build' relative to the project
" root, disables continuous and callback compilation (though I might change the
" latter at some point), and disables synctex generation.
let g:vimtex_compiler_latexmk = {
    \ 'backend'    : 'process',
    \ 'background' : 1,
    \ 'build_dir'  : './build',
    \ 'callback'   : 0,
    \ 'continuous' : 0,
    \ 'executable' : 'latexmk',
    \ 'options'    : [
        \ '-pdf',
        \ '-verbose',
        \ '-file-line-error',
        \ '-synctex=0',
        \ '-interaction=nonstopmode',
    \ ],
\}

" Don't let vimtex autoindent things (it sucks at it).
let g:vimtex_indent_enabled=0

" Disable insert mode mappings.
let g:vimtex_imaps_leader='¬'
let g:vimtex_imaps_enabled=0

" Make vimtex recognise end-of-line comments when using 'gq'.
let g:vimtex_format_enabled=1

" Disable lacheck from checking latex documents.
let g:syntastic_tex_checkers=[]
let g:syntastic_python_checkers=[]

" Map ^n to toggle the NERDTree browser.
map <C-n> :NERDTreeToggle<CR>

" Set filetypes based on certain extensions
autocmd BufNewFile,BufRead *.gnuplot    set filetype=gnuplot
autocmd BufNewFile,BufRead *.tex        set filetype=tex

" Correct capital letter typos!
command Q q
command W w

" Set language for the spellcheck, but don't turn it on.
set spelllang=en_gb

" Command used by the Python syntax folder to produce the foldtext for docstring
" folds.
function PythonDocstringFoldText()
    return '    """docstring""" (' . string(v:foldend - v:foldstart + 1) . ')'
endfunction

filetype plugin indent on
syntax on
