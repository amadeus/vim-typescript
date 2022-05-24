" NOTE(amadeus): using set=ft which I think prevents weird bugs from assigning
" the old typescriptreact version
au FileType typescriptreact if &filetype!='typescript.tsx'|set ft=typescript.tsx|endif
