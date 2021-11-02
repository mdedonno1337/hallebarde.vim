command! -nargs=? Hallebarde         call hallebarde#run(<args>)
command!          HallebardeAdd      call hallebarde#add()
command!          HallebardeEdit     call hallebarde#edit()
command!          HallebardePrevious call hallebarde#next(-1)
command!          HallebardeNext     call hallebarde#next(1)

