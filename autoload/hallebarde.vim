if exists("g:loaded_hallebarde")
  finish
endif
let g:loaded_hallebarde = 1

if !exists("g:hallebarde_file")
  let g:hallebarde_file = ".hallebarde"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Get and process the input data
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:get_file_list() abort
    return readfile(g:hallebarde_file)
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run the fzf on the list of files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! hallebarde#run() abort
    if !filereadable(g:hallebarde_file)
        echohl ErrorMsg
        echomsg "The " . g:hallebarde_file . " file does not exists"
        echohl None
        
    else
        let l:list = s:get_file_list()
        
        if len(l:list) == 0
            echohl MoreMsg
            echomsg "The hallebarde file is empty"
            echohl None
            
        else
            call fzf#run({
                \  "source":  l:list,
                \  "sink":    "e",
                \  "options": "-x +s",
                \  "window":  { "width": 0.9, "height": 0.9 }
                \ } )
    
        endif
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add the current file to the list of files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! hallebarde#add() abort
    let l:file_path = expand("%")
    
    if filereadable(g:hallebarde_file) && match(readfile(g:hallebarde_file), l:file_path) != -1
        echohl MoreMsg
        echomsg "This file is already present in the hallebarde list"
        echohl None
        
    else
        call writefile([l:file_path], g:hallebarde_file, "a")
        echomsg l:file_path . " added to the hallebarde list"
        
    endif
endfunction

