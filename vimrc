" machine specific settings in .private
if filereadable(glob("~/.private/vimrc.local"))
	source ~/.private/vimrc.local
endif

if &compatible
	set nocompatible               " Be iMproved
endif

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
	if (has("nvim"))
		"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
		let $NVIM_TUI_ENABLE_TRUE_COLOR=1
	endif
	"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
	"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
	" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
	if (has("termguicolors"))
		set termguicolors
	endif
endif

packadd! onedark.vim
packadd! neodark.vim
packadd! QFEnter
packadd! vimion
packadd! vim-jinja
packadd! vim-json
packadd! jedi-vim
packadd! vim-plist
"seems buggy . . .
"packadd! vim-cursorline-current
packadd! vim-prettyprint
" packadd! vim-one

packadd! vim-node

let g:neodark#background = '#282c34'
let g:neodark#solid_vertsplit = 1 " default: 0

colorscheme neodark
set background=dark

if has("gui_running")
	" gui settings!
	" colorscheme molokai
	syntax on
	set linespace=0
	set columnspace=0
	"colorscheme neodark "onedark
	"set background=dark
	" set guifont=Anonymous\ Pro:h12
	" set guifont=Source\ Code\ Pro\ Light:h11
	"set guifont=PT\ Mono:h11
	"set guifont=Inconsolata:h12
	set guifont=Iosevka\ Light:h11
	" don't display scroll bars
	set guioptions=egm
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
	"if !exists('g:termaware#colorschemeset')
	"let g:colors_name = 'molokai'
	"let background='dark'
	"endif
endif

filetype plugin indent on
syntax enable

" automatically leave insert mode after 'updatetime' milliseconds of inaction
"au CursorHoldI * stopinsert
"au InsertEnter * let updaterestore=&updatetime | set updatetime=60000
"au InsertLeave * let &updatetime=updaterestore

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
set cursorline                 
set relativenumber			 
if has("win32") || has("win64")  " characters to use for tab, cr, etc.
	set listchars=tab:->,trail:.,eol:$
else
	set listchars=tab:—»,trail:·,eol:¤
	let &sbr = nr2char(8618).' ' " Show at the beginning of wrapped lines.
end
"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus
" Set split separator to Unicode box drawing character
set fillchars+=vert:│
" Override color scheme to make split lines gray
highlight VertSplit ctermbg=NONE guibg=NONE ctermfg=Gray

"gui is faster - keep nicer line
if ! has('gui')
	set nocursorcolumn               " speed up syntax highlighting
	"set nocursorline                 " speed up syntax highlighting
	"set norelativenumber				 " show relative line numbers
endif

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

" complete options
"   . = current buffer
"   w = windows
"   b = buffers
"   u = unloaded buffers
"   t = tag completion
set complete=.,b,w,u,t

" file type specific indentation settings
autocmd Filetype ruby       setlocal shiftwidth=2 tabstop=2 expandtab  " ruby standardized on 2 spaces
autocmd Filetype rdoc       setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype eruby      setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype haml       setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype sass       setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype coffee     setlocal shiftwidth=2 tabstop=2 expandtab  " ...
autocmd Filetype css        setlocal shiftwidth=2 tabstop=2 expandtab  " ...
"moved to ftplugin
"autocmd Filetype python     setlocal shiftwidth=4 tabstop=4 expandtab  " python standardized on 4 spaces
autocmd Filetype javascript setlocal shiftwidth=4 tabstop=4 expandtab  " ...
autocmd Filetype perl		setlocal shiftwidth=4 tabstop=4 expandtab  " ...
autocmd Filetype yaml       setlocal shiftwidth=2 tabstop=2 expandtab  " ...

" force filetypes for specific extensions
autocmd BufNewFile,BufRead *.md   set filetype=markdown  " use markdown for *.md (not modula2)
autocmd BufNewFile,BufRead *.scss set filetype=css       " use css for *.css

" misc
set encoding=utf-8                     " use UTF-8 as encoding
set fileencoding=utf-8                 " use UTF-8 as encoding
set fileencodings=ucs-bom,utf-8,cp1251,sjis  " use UTF-8 as encoding
set fileformats=unix,dos,mac           " default file formats
set bomb
set ttyfast
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
let mapleader=" "
" Don’t add empty newlines at the end of files
"set binary
"set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/tmp/.vim/backups
set directory=~/tmp/.vim/swaps
if exists("&undodir")
	set undodir=~/tmp/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Store .netrwhist in tmp
let g:netrw_home="~/tmp/.vim"

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

nnoremap <leader>sv :source ~/.vimrc<CR>
nnoremap <leader>ev :edit ~/.vimrc<CR>
nnoremap <leader>oh :noh<CR>
nnoremap <leader>ya :%y+<CR>

inoremap jk <ESC>:w<CR>
inoremap kj <ESC>:w<CR>

" make c-u and c-w start a new change by default
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" setup folding (space bar toggles, including on visual selection)
nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
vnoremap <Space> zf

" mac specific - walk buffers
nnoremap <D-M-Right> :bnext<CR>
nnoremap <D-M-Left>  :bprev<CR>

" emacs/bash like keys for command line editing
" cnoremap <C-a> <Home>
" cnoremap <C-e> <End>
" cnoremap <C-k> <C-U>
" cnoremap <C-p> <Up>
" cnoremap <C-n> <Down>

" easier window bindings
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" create a vertical split on an open buffer
nnoremap <leader>w <C-w>v<C-w>l

" tab complete in insert mode
inoremap <TAB> <C-P>

nnoremap <F5> "=strftime('%Y-%m-%d')<CR>P
inoremap <F5> <C-R>=strftime('%Y-%m-%d')<CR>
nnoremap <F9> :make!<CR>
nnoremap <leader>mm :make<CR>
" deal with long lines
nnoremap j gj
nnoremap k gk
set display+=lastline

" change to directory of current file
nnoremap <leader>sp :cd %:p:h<CR>

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

" All buffers into their own tab
nnoremap <leader>bt :bufdo tab split<CR>

" Easier buffer switching (TAB Complete works)
nnoremap <leader>bb :ls<CR>:b 

"tabs
" nnormemap <DM-1> 1gt

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown

	autocmd FileType plantuml nnoremap <leader>pu :w<CR>:silent !g:plantuml_executable_script -o %:p:h %<CR>:redraw!<CR>
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

" vim-markdown
let g:vim_markdown_autowrite = 1
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1

" TODO: move to its own file
function! DisplayPreviewPlantuml()
	silent !clear
	silent "!" . g:plantuml_executable_script . " -o " . bufname("%")
	redraw!
endfunction

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
			\ 'template_path': '~/vimwiki/templates',
			\ 'css_name': 'style.css',
			\ 'template_default': 'default',
			\ 'syntax': 'markdown',
			\ 'ext': '.md',
			\ 'auto_export': 1,
			\ 'auto_toc': 1,
			\ 'auto_tags': 1,
			\ 'path_html': '~/vimwiki/html',
			\ 'custom_wiki2html': 'vimwiki_markdown',
			\ 'template_ext': '.tpl',
			\ 'list_margin': 0 }]

"autocmd FileType vimwiki call SetMarkdownOptions()

"function! SetMarkdownOptions()
"call VimwikiSet('syntax', 'markdown')
"call VimwikiSet('custom_wiki2html', 'vimwiki2html.rb')
"endfunction

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

" tagbar
nnoremap <leader>tt ::TagbarOpenAutoClose<CR>

" search for todo, action items in vimwiki
command! VWtodo call SearchTodoWiki()
function! SearchTodoWiki()
	let pwd = getcwd()
	execute 'cd' g:vimwiki_list[0].path
	execute 'grep!' '"\[ \]"'
	execute 'cd' pwd
endfunction

" this is experimental
" remove it or move it away from here
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
	let isfirst = 1
	let words = []
	for word in split(a:cmdline)
		if isfirst
			let isfirst = 0  " don't change first word (shell command)
		else
			if word[0] =~ '\v[%#<]'
				let word = expand(word)
			endif
			let word = shellescape(word, 1)
		endif
		call add(words, word)
	endfor
	let expanded_cmdline = join(words)
	botright new
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
	call setline(1, 'You entered:  ' . a:cmdline)
	call setline(2, 'Expanded to:  ' . expanded_cmdline)
	call append(line('$'), substitute(getline(2), '.', '=', 'g'))
	silent execute '$read !'. expanded_cmdline
	1
endfunction

" Hack to be able to not see the netrw buffers
" Remove set hidden
set nohidden

augroup netrw_buff_hidden_fix
	autocmd!

	"Set all non-netrw bufferst to buffhidden=hide
	autocmd BufWinEnter *
				\ if &ft != 'netrw'
				\| 	set bufhidden=hide
				\| endif
augroup end

function! s:BuffersList()
	let all = range(0, bufnr('$'))
	let res = []
	for b in all
		if buflisted(b)
			call add(res, bufname(b))
		endif
	endfor
	echom join(res)
	return res
endfunction

command! LB call s:BuffersList()

" diff the recovered file with its original
command! DiffOrig vert new | set bt=nofile | r ++edit # | diffthis | wincmd p | diffthis

function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command! DiffSaved call s:DiffWithSaved()

function! s:QF2Args()
	let x={} 
	for d in getqflist() 
		let x[bufname(d.bufnr)]=1 
	endfor
	exe 'args' join(keys(x))
endfunction
command! QF2Args call s:QF2Args()

nnoremap <leader>nj :RunNodeFile<CR>
command! RunNodeFile call s:RunNodeFile()
function! s:RunNodeFile() "{{{
	let l:params = getline(1)
	if (stridx(l:params, '//') == 0)
		let l:param_name_end=stridx(l:params, '=', 2)
		if (l:param_name_end != -1)
			let l:param_name = s:Strip(strpart(l:params, 2, l:param_name_end-2))
			"echo 'param_name = ' . l:param_name
			let l:param = s:Strip(strpart(l:params, l:param_name_end + 1))
			"echo 'param = ' . l:param

			let l:cmd = 'node ' .  expand("%") . ' ' . l:param
			echom 'Will execute "' . l:cmd . '"'
			let l:result = system(l:cmd)

			let l:RESULTS_BUFFER_NAME = "__NODE_RESULTS__"

			let l:results_buffer = bufwinnr(l:RESULTS_BUFFER_NAME)
			if (l:results_buffer != -1)
				execute l:results_buffer . " wincmd w"
			else
				execute "vsplit " . l:RESULTS_BUFFER_NAME
			endif

			normal! ggdG
			setlocal buftype=nofile

			call append(0, split(l:result, '\v\n'))
		endif
	endif
endfunction "}}}

function! s:Strip(input_string)
	return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

command! Marked  execute "!open -a 'Marked.app' '-g'" . " '" . expand("%:p") . "'"

function! s:get_visual_selection()
	" Why is this not a built-in Vim script function?!
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if len(lines) == 0
		return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction

function! s:UnescapeAndPrettyPrint() range
	" let text = s:get_visual_selection()
	"let lines = getbufline(bufnr("%"), a:firstline, a:lastline)
	"let text = join(lines, "\n")
	"let subbed = text
	"let subbed = substitute(subbed, '\\"', '\"', 'g')
	"let subbed = substitute(subbed, '{', '{\n', 'g')
	"let subbed = substitute(subbed, '[', '[\n', 'g')
	"let subbed = substitute(subbed, ',', ',\n', 'g')
	"let subbed = substitute(subbed, '}', '\n}', 'g')

	"let new_lines = split(subbed, '\n')

	"call deletebufline("%", a:firstline, a:lastline)
	"call append(a:firstline - 1, new_lines)

	"execute "normal V" . len(new_lines) . "k"
	execute "'<,'>s/" . '\\"' . '/"/'
	execute "'<,'>s/" . '"{/{/'
	execute "'<,'>s/" . '}"/}/'
	execute "normal V"
	execute "'<,'>!python -m json.tool"
	execute "normal ^]"
endfunction

command! -range UnescapeAndPrettyPrint <line1>,<line2>call s:UnescapeAndPrettyPrint()

function! s:BreakupIon() range
	let l:lines = getline(a:firstline, a:lastline)
	let l:text = join(l:lines, "\n")
	let l:text = substitute(l:text, '{', '{\n', 'g')
	let l:text = substitute(l:text, '[', '\n[\n', 'g')
	let l:text = substitute(l:text, '}\(,\?\)', '\n}\1\n', 'g')
	let l:text = substitute(l:text, ']\(,\?\)', '\n]\1\n', 'g')
	let l:text = substitute(l:text, ',\(\w\)', ',\n\1', 'g')
	let l:new_lines = split(l:text, '\n')
	call filter(l:new_lines, {line -> line !~ '/^\s*$/'})
	call deletebufline("%", a:firstline, a:lastline)
	call append(a:firstline - 1, l:new_lines)
	execute "g/^$/d"	
	execute "normal gg=G"
endfunction
command! -range=% SplitIon <line1>,<line2>call s:BreakupIon()


py3 << EOL
from amazon.ion import simpleion
def PyPrettyPrintIon(line1, line2):
	r = vim.current.buffer.range(int(line1),int(line2))
	source = '\n'.join(r) + '\n'
	ion = simpleion.loads(source, single_value=False)
	pretty_printed = simpleion.dumps(ion, sequence_as_stream=True, binary=False, indent='    ')
	pretty_printed = pretty_printed.split('\n')
	r[:] = pretty_printed
EOL
command! -range=% PySplitIon py3 PyPrettyPrintIon(<f-line1>, <f-line2>)
