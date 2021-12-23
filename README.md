Store a list of files as bookmark in the root of the current project.
This allows to open easily a list of bookmarked files.

Same idea as `ThePrimeagen/harpoon`, but without the requirement of neovim 0.5 and harpoon (this plugin only uses `fzf.vim` and is written in vimscript, hence compatible with neovim 0.4 (and possibly vim, I dont know)).

Check the documentation for more details.

# Example of configuration

```
Plug 'mdedonno1337/hallebarde.vim'

" Open the menu, if needed
nnoremap <silent> <Leader><Leader> <CMD>Hallebarde<CR>

" Add a file to the list
nnoremap          <Leader>aa       <CMD>HallebardeAdd<CR>

" Remove a file from the list
nnoremap          <Leader>ar       <CMD>HallebardeRemove<CR>

" Edit the list of files
nnoremap <silent> <Leader>ae       <CMD>HallebardeEdit<CR>

" Open the previous files in the list
nnoremap <silent> <F2>             <CMD>HallebardePrevious<CR>
inoremap <silent> <F2>             <CMD>HallebardePrevious<CR>

" Open the next file in the list
nnoremap <silent> <F3>             <CMD>HallebardeNext<CR>
inoremap <silent> <F3>             <CMD>HallebardeNext<CR>

" Open the n-th file in the list
nnoremap <silent> <Leader>1        <CMD>Hallebarde(1)<CR>
nnoremap <silent> <Leader>2        <CMD>Hallebarde(2)<CR>
nnoremap <silent> <Leader>3        <CMD>Hallebarde(3)<CR>
nnoremap <silent> <Leader>4        <CMD>Hallebarde(4)<CR>
```

