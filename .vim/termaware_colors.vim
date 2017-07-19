let g:termaware#colorschemes = {
\	'molokai' : {
\		'colorscheme' : 'molokai',
\	 	'background' : 'dark'
\	},
\	'solarized-dark' : {
\	 	'colorscheme' : 'solarized',
\	 	'background' : 'dark'
\	},
\	'solarized' : {
\	 	'colorscheme' : 'solarized',
\	 	'background' : 'light'
\	}
\}

let s:scheme=$VIM_TERMAWARE_COLORSCHEME
" echom 'env var scheme: ' . s:scheme

if strlen(s:scheme) != 0 
	let s:scheme = tolower(s:scheme)
	if has_key(g:termaware#colorschemes, s:scheme)
		let s:colorscheme = g:termaware#colorschemes[s:scheme].colorscheme
		let s:background = g:termaware#colorschemes[s:scheme].background

		let g:colors_name = s:colorscheme
		let background = s:background
		let g:termaware#colorschemeset = 1
	endif
endif