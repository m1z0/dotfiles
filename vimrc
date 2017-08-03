if &compatible
  set nocompatible               " Be iMproved
endif

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

filetype plugin indent on
syntax enable

" automatically leave insert mode after 'updatetime' milliseconds of inaction
au CursorHoldI * stopinsert
au InsertEnter * let updaterestore=&updatetime | set updatetime=60000
au InsertLeave * let &updatetime=updaterestore


" UI
set backspace=eol,start,indent   " make backspace better
set noedcompatible               " remove some old stuff
set ruler                        " show cursor position
set number                       " show line numbers
set scrolloff=3                  " scroll offset
set showcmd                      " show command keys
set noshowmatch                  " don't flash to show matching brackets

set visualbell                   " visual bell
set wak=no                       " disable win32 alt keys (so F10 can be remapped)
set hidden                       " deal with multiple buffers better
set history=1000                 " remember more than 20 commands
set wildmenu                     " enhanced file/command tab completion
set wildmode=list:longest,full   " set file/command completion mode
set title                        " set terminal title
set shortmess=actI               " clean up the 'Press ENTER ...' prompts
set cmdheight=2                  " command bar height (helps avoid Press ENTER prompts)
set whichwrap+=<,>,h,l           " add Left, Right, h, l to cursor line wrapping keys
set switchbuf=usetab             " when searching for a buffer to switch to, consider tabs
set completeopt=menu,menuone     " what to show on completions
set pumheight=10                 " completion window max size
set nocursorcolumn               " speed up syntax highlighting
set nocursorline                 " speed up syntax highlighting
set norelativenumber			 " speed up syntax highlighting
if has("win32") || has("win64")  " characters to use for tab, cr, etc.
    set listchars=tab:->,trail:.,eol:$
else
    set listchars=tab:—»,trail:·,eol:¤
    let &sbr = nr2char(8618).' ' " Show at the beginning of wrapped lines.
end
"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus

" searching
set gdefault   " default /g in substs
set hlsearch   " highlight matched text
set incsearch  " incremental search
set ignorecase " by default ignore case
set smartcase  " but, use case if any caps used
set wrapscan   " search wraps to top of file

" tagging
set tagrelative " tag file is relative to files it refers to
set tags=tags;/ " where to find tag files (search current dir up to /)
set tagstack    " use a tag stack

" indentation
"set autoindent                           " autoindent
"set cindent                              " stricter rules for C programs
"set smartindent                          " smarter autoindent
set noexpandtab  " use tab characters
set shiftwidth=4 " tab size
set tabstop=4    " tab size
set wrap         " wrap long lines

" file type specific indentation settings
autocmd Filetype ruby       setlocal shiftwidth=2 tabstop=2 expandtab  " ruby standardized on 2 spaces
autocmd Filetype rdoc       setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype eruby      setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype haml       setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype sass       setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype coffee     setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype css        setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype python     setlocal shiftwidth=4 tabstop=4 expandtab  " python standardized on 4 spaces
autocmd Filetype javascript setlocal shiftwidth=4 tabstop=4 expandtab  " ...

" force filetypes for specific extensions
autocmd BufNewFile,BufRead *.md   set filetype=markdown  " use markdown for *.md (not modula2)
autocmd BufNewFile,BufRead *.scss set filetype=css       " use css for *.css

" misc
set encoding=utf-8                     " use UTF-8 as encoding
set fileencoding=utf-8                 " use UTF-8 as encoding
set fileencodings=utf-8                " use UTF-8 as encoding
set fileformats=unix,dos,mac           " default file formats
set bomb
set ttyfast
set binary  " Don’t add empty newlines at the end of files
set path+=**                           " path for opening files
set backupdir=~/tmp//,/tmp//,/temp//,. " location of backup files
set directory=~/tmp//,/tmp//,/temp//,. " location of swap files

" set modifiable state of buffer to match readonly state (unless overridden
" manually)
function! UpdateModifiable()
    if &readonly
	setlocal nomodifiable
    else
	setlocal modifiable
    endif
endfunction
autocmd BufReadPost * call UpdateModifiable()


" Allow cursor keys in insert mode
set esckeys
" Use UTF-8 without BOM
" set encoding=utf-8 nobomb
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
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
"set nostartofline
" Show the current mode
set showmode

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

let g:ctrlp_working_path_mode   = 'rw'
let g:ctrlp_cmd                 = 'CtrlPBuffer'
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_show_hidden         = 1
let g:ctrlp_follow_symlinks     = 1

nnoremap <leader>sv :source ~/.vimrc<CR>
nnoremap <leader>ev :edit ~/.vimrc<CR>
nnoremap <leader>oh :noh<CR>
nnoremap <leader>ya :%y+<CR>

inoremap jk <ESC>:w<CR>
inoremap kj <ESC>:w<CR>

" vim-markdown
let g:vim_markdown_autowrite = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1

" setup folding (space bar toggles, including on visual selection)
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf

" emacs/bash like keys for command line editing
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-k> <C-U>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" easier window bindings
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" create a vertical split on an open buffer
nnoremap <leader>w <C-w>v<C-w>l

nnoremap j gj
nnoremap k gk

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
let g:vimwiki_list = [{
  \ 'path': '~/vimwiki/wiki',
  \ 'syntax': 'markdown',
  \ 'ext': '.md',
  \ 'auto_export': 1,
  \ 'auto_toc': 1,
  \ 'auto_tags': 1,
  \ 'path_html': '~/vimwiki/html',
  \ 'custom_wiki2html': 'vimwiki2html.rb',
  \ 'custom_wiki2html_args':'',
  \ 'list_margin': 0 }]

autocmd FileType vimwiki call SetMarkdownOptions()

function! SetMarkdownOptions()
  call VimwikiSet('syntax', 'markdown')
  call VimwikiSet('custom_wiki2html', 'vimwiki2html.rb')
endfunction

nnoremap <F5> "=strftime('%Y-%m-%d')<CR>P
inoremap <F5> <C-R>=strftime('%Y-%m-%d')<CR>

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

"gui is faster - keep nicer line
if has('gui')
	"set cursorcolumn               " speed up syntax highlighting
	set cursorline                 " speed up syntax highlighting
	set relativenumber				 " show relative line numbers
endif