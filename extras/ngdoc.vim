syntax match  tsDocTags         contained /@\(link\|method[oO]f\|ngdoc\|ng[iI]nject\|restrict\)/ nextgroup=tsDocParam skipwhite
syntax match  tsDocType         contained "\%(#\|\$\|\w\|\"\|-\|\.\|:\|\/\)\+" nextgroup=tsDocParam skipwhite
syntax match  tsDocParam        contained "\%(#\|\$\|\w\|\"\|-\|\.\|:\|{\|}\|\/\|\[\|]\|=\)\+"
