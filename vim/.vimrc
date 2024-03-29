set nocompatible
set enc=utf-8
set fileformats=unix,dos
filetype off

"" Configure Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Vundle package manager.
Plugin 'gmarik/Vundle.vim'

" Syntax checker integrations (rust, latex, C)
Plugin 'dense-analysis/ale'

" Git integration
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" NERDTree file browser (and git symbols)
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" Delete surrounding brackets `ds)`.
Plugin 'tpope/vim-surround'

" Language-specific plugins.
Plugin 'fsharp/vim-fsharp'
Plugin 'lervag/vimtex'
Plugin 'rust-lang/rust.vim'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'davidhalter/jedi-vim'
Plugin 'dylon/vim-antlr'
call vundle#end()

" Set leader keys.
let mapleader="\\"
let maplocalleader="\\"

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
if $TERM_PROGRAM =~ "iTerm.app" && $ITERM_PROFILE == "Light"
    set background=light
else
    set background=dark
endif
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

"" Set text geometry and scrolling
set scrolloff=4
set textwidth=80
set colorcolumn=81

"" Don't allow search to highlight or jump around as we type.
set nohlsearch
set noincsearch

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
"set statusline=%t%r%m\ %y[%{&ff}]%h\ %{fugitive#statusline()}\ %=\ %c,%l/%L\ %P

"" Set the filling characters for various gutters.
" stl   the status line of the current window (no filling, because it's visible)
" stlnc the status line of unfocussed windows ('-' for visibility)
" vert  the vertical window separator
set fillchars=stl:\ ,stlnc:_,vert:\│,fold:\ ,diff:\─

"" Configure vimtex to do what we want.
" Don't open the quickfix window if there are only warnings.
"let g:vimtex_quickfix_open_on_warning=0

" Set latexmk compiler options
" Puts build files (including the output) into './build' relative to the project
" root, disables continuous and callback compilation (though I might change the
" latter at some point), and disables synctex generation.
let g:vimtex_compiler_latexmk = {
    \ 'backend'    : 'process',
    \ 'background' : 1,
    \ 'callback'   : 0,
    \ 'continuous' : 0,
    \ 'executable' : 'latexmk',
    \ 'options'    : [
        \ '-pdf',
        \ '-verbose',
        \ '-synctex=0',
        \ '-interaction=nonstopmode',
        \ '-shell-escape',
    \ ],
\}

" I have my own tex.vim syntax file, so vimtex's additions don't work.
let g:vimtex_syntax_enabled=0

" Don't let vimtex autoindent things (it sucks at it).
let g:vimtex_indent_enabled=0
let g:latex_indent_enabled=0

" Use pplatex as a better log message parser.
let g:vimtex_quickfix_method="pplatex"

" Disable insert mode mappings.
let g:vimtex_imaps_leader='¬'
let g:vimtex_imaps_enabled=0

" Make vimtex recognise end-of-line comments when using 'gq'.
let g:vimtex_format_enabled=1

" Leader mappings for NERDTree
nmap <Leader>nn :NERDTreeToggle<CR>
nmap <Leader>no :NERDTreeFocus<CR>
nmap <Leader>nf :NERDTreeFind<CR>

if !exists("*LongLineMode")
    function LongLineMode()
        setlocal tw=0
        setlocal wrapmargin=0
    endfunction
endif
if !exists(":LLM")
    command LLM call LongLineMode()
endif

let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '──'
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = {
\   'cpp': ['clangd'],
\   'sh': ['shellcheck'],
\   'tex': [],
\   'python': ['pylint', 'pycodestyle', 'mypy'],
\   'pyrex': ['cython'],
\   'rust': ['rls'],
\}
let g:ale_fixers = {
\    'python': ['black'],
\}
map <Leader>af :ALEFix<CR>
map <Leader>aj :ALENext<CR>
map <Leader>ak :ALEPrevious<CR>
map <Leader>ad :ALEGoToDefinition<CR>
map <Leader>al :ALEDetail<CR>
map <Leader>ah :ALEHover<CR>
map <Leader>ar :ALEFindReferences<CR>
map <Leader>aa :ALERepeatSelection<CR>
augroup ALE
    autocmd User ALELintPost GitGutter
augroup END

" Leader mappings to work with git.
map <Leader>gb :Git blame<CR>

let g:rst_style = 1

" Set filetypes based on certain extensions
autocmd BufNewFile,BufRead *.gnuplot    set filetype=gnuplot

augroup latex
    autocmd BufNewFile,BufRead *.tex setlocal filetype=tex
    autocmd BufNewFile,BufRead *.tex filetype indent off
    autocmd BufNewFile,BufRead *.tex setlocal noautoindent
    autocmd BufNewFile,BufRead *.tex setlocal nosmartindent
    autocmd BufNewFile,BufRead *.tex setlocal indentexpr=""
    autocmd BufNewFile,BufRead *.tex call LongLineMode()
augroup END


" Set the colour column to be at the edge of the textwidth for the git commit
" message editor.
autocmd BufNewFile,BufRead COMMIT_EDITMSG let &colorcolumn=73

augroup csharp
    autocmd BufNewFile,BufRead *.cs setl colorcolumn=121
    autocmd BufNewFile,BufRead *.cs setl textwidth=120
augroup END

" Correct capital letter typos!
command Q q
command W w

" Set up gitgutter and fugitive to work ok together.
"let g:gitgutter_map_keys = 0

" Set language for the spellcheck, but don't turn it on.
set spelllang=en_gb

" Options for the python syntax highlighting.
let python_no_builtin_highlight = 1
let python_space_error_highlight = 1

" Rust syntax highlighting
highlight link rustCommentLineDoc Comment

highlight link jsonCommentError Comment

" Make Jedi autocompletion opt-in.
let g:jedi#popup_on_dot = 0

" Guarantee that the shell in use is bash.
let g:is_bash = 1

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

filetype plugin indent on
