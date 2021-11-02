"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("g:loaded_hallebarde")
    finish
endif
let g:loaded_hallebarde = 1

if !exists("g:hallebarde_file")
    let g:hallebarde_file = ".hallebarde"
endif

if !exists("g:hallebarde_window_options")
    let g:hallebarde_window_options = { "width": 0.7, "height": 0.7 }
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Get and process the input data
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:get_file_list() abort
    if filereadable(g:hallebarde_file)
        return readfile(g:hallebarde_file)
    else
        return []
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sink for the selected file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:hallbarde_sink(file) abort
    " Check the validation of the fzf menu
    " With the use of the "sink*" option, the first entry is the way of
    " validation. If the user uses "enter" to validate the menu, the first
    " entry of this list will be an empty string.
    if a:file[0] == "ctrl-e"
        call hallebarde#edit()
        
    " Make the default action with the selected file
    else
        execute "edit " . a:file[1]
        
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run the fzf on the list of files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! hallebarde#run(count) abort
    " Get the content of the file and open the FZF dialog
    let l:list = s:get_file_list()
    
    " Empty file
    if len(l:list) == 0
        echohl MoreMsg
        echomsg "No files bookmarked in hallebard"
        echohl None
        
    else
        " Target directly a hallebarded file with a count prefix
        if a:count > 0
            if a:count > len(l:list)
                echohl ErrorMsg
                echomsg "There is less than " . a:count . " in the hallebard list (" . len(l:list) . ")"
                echohl None
                
            else
                call s:hallbarde_sink(["", l:list[a:count - 1]])
                
            endif
        
        " Only one entry
        elseif len(l:list) == 1
            call s:hallbarde_sink(["", l:list[0]])
        
        " Multiple entries
        else
            " Get the position of the current file in the list
            let l:matched = match(l:list, expand("%"))
            
            " If the list is only of length 2, and one of them is the
            " current file, the only usefull action is to switch to the
            " other file directly, without prompting the user (jump to the
            " current file is useless).
            if len(l:list) == 2 && l:matched != -1
                call s:hallbarde_sink(["", l:list[1-l:matched]])
                
            else
                " Prompt the use for the list of files
                call fzf#run({
                    \  "source":  l:list,
                    \  "sink*":   function("s:hallbarde_sink"),
                    \  "options": "-x --expect=ctrl-e --bind backward-eof:abort",
                    \  "window":  g:hallebarde_window_options
                    \ } )
            endif
    
        endif
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add the current file to the list of files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Add the current file to the list of bookmarks
function! hallebarde#add() abort
    let l:current_file = expand("%")
    let l:list = s:get_file_list()
    
    " Check if the file is already in the list
    if match(l:list, l:current_file) != -1
        echohl MoreMsg
        echomsg "This file is already present in the hallebarde list"
        echohl None
        
    " Add the file if not existing in the list
    else
        call writefile([l:current_file], g:hallebarde_file, "a")
        
        echohl MoreMsg
        echomsg l:current_file . " added to the hallebarde list"
        echohl None
        
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open the hallebarde configuration file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! hallebarde#edit() abort
    execute "edit " . g:hallebarde_file
endfunction

