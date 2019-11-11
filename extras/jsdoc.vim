"" syntax coloring for javadoc comments (HTML)
syntax region tsComment    matchgroup=tsComment start="/\*\s*"  end="\*/" contains=tsDocTags,tsCommentTodo,tsCvsTag,@tsHtml,@Spell fold

" tags containing a param
syntax match  tsDocTags         contained "@\(alias\|api\|augments\|borrows\|class\|constructs\|default\|defaultvalue\|emits\|exception\|exports\|extends\|fires\|kind\|link\|listens\|member\|member[oO]f\|mixes\|module\|name\|namespace\|requires\|template\|throws\|var\|variation\|version\)\>" skipwhite nextgroup=tsDocParam
" tags containing type and param
syntax match  tsDocTags         contained "@\(arg\|argument\|cfg\|param\|property\|prop\|typedef\)\>" skipwhite nextgroup=tsDocType
" tags containing type but no param
syntax match  tsDocTags         contained "@\(callback\|define\|enum\|external\|implements\|this\|type\|return\|returns\|yields\)\>" skipwhite nextgroup=tsDocTypeNoParam
" tags containing references
syntax match  tsDocTags         contained "@\(lends\|see\|tutorial\)\>" skipwhite nextgroup=tsDocSeeTag
" other tags (no extra syntax)
syntax match  tsDocTags         contained "@\(abstract\|access\|accessor\|async\|author\|classdesc\|constant\|const\|constructor\|copyright\|deprecated\|desc\|description\|dict\|event\|example\|file\|file[oO]verview\|final\|function\|global\|ignore\|inherit[dD]oc\|inner\|instance\|interface\|license\|localdoc\|method\|mixin\|nosideeffects\|override\|overview\|preserve\|private\|protected\|public\|readonly\|since\|static\|struct\|todo\|summary\|undocumented\|virtual\)\>"

syntax region tsDocType         contained matchgroup=tsDocTypeBrackets start="{" end="}" contains=tsDocTypeRecord oneline skipwhite nextgroup=tsDocParam
syntax match  tsDocType         contained "\%(#\|\"\|\w\|\.\|:\|\/\)\+" skipwhite nextgroup=tsDocParam
syntax region tsDocTypeRecord   contained start=/{/ end=/}/ contains=tsDocTypeRecord extend
syntax region tsDocTypeRecord   contained start=/\[/ end=/\]/ contains=tsDocTypeRecord extend
syntax region tsDocTypeNoParam  contained start="{" end="}" oneline
syntax match  tsDocTypeNoParam  contained "\%(#\|\"\|\w\|\.\|:\|\/\)\+"
syntax match  tsDocParam        contained "\%(#\|\$\|-\|'\|\"\|{.\{-}}\|\w\|\.\|:\|\/\|\[.\{-}]\|=\)\+"
syntax region tsDocSeeTag       contained matchgroup=tsDocSeeTag start="{" end="}" contains=tsDocTags

hi def link tsDocTags              Special
hi def link tsDocSeeTag            Function
hi def link tsDocType              Type
hi def link tsDocTypeBrackets      tsDocType
hi def link tsDocTypeRecord        tsDocType
hi def link tsDocTypeNoParam       Type
hi def link tsDocParam             Label
