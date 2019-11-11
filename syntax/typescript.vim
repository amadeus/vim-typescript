" Vim syntax file
" Language:     TypeScript
" Maintainer:   vim-typescript community
" URL:          https://github.com/amadeus/vim-typescript

if !exists('main_syntax')
  if v:version < 600
    syntax clear
  elseif exists('b:current_syntax')
    finish
  endif
  let main_syntax = 'typescript'
endif

" Dollar sign is permitted anywhere in an identifier
if (v:version > 704 || v:version == 704 && has('patch1142')) && main_syntax ==# 'typescript'
  syntax iskeyword @,48-57,_,192-255,$
else
  setlocal iskeyword+=$
endif

syntax sync fromstart
" TODO: Figure out what type of casing I need
" syntax case ignore
syntax case match

syntax match   tsNoise          /[:,;]/
syntax match   tsDot            /\./ skipwhite skipempty nextgroup=tsObjectProp,tsFuncCall,tsPrototype,tsTaggedTemplate
syntax match   tsObjectProp     contained /\<\K\k*/
syntax match   tsFuncCall       /\<\K\k*\ze\s*(/
syntax match   tsParensError    /[)}\]]/

" Program Keywords
syntax keyword tsStorageClass   const var let skipwhite skipempty nextgroup=tsDestructuringBlock,tsDestructuringArray,tsVariableDef
syntax match   tsVariableDef    contained /\<\K\k*/ skipwhite skipempty nextgroup=tsFlowDefinition
syntax keyword tsOperatorKeyword delete instanceof typeof void new in of skipwhite skipempty nextgroup=@tsExpression
syntax match   tsOperator       "[-!|&+<>=%/*~^]" skipwhite skipempty nextgroup=@tsExpression
syntax match   tsOperator       /::/ skipwhite skipempty nextgroup=@tsExpression
syntax keyword tsBooleanTrue    true
syntax keyword tsBooleanFalse   false

" Modules
syntax keyword tsImport                       import skipwhite skipempty nextgroup=tsModuleAsterisk,tsModuleKeyword,tsModuleGroup,tsFlowImportType
syntax keyword tsExport                       export skipwhite skipempty nextgroup=@tsAll,tsModuleGroup,tsExportDefault,tsModuleAsterisk,tsModuleKeyword,tsFlowTypeStatement
syntax match   tsModuleKeyword      contained /\<\K\k*/ skipwhite skipempty nextgroup=tsModuleAs,tsFrom,tsModuleComma
syntax keyword tsExportDefault      contained default skipwhite skipempty nextgroup=@tsExpression
syntax keyword tsExportDefaultGroup contained default skipwhite skipempty nextgroup=tsModuleAs,tsFrom,tsModuleComma
syntax match   tsModuleAsterisk     contained /\*/ skipwhite skipempty nextgroup=tsModuleKeyword,tsModuleAs,tsFrom
syntax keyword tsModuleAs           contained as skipwhite skipempty nextgroup=tsModuleKeyword,tsExportDefaultGroup
syntax keyword tsFrom               contained from skipwhite skipempty nextgroup=tsString
syntax match   tsModuleComma        contained /,/ skipwhite skipempty nextgroup=tsModuleKeyword,tsModuleAsterisk,tsModuleGroup,tsFlowTypeKeyword

" Strings, Templates, Numbers
syntax region  tsString           start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+  contains=tsSpecial,@Spell extend
syntax region  tsTemplateString   start=+`+  skip=+\\`+  end=+`+     contains=tsTemplateExpression,tsSpecial,@Spell extend
syntax match   tsTaggedTemplate   /\<\K\k*\ze`/ nextgroup=tsTemplateString
syntax match   tsNumber           /\c\<\%(\d\+\%(e[+-]\=\d\+\)\=\|0b[01]\+\|0o\o\+\|0x\x\+\)\>/
syntax keyword tsNumber           Infinity
syntax match   tsFloat            /\c\<\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%(e[+-]\=\d\+\)\=\>/

" Regular Expressions
syntax match   tsSpecial            contained "\v\\%(x\x\x|u%(\x{4}|\{\x{4,5}})|c\u|.)"
syntax region  tsTemplateExpression contained matchgroup=tsTemplateBraces start=+${+ end=+}+ contains=@tsExpression keepend
syntax region  tsRegexpCharClass    contained start=+\[+ skip=+\\.+ end=+\]+ contains=tsSpecial extend
syntax match   tsRegexpBoundary     contained "\v\c[$^]|\\b"
syntax match   tsRegexpBackRef      contained "\v\\[1-9]\d*"
syntax match   tsRegexpQuantifier   contained "\v[^\\]%([?*+]|\{\d+%(,\d*)?})\??"lc=1
syntax match   tsRegexpOr           contained "|"
syntax match   tsRegexpMod          contained "\v\(\?[:=!>]"lc=1
syntax region  tsRegexpGroup        contained start="[^\\]("lc=1 skip="\\.\|\[\(\\.\|[^]]\+\)\]" end=")" contains=tsRegexpCharClass,@tsRegexpSpecial keepend
syntax region  tsRegexpString   start=+\%(\%(\<return\|\<typeof\|\_[^)\]'"[:blank:][:alnum:]_$]\)\s*\)\@<=/\ze[^*/]+ skip=+\\.\|\[[^]]\{1,}\]+ end=+/[gimyus]\{,6}+ contains=tsRegexpCharClass,tsRegexpGroup,@tsRegexpSpecial oneline keepend extend
syntax cluster tsRegexpSpecial    contains=tsSpecial,tsRegexpBoundary,tsRegexpBackRef,tsRegexpQuantifier,tsRegexpOr,tsRegexpMod

" Objects
syntax match   tsObjectShorthandProp contained /\<\k*\ze\s*/ skipwhite skipempty nextgroup=tsObjectSeparator
syntax match   tsObjectKey         contained /\<\k*\ze\s*:/ contains=tsFunctionKey skipwhite skipempty nextgroup=tsObjectValue
syntax region  tsObjectKeyString   contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=tsSpecial,@Spell skipwhite skipempty nextgroup=tsObjectValue
syntax region  tsObjectKeyComputed contained matchgroup=tsBrackets start=/\[/ end=/]/ contains=@tsExpression skipwhite skipempty nextgroup=tsObjectValue,tsFuncArgs extend
syntax match   tsObjectSeparator   contained /,/
syntax region  tsObjectValue       contained matchgroup=tsObjectColon start=/:/ end=/[,}]\@=/ contains=@tsExpression extend
syntax match   tsObjectFuncName    contained /\<\K\k*\ze\_s*(/ skipwhite skipempty nextgroup=tsFuncArgs
syntax match   tsFunctionKey       contained /\<\K\k*\ze\s*:\s*function\>/
syntax match   tsObjectMethodType  contained /\<[gs]et\ze\s\+\K\k*/ skipwhite skipempty nextgroup=tsObjectFuncName
syntax region  tsObjectStringKey   contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=tsSpecial,@Spell extend skipwhite skipempty nextgroup=tsFuncArgs,tsObjectValue

exe 'syntax keyword tsNull      null             '.(exists('g:typescript_conceal_null')      ? 'conceal cchar='.g:typescript_conceal_null       : '')
exe 'syntax keyword tsReturn    return contained '.(exists('g:typescript_conceal_return')    ? 'conceal cchar='.g:typescript_conceal_return     : '').' skipwhite nextgroup=@tsExpression'
exe 'syntax keyword tsUndefined undefined        '.(exists('g:typescript_conceal_undefined') ? 'conceal cchar='.g:typescript_conceal_undefined  : '')
exe 'syntax keyword tsNan       NaN              '.(exists('g:typescript_conceal_NaN')       ? 'conceal cchar='.g:typescript_conceal_NaN        : '')
exe 'syntax keyword tsPrototype prototype        '.(exists('g:typescript_conceal_prototype') ? 'conceal cchar='.g:typescript_conceal_prototype  : '')
exe 'syntax keyword tsThis      this             '.(exists('g:typescript_conceal_this')      ? 'conceal cchar='.g:typescript_conceal_this       : '')
exe 'syntax keyword tsSuper     super  contained '.(exists('g:typescript_conceal_super')     ? 'conceal cchar='.g:typescript_conceal_super      : '')

" Statement Keywords
syntax match   tsBlockLabel              /\<\K\k*\s*::\@!/    contains=tsNoise skipwhite skipempty nextgroup=tsBlock
syntax match   tsBlockLabelKey contained /\<\K\k*\ze\s*\_[;]/
syntax keyword tsStatement     contained with yield debugger
syntax keyword tsStatement     contained break continue skipwhite skipempty nextgroup=tsBlockLabelKey
syntax keyword tsConditional            if              skipwhite skipempty nextgroup=tsParenIfElse
syntax keyword tsConditional            else            skipwhite skipempty nextgroup=tsCommentIfElse,tsIfElseBlock
syntax keyword tsConditional            switch          skipwhite skipempty nextgroup=tsParenSwitch
syntax keyword tsRepeat                 while for       skipwhite skipempty nextgroup=tsParenRepeat,tsForAwait
syntax keyword tsDo                     do              skipwhite skipempty nextgroup=tsRepeatBlock
syntax region  tsSwitchCase   contained matchgroup=tsLabel start=/\<\%(case\|default\)\>/ end=/:\@=/ contains=@tsExpression,tsLabel skipwhite skipempty nextgroup=tsSwitchColon keepend
syntax keyword tsTry                    try             skipwhite skipempty nextgroup=tsTryCatchBlock
syntax keyword tsFinally      contained finally         skipwhite skipempty nextgroup=tsFinallyBlock
syntax keyword tsCatch        contained catch           skipwhite skipempty nextgroup=tsParenCatch
syntax keyword tsException              throw
syntax keyword tsAsyncKeyword           async await
syntax match   tsSwitchColon   contained /::\@!/        skipwhite skipempty nextgroup=tsSwitchBlock

" Keywords
syntax keyword tsGlobalObjects      Array Boolean Date Function Iterator Number Object Symbol Map WeakMap Set WeakSet RegExp String Proxy Promise Buffer ParallelArray ArrayBuffer DataView Float32Array Float64Array Int16Array Int32Array Int8Array Uint16Array Uint32Array Uint8Array Uint8ClampedArray JSON Math console document window Intl Collator DateTimeFormat NumberFormat fetch
syntax keyword tsGlobalNodeObjects  module exports global process __dirname __filename
syntax match   tsGlobalNodeObjects  /\<require\>/ containedin=tsFuncCall
syntax keyword tsExceptions         Error EvalError InternalError RangeError ReferenceError StopIteration SyntaxError TypeError URIError
syntax keyword tsBuiltins           decodeURI decodeURIComponent encodeURI encodeURIComponent eval isFinite isNaN parseFloat parseInt uneval
" DISCUSS: How imporant is this, really? Perhaps it should be linked to an error because I assume the keywords are reserved?
syntax keyword tsFutureKeys         abstract enum int short boolean interface byte long char final native synchronized float package throws goto private transient implements protected volatile double public

" DISCUSS: Should we really be matching stuff like this?
" DOM2 Objects
syntax keyword tsGlobalObjects  DOMImplementation DocumentFragment Document Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction
syntax keyword tsExceptions     DOMException

" DISCUSS: Should we really be matching stuff like this?
" DOM2 CONSTANT
syntax keyword tsDomErrNo       INDEX_SIZE_ERR DOMSTRING_SIZE_ERR HIERARCHY_REQUEST_ERR WRONG_DOCUMENT_ERR INVALID_CHARACTER_ERR NO_DATA_ALLOWED_ERR NO_MODIFICATION_ALLOWED_ERR NOT_FOUND_ERR NOT_SUPPORTED_ERR INUSE_ATTRIBUTE_ERR INVALID_STATE_ERR SYNTAX_ERR INVALID_MODIFICATION_ERR NAMESPACE_ERR INVALID_ACCESS_ERR
syntax keyword tsDomNodeConsts  ELEMENT_NODE ATTRIBUTE_NODE TEXT_NODE CDATA_SECTION_NODE ENTITY_REFERENCE_NODE ENTITY_NODE PROCESSING_INSTRUCTION_NODE COMMENT_NODE DOCUMENT_NODE DOCUMENT_TYPE_NODE DOCUMENT_FRAGMENT_NODE NOTATION_NODE

" DISCUSS: Should we really be special matching on these props?
" HTML events and internal variables
syntax keyword tsHtmlEvents     onblur onclick oncontextmenu ondblclick onfocus onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup onresize

" Code blocks
syntax region  tsBracket                      matchgroup=tsBrackets            start=/\[/ end=/\]/ contains=@tsExpression,tsSpreadExpression extend fold
syntax region  tsParen                        matchgroup=tsParens              start=/(/  end=/)/  contains=@tsExpression extend fold nextgroup=tsFlowDefinition
syntax region  tsParenDecorator     contained matchgroup=tsParensDecorator     start=/(/  end=/)/  contains=@tsAll extend fold
syntax region  tsParenIfElse        contained matchgroup=tsParensIfElse        start=/(/  end=/)/  contains=@tsAll skipwhite skipempty nextgroup=tsCommentIfElse,tsIfElseBlock,tsReturn extend fold
syntax region  tsParenRepeat        contained matchgroup=tsParensRepeat        start=/(/  end=/)/  contains=@tsAll skipwhite skipempty nextgroup=tsCommentRepeat,tsRepeatBlock,tsReturn extend fold
syntax region  tsParenSwitch        contained matchgroup=tsParensSwitch        start=/(/  end=/)/  contains=@tsAll skipwhite skipempty nextgroup=tsSwitchBlock extend fold
syntax region  tsParenCatch         contained matchgroup=tsParensCatch         start=/(/  end=/)/  skipwhite skipempty nextgroup=tsTryCatchBlock extend fold
syntax region  tsFuncArgs           contained matchgroup=tsFuncParens          start=/(/  end=/)/  contains=tsFuncArgCommas,tsComment,tsFuncArgExpression,tsDestructuringBlock,tsDestructuringArray,tsRestExpression,tsFlowArgumentDef skipwhite skipempty nextgroup=tsCommentFunction,tsFuncBlock,tsFlowReturn extend fold
syntax region  tsClassBlock         contained matchgroup=tsClassBraces         start=/{/  end=/}/  contains=tsClassFuncName,tsClassMethodType,tsArrowFunction,tsArrowFuncArgs,tsComment,tsGenerator,tsDecorator,tsClassProperty,tsClassPropertyComputed,tsClassStringKey,tsAsyncKeyword,tsNoise extend fold
syntax region  tsFuncBlock          contained matchgroup=tsFuncBraces          start=/{/  end=/}/  contains=@tsAll,tsBlock extend fold
syntax region  tsIfElseBlock        contained matchgroup=tsIfElseBraces        start=/{/  end=/}/  contains=@tsAll,tsBlock extend fold
syntax region  tsTryCatchBlock      contained matchgroup=tsTryCatchBraces      start=/{/  end=/}/  contains=@tsAll,tsBlock skipwhite skipempty nextgroup=tsCatch,tsFinally extend fold
syntax region  tsFinallyBlock       contained matchgroup=tsFinallyBraces       start=/{/  end=/}/  contains=@tsAll,tsBlock extend fold
syntax region  tsSwitchBlock        contained matchgroup=tsSwitchBraces        start=/{/  end=/}/  contains=@tsAll,tsBlock,tsSwitchCase extend fold
syntax region  tsRepeatBlock        contained matchgroup=tsRepeatBraces        start=/{/  end=/}/  contains=@tsAll,tsBlock extend fold
syntax region  tsDestructuringBlock contained matchgroup=tsDestructuringBraces start=/{/  end=/}/  contains=tsDestructuringProperty,tsDestructuringAssignment,tsDestructuringNoise,tsDestructuringPropertyComputed,tsSpreadExpression,tsComment nextgroup=tsFlowDefinition extend fold
syntax region  tsDestructuringArray contained matchgroup=tsDestructuringBraces start=/\[/ end=/\]/ contains=tsDestructuringPropertyValue,tsDestructuringNoise,tsDestructuringProperty,tsSpreadExpression,tsDestructuringBlock,tsDestructuringArray,tsComment nextgroup=tsFlowDefinition extend fold
syntax region  tsObject             contained matchgroup=tsObjectBraces        start=/{/  end=/}/  contains=tsObjectKey,tsObjectKeyString,tsObjectKeyComputed,tsObjectShorthandProp,tsObjectSeparator,tsObjectFuncName,tsObjectMethodType,tsGenerator,tsComment,tsObjectStringKey,tsSpreadExpression,tsDecorator,tsAsyncKeyword extend fold
syntax region  tsBlock                        matchgroup=tsBraces              start=/{/  end=/}/  contains=@tsAll,tsSpreadExpression extend fold
syntax region  tsModuleGroup        contained matchgroup=tsModuleBraces        start=/{/ end=/}/   contains=tsModuleKeyword,tsModuleComma,tsModuleAs,tsComment,tsFlowTypeKeyword skipwhite skipempty nextgroup=tsFrom fold
syntax region  tsSpreadExpression   contained matchgroup=tsSpreadOperator      start=/\.\.\./ end=/[,}\]]\@=/ contains=@tsExpression
syntax region  tsRestExpression     contained matchgroup=tsRestOperator        start=/\.\.\./ end=/[,)]\@=/
syntax region  tsTernaryIf                    matchgroup=tsTernaryIfOperator   start=/?:\@!/  end=/\%(:\|}\@=\)/  contains=@tsExpression extend skipwhite skipempty nextgroup=@tsExpression
" These must occur here or they will be override by tsTernaryIf
syntax match   tsOperator           /?\.\ze\_D/
syntax match   tsOperator           /??/ skipwhite skipempty nextgroup=@tsExpression

syntax match   tsGenerator            contained /\*/ skipwhite skipempty nextgroup=tsFuncName,tsFuncArgs,tsFlowFunctionGroup
syntax match   tsFuncName             contained /\<\K\k*/ skipwhite skipempty nextgroup=tsFuncArgs,tsFlowFunctionGeneric
syntax region  tsFuncArgExpression    contained matchgroup=tsFuncArgOperator start=/=/ end=/[,)]\@=/ contains=@tsExpression extend
syntax match   tsFuncArgCommas        contained ','
syntax keyword tsArguments            contained arguments
syntax keyword tsForAwait             contained await skipwhite skipempty nextgroup=tsParenRepeat

" Matches a single keyword argument with no parens
syntax match   tsArrowFuncArgs  /\<\K\k*\ze\s*=>/ skipwhite contains=tsFuncArgs skipwhite skipempty nextgroup=tsArrowFunction extend
" Matches a series of arguments surrounded in parens
syntax match   tsArrowFuncArgs  /([^()]*)\ze\s*=>/ contains=tsFuncArgs skipempty skipwhite nextgroup=tsArrowFunction extend

exe 'syntax match tsFunction /\<function\>/      skipwhite skipempty nextgroup=tsGenerator,tsFuncName,tsFuncArgs,tsFlowFunctionGroup skipwhite '.(exists('g:typescript_conceal_function') ? 'conceal cchar='.g:typescript_conceal_function : '')
exe 'syntax match tsArrowFunction /=>/           skipwhite skipempty nextgroup=tsFuncBlock,tsCommentFunction '.(exists('g:typescript_conceal_arrow_function') ? 'conceal cchar='.g:typescript_conceal_arrow_function : '')
exe 'syntax match tsArrowFunction /()\ze\s*=>/   skipwhite skipempty nextgroup=tsArrowFunction '.(exists('g:typescript_conceal_noarg_arrow_function') ? 'conceal cchar='.g:typescript_conceal_noarg_arrow_function : '')
exe 'syntax match tsArrowFunction /_\ze\s*=>/    skipwhite skipempty nextgroup=tsArrowFunction '.(exists('g:typescript_conceal_underscore_arrow_function') ? 'conceal cchar='.g:typescript_conceal_underscore_arrow_function : '')

" Classes
syntax keyword tsClassKeyword           contained class
syntax keyword tsExtendsKeyword         contained extends skipwhite skipempty nextgroup=@tsExpression
syntax match   tsClassNoise             contained /\./
syntax match   tsClassFuncName          contained /\<\K\k*\ze\s*[(<]/ skipwhite skipempty nextgroup=tsFuncArgs,tsFlowClassFunctionGroup
syntax match   tsClassMethodType        contained /\<\%([gs]et\|static\)\ze\s\+\K\k*/ skipwhite skipempty nextgroup=tsAsyncKeyword,tsClassFuncName,tsClassProperty
syntax region  tsClassDefinition                  start=/\<class\>/ end=/\(\<extends\>\s\+\)\@<!{\@=/ contains=tsClassKeyword,tsExtendsKeyword,tsClassNoise,@tsExpression,tsFlowClassGroup skipwhite skipempty nextgroup=tsCommentClass,tsClassBlock,tsFlowClassGroup
syntax match   tsClassProperty          contained /\<\K\k*\ze\s*=/ skipwhite skipempty nextgroup=tsClassValue,tsFlowClassDef
syntax region  tsClassValue             contained start=/=/ end=/\_[;}]\@=/ contains=@tsExpression
syntax region  tsClassPropertyComputed  contained matchgroup=tsBrackets start=/\[/ end=/]/ contains=@tsExpression skipwhite skipempty nextgroup=tsFuncArgs,tsClassValue extend
syntax region  tsClassStringKey         contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=tsSpecial,@Spell extend skipwhite skipempty nextgroup=tsFuncArgs

" Destructuring
syntax match   tsDestructuringPropertyValue     contained /\k\+/
syntax match   tsDestructuringProperty          contained /\k\+\ze\s*=/ skipwhite skipempty nextgroup=tsDestructuringValue
syntax match   tsDestructuringAssignment        contained /\k\+\ze\s*:/ skipwhite skipempty nextgroup=tsDestructuringValueAssignment
syntax region  tsDestructuringValue             contained start=/=/ end=/[,}\]]\@=/ contains=@tsExpression extend
syntax region  tsDestructuringValueAssignment   contained start=/:/ end=/[,}=]\@=/ contains=tsDestructuringPropertyValue,tsDestructuringBlock,tsNoise,tsDestructuringNoise skipwhite skipempty nextgroup=tsDestructuringValue extend
syntax match   tsDestructuringNoise             contained /[,]/
syntax region  tsDestructuringPropertyComputed  contained matchgroup=tsDestructuringBraces start=/\[/ end=/]/ contains=@tsExpression skipwhite skipempty nextgroup=tsDestructuringValue,tsDestructuringValueAssignment,tsDestructuringNoise extend fold

" Comments
syntax keyword tsCommentTodo    contained TODO FIXME XXX TBD
syntax region  tsComment        start=+//+ end=/$/ contains=tsCommentTodo,@Spell extend keepend
syntax region  tsComment        start=+/\*+  end=+\*/+ contains=tsCommentTodo,@Spell fold extend keepend
syntax region  tsEnvComment     start=/\%^#!/ end=/$/ display

" Specialized Comments - These are special comment regexes that are used in
" odd places that maintain the proper nextgroup functionality. It sucks we
" can't make tsComment a skippable type of group for nextgroup
syntax region  tsCommentFunction    contained start=+//+ end=/$/    contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsFuncBlock,tsFlowReturn extend keepend
syntax region  tsCommentFunction    contained start=+/\*+ end=+\*/+ contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsFuncBlock,tsFlowReturn fold extend keepend
syntax region  tsCommentClass       contained start=+//+ end=/$/    contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsClassBlock,tsFlowClassGroup extend keepend
syntax region  tsCommentClass       contained start=+/\*+ end=+\*/+ contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsClassBlock,tsFlowClassGroup fold extend keepend
syntax region  tsCommentIfElse      contained start=+//+ end=/$/    contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsIfElseBlock extend keepend
syntax region  tsCommentIfElse      contained start=+/\*+ end=+\*/+ contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsIfElseBlock fold extend keepend
syntax region  tsCommentRepeat      contained start=+//+ end=/$/    contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsRepeatBlock extend keepend
syntax region  tsCommentRepeat      contained start=+/\*+ end=+\*/+ contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsRepeatBlock fold extend keepend

" Decorators
syntax match   tsDecorator                    /^\s*@/ nextgroup=tsDecoratorFunction
syntax match   tsDecoratorFunction  contained /\h[a-zA-Z0-9_.]*/ nextgroup=tsParenDecorator

if exists('typescript_plugin_jsdoc')
  runtime extras/jsdoc.vim
  " NGDoc requires JSDoc
  if exists('typescript_plugin_ngdoc')
    runtime extras/ngdoc.vim
  endif
endif

" Merge flow into this file...
runtime extras/flow.vim

syntax cluster tsExpression  contains=tsBracket,tsParen,tsObject,tsTernaryIf,tsTaggedTemplate,tsTemplateString,tsString,tsRegexpString,tsNumber,tsFloat,tsOperator,tsOperatorKeyword,tsBooleanTrue,tsBooleanFalse,tsNull,tsFunction,tsArrowFunction,tsGlobalObjects,tsExceptions,tsFutureKeys,tsDomErrNo,tsDomNodeConsts,tsHtmlEvents,tsFuncCall,tsUndefined,tsNan,tsPrototype,tsBuiltins,tsNoise,tsClassDefinition,tsArrowFunction,tsArrowFuncArgs,tsParensError,tsComment,tsArguments,tsThis,tsSuper,tsDo,tsForAwait,tsAsyncKeyword,tsStatement,tsDot
syntax cluster tsAll         contains=@tsExpression,tsStorageClass,tsConditional,tsRepeat,tsReturn,tsException,tsTry,tsNoise,tsBlockLabel

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if v:version >= 508 || !exists('did_typescript_syn_inits')
  if v:version < 508
    let did_typescript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink tsComment              Comment
  HiLink tsEnvComment           PreProc
  HiLink tsParensIfElse         tsParens
  HiLink tsParensRepeat         tsParens
  HiLink tsParensSwitch         tsParens
  HiLink tsParensCatch          tsParens
  HiLink tsCommentTodo          Todo
  HiLink tsString               String
  HiLink tsObjectKeyString      String
  HiLink tsTemplateString       String
  HiLink tsObjectStringKey      String
  HiLink tsClassStringKey       String
  HiLink tsTaggedTemplate       StorageClass
  HiLink tsTernaryIfOperator    Operator
  HiLink tsRegexpString         String
  HiLink tsRegexpBoundary       SpecialChar
  HiLink tsRegexpQuantifier     SpecialChar
  HiLink tsRegexpOr             Conditional
  HiLink tsRegexpMod            SpecialChar
  HiLink tsRegexpBackRef        SpecialChar
  HiLink tsRegexpGroup          tsRegexpString
  HiLink tsRegexpCharClass      Character
  HiLink tsCharacter            Character
  HiLink tsPrototype            Special
  HiLink tsConditional          Conditional
  HiLink tsBranch               Conditional
  HiLink tsLabel                Label
  HiLink tsReturn               Statement
  HiLink tsRepeat               Repeat
  HiLink tsDo                   Repeat
  HiLink tsStatement            Statement
  HiLink tsException            Exception
  HiLink tsTry                  Exception
  HiLink tsFinally              Exception
  HiLink tsCatch                Exception
  HiLink tsAsyncKeyword         Keyword
  HiLink tsForAwait             Keyword
  HiLink tsArrowFunction        Type
  HiLink tsFunction             Type
  HiLink tsGenerator            tsFunction
  HiLink tsArrowFuncArgs        tsFuncArgs
  HiLink tsFuncName             Function
  HiLink tsFuncCall             Function
  HiLink tsClassFuncName        tsFuncName
  HiLink tsObjectFuncName       Function
  HiLink tsArguments            Special
  HiLink tsError                Error
  HiLink tsParensError          Error
  HiLink tsOperatorKeyword      tsOperator
  HiLink tsOperator             Operator
  HiLink tsOf                   Operator
  HiLink tsStorageClass         StorageClass
  HiLink tsClassKeyword         Keyword
  HiLink tsExtendsKeyword       Keyword
  HiLink tsThis                 Special
  HiLink tsSuper                Constant
  HiLink tsNan                  Number
  HiLink tsNull                 Type
  HiLink tsUndefined            Type
  HiLink tsNumber               Number
  HiLink tsFloat                Float
  HiLink tsBooleanTrue          Boolean
  HiLink tsBooleanFalse         Boolean
  HiLink tsObjectColon          tsNoise
  HiLink tsNoise                Noise
  HiLink tsDot                  Noise
  HiLink tsBrackets             Noise
  HiLink tsParens               Noise
  HiLink tsBraces               Noise
  HiLink tsFuncBraces           Noise
  HiLink tsFuncParens           Noise
  HiLink tsClassBraces          Noise
  HiLink tsClassNoise           Noise
  HiLink tsIfElseBraces         Noise
  HiLink tsTryCatchBraces       Noise
  HiLink tsModuleBraces         Noise
  HiLink tsObjectBraces         Noise
  HiLink tsObjectSeparator      Noise
  HiLink tsFinallyBraces        Noise
  HiLink tsRepeatBraces         Noise
  HiLink tsSwitchBraces         Noise
  HiLink tsSpecial              Special
  HiLink tsTemplateBraces       Noise
  HiLink tsGlobalObjects        Constant
  HiLink tsGlobalNodeObjects    Constant
  HiLink tsExceptions           Constant
  HiLink tsBuiltins             Constant
  HiLink tsImport               Include
  HiLink tsExport               Include
  HiLink tsExportDefault        StorageClass
  HiLink tsExportDefaultGroup   tsExportDefault
  HiLink tsModuleAs             Include
  HiLink tsModuleComma          tsNoise
  HiLink tsModuleAsterisk       Noise
  HiLink tsFrom                 Include
  HiLink tsDecorator            Special
  HiLink tsDecoratorFunction    Function
  HiLink tsParensDecorator      tsParens
  HiLink tsFuncArgOperator      tsFuncArgs
  HiLink tsClassProperty        tsObjectKey
  HiLink tsObjectShorthandProp  tsObjectKey
  HiLink tsSpreadOperator       Operator
  HiLink tsRestOperator         Operator
  HiLink tsRestExpression       tsFuncArgs
  HiLink tsSwitchColon          Noise
  HiLink tsClassMethodType      Type
  HiLink tsObjectMethodType     Type
  HiLink tsClassDefinition      tsFuncName
  HiLink tsBlockLabel           Identifier
  HiLink tsBlockLabelKey        tsBlockLabel

  HiLink tsDestructuringBraces     Noise
  HiLink tsDestructuringProperty   tsFuncArgs
  HiLink tsDestructuringAssignment tsObjectKey
  HiLink tsDestructuringNoise      Noise

  HiLink tsCommentFunction      tsComment
  HiLink tsCommentClass         tsComment
  HiLink tsCommentIfElse        tsComment
  HiLink tsCommentRepeat        tsComment

  HiLink tsDomErrNo             Constant
  HiLink tsDomNodeConsts        Constant
  HiLink tsDomElemAttrs         Label
  HiLink tsDomElemFuncs         PreProc

  HiLink tsHtmlEvents           Special
  HiLink tsHtmlElemAttrs        Label
  HiLink tsHtmlElemFuncs        PreProc

  HiLink tsCssStyles            Label

  delcommand HiLink
endif

let b:current_syntax = 'typescript'
if main_syntax ==# 'typescript'
  unlet main_syntax
endif
