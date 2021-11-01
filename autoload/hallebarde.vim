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
    return readfile(g:hallebarde_file)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sink for the selected file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:sink(file) abort
    if a:file[0] == "ctrl-e"
        call hallebarde#open()
    else
        execute "edit " . a:file[1]
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run the fzf on the list of files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! hallebarde#run() abort
    " Check if the hallebarde file is present on disk
    if !filereadable(g:hallebarde_file)
        echohl ErrorMsg
        echomsg "The " . g:hallebarde_file . " file does not exists"
        echohl None
        
    else
        " Get the content of the file and open the FZF dialog
        let l:list = s:get_file_list()
        
        if len(l:list) == 0
            echohl MoreMsg
            echomsg "The hallebarde file is empty"
            echohl None
            
        elseif len(l:list) == 1
            call s:sink(l:list[0])
        
        else
            call fzf#run({
                \  "source":  l:list,
                \  "sink*":   function('s:sink'),
                \  "options": "-x --expect=ctrl-e",
                \  "window":  g:hallebarde_window_options
                \ } )
    
        endif
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add the current file to the list of files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Add the current file to the list of bookmarks
function! hallebarde#add() abort
    let l:file_path = expand("%")
    
    " Check if the file is already in the list
    if filereadable(g:hallebarde_file) && match(readfile(g:hallebarde_file), l:file_path) != -1
        echohl MoreMsg
        echomsg "This file is already present in the hallebarde list"
        echohl None
        
    " Add the file if not existing in the list
    else
        call writefile([l:file_path], g:hallebarde_file, "a")
        echomsg l:file_path . " added to the hallebarde list"
        
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open the hallebarde configuration file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! hallebarde#open() abort
    execute "edit " . g:hallebarde_file
endfunction

