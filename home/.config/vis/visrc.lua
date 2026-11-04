require('vis')

vis.events.subscribe(vis.events.INIT, function()
    vis:command('set theme base16-darktooth')

    vis:command('map! normal j gj')
    vis:command('map! normal k gk')
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    vis:command('set autoindent on')
    vis:command('set colorcolumn 80')
    vis:command('set cursorline')
    vis:command('set number')
    vis:command('set relativenumbers')
end)
