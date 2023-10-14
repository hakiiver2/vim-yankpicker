let g:plugin_directory = $HOME . '/.yankpicker/'
let g:plugin_data_file_name = 'yanked_texts.txt'


function! yankpicker#showYankHistory() abort
    let lines = readfile(g:plugin_directory . g:plugin_data_file_name)
    let yank_history = lines
    call add(yank_history, getreg('+'))

    let max_len = max(map(copy(yank_history), 'len(v:val)'))

    let content = []
    for i in range(len(yank_history))
        let item = yank_history[i]
        call add(content, printf('%-'.max_len.'s : %s', item, i == len(yank_history) - 1 ? '(Clipboard)' : '('.(i+1).')'))
    endfor
    let g:yank_selected_index = 0



    let pos = getcurpos()
    let line = line('.')
    let col = col('.')

    let popup_id = popup_menu(content, {
                \ 'line': 'cursor-1',
                \ 'col': 'cursor',
                \ 'pos': 'botleft',
                \ 'filter': function('yankpicker#yankHistoryFilter'),
                \ 'padding': [0, 1, 0, 1],
                \ 'border': [],
                \ 'highlight': 'Pmenu',
                \ 'mapping': 0
                \ })
    let g:yank_history_popup_id = popup_id
    let g:yank_history = yank_history
    let g:content_length = len(content)
endfunction


function! yankpicker#yankHistoryFilter(id, key) abort
    if a:key == 'j' || a:key == 'k'
        if a:key == 'j'
            if g:yank_selected_index < g:content_length
                let g:yank_selected_index += 1
            endif
            if g:yank_selected_index == g:content_length - 1
                let g:yank_selected_index = 0
            endif
        endif
        if a:key == 'k'
            if g:yank_selected_index > 0
                let g:yank_selected_index -= 1
            endif
            if g:yank_selected_index == 0
                let g:yank_selected_index = g:content_length - 1
            endif
        endif
        call popup_filter_menu(a:id, a:key)
        return 1
    endif

    if a:key == "\<CR>"
        let selected = g:yank_history[g:yank_selected_index]
        execute 'normal! i'.selected
        call popup_close(a:id)
        return 1
    endif

    if a:key == "\<ESC>"
        call popup_close(a:id)
        return 0
    endif

    return 0
endfunction


function! yankpicker#saveYankedText()

    if !isdirectory(g:plugin_directory)
        call mkdir(g:plugin_directory, 'p') 
    endif
    if !filereadable(g:plugin_directory . g:plugin_data_file_name)
        call writefile([], g:plugin_directory . g:plugin_data_file_name)
    endif

    let lines = readfile(g:plugin_directory . g:plugin_data_file_name)

    let yanked_text_list = add(lines, getreg('"'))

    if len(yanked_text_list) > g:loaded_yankpicker_save_count
        let yanked_text_list = yanked_text_list[(len(yanked_text_list) - g:loaded_yankpicker_save_count) : (g:loaded_yankpicker_save_count)]
    endif

    call writefile(yanked_text_list, g:plugin_directory . g:plugin_data_file_name)
endfunction
