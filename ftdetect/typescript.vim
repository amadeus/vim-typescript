" NOTE(amadeus): using set=ft which I think prevents weird bugs from assigning
" the old typescriptreact version
au BufNewFile,BufRead *.tsx if &filetype!='typescript.tsx'|set ft=typescript.tsx|endif
au BufNewFile,BufRead *.ts if $filetype!='typescript'|set ft=typescript|endif
