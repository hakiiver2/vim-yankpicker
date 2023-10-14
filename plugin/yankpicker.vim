if exists("g:loaded_yankpicker")
    finish
endif
let g:loaded_yankpicker = 1

if !exists("g:loaded_yankpicker_save_count")
    let g:loaded_yankpicker_save_count = 100
endif


inoremap <C-y> <C-o>:call yankpicker#showYankHistory()<CR>

augroup YankAutocommand
    autocmd!
    autocmd TextYankPost * call yankpicker#saveYankedText()
augroup END

