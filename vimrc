call pathogen#runtime_append_all_bundles()
call pathogen#infect()
call pathogen#helptags()

" Not bothered about vi compatibility
" This must be first, because it changes other options as side effect
set nocompatible

runtime macros/matchit.vim

" more secure
set modelines=0

" Intuitive backspacing in insert mode
set backspace=indent,eol,start

" File-type highlighting and configuration.
" Run :filetype (without args) to see what you may have
" to turn on yourself, or just set them all to be sure.
syntax on
filetype on
filetype plugin on
filetype indent on

set smarttab
set autoindent
" copy the previous indentation on autoindenting
set copyindent
set showcmd
set showmode

" dont autofold on start or load
set foldlevelstart=99

" By default, pressing <TAB> in command mode will
" choose the first possible completion with no
" indication of how many others there might be.
" The following configuration lets you see what
" your other options are
set wildmenu

" To have the completion behave similarly to a
" shell, i.e. complete only up to the point of
" ambiguity (while still showing you what your
" options are), also add the following
set wildmode=list:longest

set history=10000 " increase command history

set undolevels=10000

" show the $ at the end of word changes etc
set cpoptions+=$

set number

" search highlights on, and dynamic searching
set hlsearch
set incsearch

" These two options, when set together, will
" make /-style searches case-sensitive only
" if there is a capital letter in the search
" expression. *-style searches continue to
" be consistently case-sensitive.
set ignorecase
set smartcase
set gdefault

" Vim is a little surly, beeping at you at
" every chance. You can either find a way to turn
" off the bell completely, or more usefully,
" make the bell visual:
" set visualbell

set cursorline
set ttyfast

" no old messy files
set nobackup
set noswapfile
set nowb

"determins how far the cursor has to be from the
"top or bottom for scrolling to start
"a large value effectively keeps the current
"line centered at all times
set scrolloff=9

set ruler

" allow hiding buffers with pending changes
set hidden

" defaults
set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2

" use multiple of shiftwidth when indenting with '<' and '>'
set shiftround

" set show matching parenthesis
set showmatch

" show the statusline all the time
set laststatus=2

" save undo history in file
set undofile
set undodir=~/.vim/undo

" Look for the file in the current directory,
" then south until you reach home.
"set tags=tags;~/
" add the tag file generated by ctag-bundler
set tags+=gems.tags
set tags+=~/zend.tags

" save on losing focus
"au FocusLost * :wa
" turned off to control when to trigger an autotest

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc,.vimrc source $MYVIMRC

" this conflicts with fugitive
" set wildignore+=*/.git/*,*/.hg/*,*/.svn/*

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Don't use Ex mode, use Q for formatting
map Q gq

" Fast saving
nmap <leader>w :w!<cr>

" clear search buffer when hitting return
nnoremap <leader><space> :nohlsearch<cr>

" dont use cursor keys!
nnoremap <up> <nop>
nnoremap <down> <nop>

" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" Use the arrows to something usefull
nnoremap <right> :bn<cr>
nnoremap <left> :bp<cr>
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" makes j and k work the way you expect
nnoremap j gj
nnoremap k gk

" make ; do the same thing as :
nnoremap ; :

" handle long lines
set nowrap
"set wrap
set textwidth=80

" map leader-W to strip white space
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" insert a hash rocket with <c-l>
imap <c-l> <space>=><space>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
" https://destroyallsoftware.com/file-navigation-in-vim.html
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Open files with <leader>f
map <leader>z :ClearCtrlPCache<cr>\|:CtrlP /usr/share/php/libzend-framework-php/<cr>
map <leader>f :CtrlP<cr>
map <leader>b :BuffergatorOpen<cr>

nnoremap <leader>vs :vs<cr>:bn<cr>
nnoremap <leader>hs :sp<cr>:bn<cr>
" ri.vim remaps
nnoremap  ,ri :call ri#OpenSearchPrompt(0)<cr> " horizontal split
nnoremap  ,RI :call ri#OpenSearchPrompt(1)<cr> " vertical split
nnoremap  ,RK :call ri#LookupNameUnderCursor()<cr> " keyword lookup

" Rails specific
" Show the current routes in the split
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! bundle exec rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . "_ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
map <leader>gR :call ShowRoutes()<cr>

" Edit or view files in same directory as current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
" map <leader>v :view %%

" reselect the text that was just pasted
nnoremap <leader>v V`]

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Run this file
let g:vroom_map_keys = 0
silent! map <unique> <Leader>t :VroomRunTestFile<CR>
silent! map <unique> <Leader>T :VroomRunNearestTest<CR>

silent! map <leader>p :% ! php_beautifier -s2 -l "IndentStyles(style=allman) ArrayNested() Lowercase() NewLines(before=T_CLASS:T_PUBLIC:T_PRIVATE:T_PROTECTED)"<CR>

if has("autocmd")

  augroup vimrcEx
    autocmd!

    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

  augroup END

  augroup FTOptions
    autocmd!

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Ruby
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    autocmd BufNewFile,BufRead Rakefile,*.rake,*.pill,Capfile,Gemfile,config.ru,Guardfile setfiletype ruby
    autocmd BufNewFile,BufRead *.scss.erb setfiletype scss.eruby
    autocmd BufNewFile,BufRead *.js.erb setfiletype javascript.eruby
    if has("folding")
      autocmd FileType ruby set foldenable
      autocmd FileType ruby set foldmethod=syntax
      " autocmd FileType ruby set nofoldenable
      " autocmd FileType ruby set foldlevel=1
      " autocmd FileType ruby set foldnestmax=2
      autocmd FileType ruby set foldtext=strpart(getline(v:foldstart),0,50).'\ ...\ '.substitute(getline(v:foldend),'^[\ #]*','','g').'\ '
    endif

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " PHP
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    autocmd BufRead *.phtml set filetype=php
    " highlights interpolated variables in sql strings and does sql-syntax highlighting. yay
    autocmd FileType php let php_sql_query=1
    " does exactly that. highlights html inside of php strings
    autocmd FileType php let php_htmlInStrings=1

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Other languages
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    autocmd BufNewFile,BufRead *.mustache set syntax=mustache
    autocmd BufNewFile,BufRead *.ol setfiletype lisp
    autocmd BufReadPost fugitive://* set bufhidden=delete
    autocmd BufNewFile,BufRead *.md,*.markdown,README,*.txt set spell
    autocmd BufNewFile,BufRead *.jst set syntax=eruby
    autocmd BufNewFile,BufRead *.jst.tpl set syntax=jst

    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Omnifunc
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    autocmd FileType ruby,eruby silent! setlocal omnifunc=rubycomplete#Complete
    autocmd FileType php silent! setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType javascript silent! setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html silent! setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css,scss silent! setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml silent! setlocal omnifunc=xmlcomplete#CompleteTags

  augroup END

endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set background=dark
set encoding=utf-8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bundles config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map for ack
let g:ackprg="ack-grep -H --nocolor --nogroup --column"
nnoremap <leader>a :Ack
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_mode_map = { 'mode': 'passive',
      \ 'active_filetypes': ['ruby', 'php'],
      \ 'passive_filetypes': [] }

let g:ctrlp_custom_ignore = {
      \ 'dir':  'tmp\|\.git$\|system$',
      \ 'file': '\.jpg$\|\.png$\|\.gif$',
      \ }
let g:ctrlp_max_height = 20

let g:buffergator_suppress_keymaps = 1
let g:vroom_detect_spec_helper = 1
let g:slime_target = "tmux"

" add trailing white space indicator to power line
call Pl#Theme#InsertSegment('ws_marker', 'after', 'lineinfo')
let g:Powerline_symbols = 'unicode'

" this is for the switch plugin
nnoremap - :Switch<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display after bundles
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

colorscheme base16-default

if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif

"  insert and remove blank lines in command mode
"  Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
" nnoremap <silent><C-J> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
" nnoremap <silent><C-K> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>
" nnoremap <silent><C-J> :set paste<CR>m`o<Esc>``:set nopaste<CR>
" nnoremap <silent><C-K> :set paste<CR>m`O<Esc>``:set nopaste<CR>
"pm to set pastemode on and mp to remove it
nnoremap <leader>pm :set paste<cr>
nnoremap <leader>mp :set paste!<cr>
nnoremap <leader>n :set number<cr>
nnoremap <leader>r :set relativenumber<cr>

set colorcolumn=80
