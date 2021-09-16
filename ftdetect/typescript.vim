" NOTE(amadeus): using set=ft which I think prevents weird bugs from assigning
" the old typescriptreact version
au BufNewFile,BufRead *.tsx set ft=typescript.tsx
au BufNewFile,BufRead *.ts set ft=typescript
