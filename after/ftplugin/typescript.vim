" Vim filetype plugin file
" Language:     TypeScript
" Maintainer:   vim-typescript community
" URL:          https://github.com/amadeus/vim-typescript

setlocal iskeyword+=$ suffixesadd+=.js

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | setlocal iskeyword< suffixesadd<'
else
  let b:undo_ftplugin = 'setlocal iskeyword< suffixesadd<'
endif
