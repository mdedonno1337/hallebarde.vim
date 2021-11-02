command! -nargs=* Hallebarde         call hallebarde#run(<args>)
command!          HallebardeAdd      call hallebarde#add()
command!          HallebardeEdit     call hallebarde#edit()
command!          HallebardePrevious call hallebarde#previous(v:count)
command!          HallebardeNext     call hallebarde#next(v:count)

