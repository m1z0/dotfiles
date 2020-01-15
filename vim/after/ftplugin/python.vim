setlocal shiftwidth=4 
setlocal tabstop=4 
setlocal expandtab 

setlocal makeprg=python3\ -m\ py_compile\ %
setlocal errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

nnoremap <buffer> <F5> :w<Esc>Gmw:r!python3 -m unittest %:r.VimTest<CR>`.
