if has("gui_running")
	" gui settings!
	colorscheme molokai
	set linespace=1
	set background=dark
else
	let g:molokai_original=0
	let g:rehash256 = 1
	let t_Co = 256
	let base16colorspace=256  " Access colors present in 256 colorspace

	" check for colorcheme based on the terminal colors
	" terminal could define VIM_TERMAWARE_COLORSCHEME that matches an entry inside
	" termaware_colors.vim
	let s:termaware_colorscheme_script = globpath(&rtp, 'termaware_colors.vim') 
	if filereadable(s:termaware_colorscheme_script)
		execute 'source' . s:termaware_colorscheme_script
	endif
	" set a default colorscheme if nothing above succeeded
	if !exists('g:termaware#colorschemeset')
		let g:colors_name = 'molokai'
		let background='dark'
	endif
endif

" Make Vim more useful
set nocompatible
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
set wildmode=list:longest,full
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/tmp/.vim/backups
set directory=~/tmp/.vim/swaps
if exists("&undodir")
	set undodir=~/tmp/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs as wide as two spaces
set tabstop=4
" TODO: make this per filetype
" Replace tab with spaces
set noexpandtab
" Make indentation be the same width as the tabs
set shiftwidth=4
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
"set nostartofline
" Show the cursor position
set ruler
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif
" Start scrolling three lines before the horizontal window border
set scrolloff=3
" Use hidden
set hidden

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor 
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

filetype plugin on

let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_cmd = 'CtrlPBuffer'

nnoremap <leader>sv :source ~/.vimrc<CR>
nnoremap <leader>ev :edit ~/.vimrc<CR>
nnoremap <leader>oh :noh<CR>
nnoremap <leader>ya :%y+<CR>

inoremap jk <ESC>:w<CR>
inoremap kj <ESC>:w<CR>

let g:vim_markdown_folding_disabled = 1

" TODO: move to its own file
function! DisplayPreviewPlantuml()
    silent !clear
    silent "!" . g:plantuml_executable_script . " -o " . bufname("%")
	redraw!
endfunction

" All buffers into their own tab
nnoremap <leader>bt :bufdo tab split<CR>
" Easier buffer switching (TAB Complete works)
nnoremap <space>b :ls<CR>:b 

autocmd FileType plantuml nnoremap <leader>pu :w<CR>:silent !g:plantuml_executable_script -o %:p:h %<CR>:redraw!<CR>

" vimwiki
let g:vimwiki_auto_chdir=1
let g:vimwiki_autowriteall=1
let g:vimwiki_conceallevel=0
let g:vimwiki_dir_link='index'
let g:vimwiki_hl_cb_checked=1
let g:vimwiki_hl_headers=1
let g:vimwiki_listsyms=' .oO✓'
let g:vimwiki_use_mouse=1
let g:vimwiki_list = [{'path': '~/vimwiki/',
  \ 'syntax': 'markdown',
  \ 'ext': '.md',
  \ 'auto_export': 1,
  \ 'auto_toc': 1,
  \ 'auto_tags': 1,
  \ 'path_html': '~/vimwiki/html',
  \ 'custom_wiki2html': 'vimwiki2html.rb',
  \ 'custom_wiki2html_args':''}]

autocmd FileType vimwiki call SetMarkdownOptions()

function! SetMarkdownOptions()
  call VimwikiSet('syntax', 'markdown')
  call VimwikiSet('custom_wiki2html', 'vimwiki2html.rb')
endfunction

function! Time(com, ...)
  let time = 0.0
  let numberOfTimes = a:0 ? a:1 : 50000
  for i in range(numberOfTimes + 1)
    let t = reltime()
    execute a:com
    let time += reltime(t)[1]
"    echo i.' / '.numberOfTimes
    "redraw
  endfor
  echo 'Average time: '.string(numberOfTimes / i)
endfunction