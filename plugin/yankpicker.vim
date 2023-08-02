if exists("g:loaded_yankpicker")
    finish
endif
let g:loaded_yankpicker = 1

" inoremap <C-y> <C-o>:call <SID>yankpicker#showYankHistory()<CR>
inoremap <C-y> <C-o>:call yankpicker#showYankHistory()<CR>
