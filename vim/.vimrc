set nocompatible
set enc=utf-8
set fileformats=unix,dos
filetype off
syntax enable

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
Plugin 'davidhalter/jedi-vim'
Plugin 'dylon/vim-antlr'
Plugin 'Iron-E/vim-ungrammar'


" Both of these are for markdown.
Plugin 'godlygeek/tabular'
Plugin 'preservim/vim-markdown'

call vundle#end()
set rtp+=~/code/qasm/vim

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

"" Configure solarized to work correctly.  We default to `light`.
if $LC_TERMINAL =~ "iTerm2" && $ITERM_PROFILE == "Dark"
    set background=dark
else
    set background=light
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
set shiftwidth=0  " if 0, this uses tabstop instead so we de-duplicate.
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

"" Set the filling characters for various gutters.
" stl   the status line of the current window (no filling, because it's visible)
" stlnc the status line of unfocussed windows ('-' for visibility)
" vert  the vertical window separator
set fillchars=stl:\ ,stlnc:\─,vert:\│,fold:\ ,diff:\─

"" Configure vimtex to do what we want.

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
let NERDTreeIgnore=[
\   '^__pycache__$[[dir]]',
\   '.egg_info$[[dir]]',
\   '.so$[[file]]',
\]

" Setting 'ale_completion_enabled = 0' only disables automatic completion.  We can still trigger it
" manually.
let g:ale_completion_enabled = 0
let g:ale_set_balloons = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '──'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_linters = {
\   'cpp': ['clangd'],
\   'c': ['clangd'],
\   'sh': ['shellcheck'],
\   'tex': [],
\   'python': ['pylint', 'mypy'],
\   'pyrex': ['cython'],
\   'rust': ['analyzer'],
\}
let g:ale_linters_explicit = 1
let g:ale_linters_ignore = {
\   'cpp': ['clang-tidy'],
\}
let g:ale_fixers = {
\   'python': ['black'],
\   'rust': ['rustfmt'],
\   'c': ['clang-format'],
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_virtualtext_cursor = 'none'
map <Leader>af :ALEFix<CR>
map <Leader>aj :ALENextWrap<CR>
map <Leader>ak :ALEPreviousWrap<CR>
map <Leader>ad :ALEGoToDefinition<CR>
map <Leader>ag :ALEGoToTypeDefinition<CR>
map <Leader>al :ALEDetail<CR>
map <Leader>aw <plug>(ale_find_references)
map <Leader>ah <plug>(ale_hover)
map <Leader>ar :ALERename<CR>
map <Leader>aa :ALERepeatSelection<CR>
imap <silent> <C-C> <plug>(ale_complete)

augroup ALE
    autocmd User ALELintPost GitGutter
augroup END

let g:ale_cpp_clangd_options = '--background-index'
let g:ale_rust_analyzer_config = {
\    'checkOnSave': {"command": "clippy"},
\    'cargo': {"features": "all"},
\ }

" Leader mappings to work with git.
map <Leader>gb :Git blame<CR>

let g:rst_style = 1


" Markdown settings
let g:vim_markdown_fenced_languages = [
\   'c++=cpp',
\   'viml=vim',
\   'bash=sh',
\   'ini=dosini',
\   'qasm3=openqasm',
\   'qasm=openqasm',
\]
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_auto_insert_bullets = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" Set filetypes based on certain extensions
autocmd BufNewFile,BufRead *.gnuplot    set filetype=gnuplot

augroup latex
    autocmd BufNewFile,BufRead *.tex setlocal filetype=tex
    autocmd BufNewFile,BufRead *.tex filetype indent off
    autocmd BufNewFile,BufRead *.tex setlocal noautoindent
    autocmd BufNewFile,BufRead *.tex setlocal nosmartindent
    autocmd BufNewFile,BufRead *.tex setlocal indentexpr=""
    autocmd BufNewFile,BufRead *.tex setlocal textwidth=0
augroup END

augroup qiskit
    autocmd BufNewFile,BufRead **/qiskit/terra/*.{py,rs} setlocal textwidth=100
    autocmd BufNewFile,BufRead **/qiskit/terra/*.{py,rs} let b:ale_fix_on_save=1
augroup END

augroup csharp
    autocmd BufNewFile,BufRead *.cs setl textwidth=120
augroup END

augroup git
    autocmd BufNewFile,BufRead COMMIT_EDITMSG set spell
augroup END

" Autoset the coloured column to indivate the text width.
function! s:updateColorColumn()
    if &textwidth
        let &colorcolumn = &textwidth + 1
    else
        set colorcolumn=
    endif
endfunction

augroup colorcolumn
    autocmd BufNewFile,BufRead * call s:updateColorColumn()
    autocmd OptionSet textwidth call s:updateColorColumn()
augroup END

" Correct capital letter typos!
command Q q
command Qa qa
command W w

" Set up gitgutter and fugitive to work ok together.
"let g:gitgutter_map_keys = 0

" Set language for the spellcheck, but don't turn it on.
set spelllang=en_gb

" Options for the python syntax highlighting.
let g:python_no_builtin_highlight = 1
let g:python_space_error_highlight = 1

" Options to control the Rust plugin.
let g:rust_recommended_style = 0
let g:syntastic_rust_chckers = []

highlight link jsonCommentError Comment

" Make Jedi autocompletion opt-in.
let g:jedi#popup_on_dot = 0

" Guarantee that the shell in use is bash.
let g:is_bash = 1

filetype plugin indent on

map <F10> :echo ''
\ . 'highlight=' . synIDattr(synID(line("."),col("."),1),"name")
\ . ' transparent=' . synIDattr(synID(line("."),col("."),0),"name")
\ . ' base=' . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")<CR>
