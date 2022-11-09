" Vim syntax file
" Language:     TypeScript
" Maintainer:   vim-typescript community
" URL:          https://github.com/amadeus/vim-typescript

if !exists('main_syntax')
  if exists('b:current_syntax')
    finish
  endif
  let main_syntax = 'typescript'
endif

setlocal iskeyword+=$

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
syntax match   tsVariableDef    contained /\<\K\k*/ skipwhite skipempty nextgroup=tsTSCDefinition
syntax keyword tsOperatorKeyword delete instanceof typeof void new in of skipwhite skipempty nextgroup=@tsExpression
syntax match   tsOperator       "[-!|&+<>=%/*~^]" skipwhite skipempty nextgroup=@tsExpression
syntax match   tsOperator       /::/ skipwhite skipempty nextgroup=@tsExpression
syntax keyword tsOperator       as
syntax keyword tsBooleanTrue    true
syntax keyword tsBooleanFalse   false

" Modules
syntax keyword tsImport                       import skipwhite skipempty nextgroup=tsModuleAsterisk,tsModuleKeyword,tsModuleGroup,tsTSCImportType
syntax keyword tsExport                       export skipwhite skipempty nextgroup=@tsAll,tsModuleGroup,tsExportDefault,tsModuleAsterisk,tsModuleKeyword,tsTSCTypeStatement
syntax match   tsModuleKeyword      contained /\<\K\k*/ skipwhite skipempty nextgroup=tsModuleAs,tsFrom,tsModuleComma
syntax keyword tsExportDefault      contained default skipwhite skipempty nextgroup=@tsExpression
syntax keyword tsExportDefaultGroup contained default skipwhite skipempty nextgroup=tsModuleAs,tsFrom,tsModuleComma
syntax match   tsModuleAsterisk     contained /\*/ skipwhite skipempty nextgroup=tsModuleKeyword,tsModuleAs,tsFrom
syntax keyword tsModuleAs           contained as skipwhite skipempty nextgroup=tsModuleKeyword,tsExportDefaultGroup
syntax keyword tsFrom               contained from skipwhite skipempty nextgroup=tsString
syntax match   tsModuleComma        contained /,/ skipwhite skipempty nextgroup=tsModuleKeyword,tsModuleAsterisk,tsModuleGroup,tsTSCTypeKeyword

" Strings, Templates, Numbers
syntax region  tsString           start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+  contains=tsSpecial,@Spell extend
syntax region  tsTemplateString   start=+`+  skip=+\\`+  end=+`+     contains=tsTemplateExpression,tsSpecial,@Spell extend
syntax match   tsTaggedTemplate   /\<\K\k*\ze`/ nextgroup=tsTemplateString
syntax match   tsNumber           /\c\<\%(\d\+\%(e[+-]\=\d\+\)\=\|0b[01]\+\|0o\o\+\|0x\%(\x\|_\)\+\)\>/
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

syntax keyword tsNull      null
syntax keyword tsReturn    return contained  skipwhite nextgroup=@tsExpression
syntax keyword tsUndefined undefined
syntax keyword tsNan       NaN
syntax keyword tsPrototype prototype
syntax keyword tsThis      this
syntax keyword tsSuper     super  contained

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
syntax keyword tsCatch        contained catch           skipwhite skipempty nextgroup=tsParenCatch,tsFinallyBlock
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
syntax keyword tsFutureKeys         abstract int short boolean byte long char final native synchronized float package throws goto private transient implements protected volatile double public

syntax keyword tsEnum               enum  nextgroup=tsEnumName skipwhite skipempty
syntax match   tsEnumName  contained /\k\+/ nextgroup=tsEnumBlock
syntax match   tsEnumKey   contained /\k\+/
syntax match   tsEnumComma contained ","
syntax match   tsEnumEquals contained "="

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
syntax region  tsParen                        matchgroup=tsParens              start=/(/  end=/)/  contains=@tsExpression extend fold nextgroup=tsTSCDefinition
syntax region  tsParenDecorator     contained matchgroup=tsParensDecorator     start=/(/  end=/)/  contains=@tsAll extend fold
syntax region  tsParenIfElse        contained matchgroup=tsParensIfElse        start=/(/  end=/)/  contains=@tsAll skipwhite skipempty nextgroup=tsCommentIfElse,tsIfElseBlock,tsReturn extend fold
syntax region  tsParenRepeat        contained matchgroup=tsParensRepeat        start=/(/  end=/)/  contains=@tsAll skipwhite skipempty nextgroup=tsCommentRepeat,tsRepeatBlock,tsReturn extend fold
syntax region  tsParenSwitch        contained matchgroup=tsParensSwitch        start=/(/  end=/)/  contains=@tsAll skipwhite skipempty nextgroup=tsSwitchBlock extend fold
syntax region  tsParenCatch         contained matchgroup=tsParensCatch         start=/(/  end=/)/  skipwhite skipempty nextgroup=tsTryCatchBlock extend fold
syntax region  tsFuncArgs           contained matchgroup=tsFuncParens          start=/(/  end=/)/  contains=tsFuncArgCommas,tsComment,tsFuncArgExpression,tsDestructuringBlock,tsDestructuringArray,tsRestExpression,tsTSCArgumentDef skipwhite skipempty nextgroup=tsCommentFunction,tsFuncBlock,tsTSCReturn extend fold
syntax region  tsClassBlock         contained matchgroup=tsClassBraces         start=/{/  end=/}/  contains=tsClassFuncName,tsClassMethodType,tsArrowFunction,tsArrowFuncArgs,tsComment,tsGenerator,tsDecorator,tsClassProperty,tsClassPropertyComputed,tsClassStringKey,tsAsyncKeyword,tsClassPrivateProperty,tsNoise extend fold
syntax region  tsFuncBlock          contained matchgroup=tsFuncBraces          start=/{/  end=/}/  contains=@tsAll,tsBlock,tsTSCGenericArrow extend fold
syntax region  tsIfElseBlock        contained matchgroup=tsIfElseBraces        start=/{/  end=/}/  contains=@tsAll,tsBlock extend fold
syntax region  tsTryCatchBlock      contained matchgroup=tsTryCatchBraces      start=/{/  end=/}/  contains=@tsAll,tsBlock skipwhite skipempty nextgroup=tsCatch,tsFinally extend fold
syntax region  tsFinallyBlock       contained matchgroup=tsFinallyBraces       start=/{/  end=/}/  contains=@tsAll,tsBlock extend fold
syntax region  tsSwitchBlock        contained matchgroup=tsSwitchBraces        start=/{/  end=/}/  contains=@tsAll,tsBlock,tsSwitchCase extend fold
syntax region  tsRepeatBlock        contained matchgroup=tsRepeatBraces        start=/{/  end=/}/  contains=@tsAll,tsBlock extend fold
syntax region  tsDestructuringBlock contained matchgroup=tsDestructuringBraces start=/{/  end=/}/  contains=tsDestructuringProperty,tsDestructuringAssignment,tsDestructuringNoise,tsDestructuringPropertyComputed,tsSpreadExpression,tsComment nextgroup=tsTSCDefinition extend fold
syntax region  tsDestructuringArray contained matchgroup=tsDestructuringBraces start=/\[/ end=/\]/ contains=tsDestructuringPropertyValue,tsDestructuringNoise,tsDestructuringProperty,tsSpreadExpression,tsDestructuringBlock,tsDestructuringArray,tsComment nextgroup=tsTSCDefinition extend fold
syntax region  tsObject             contained matchgroup=tsObjectBraces        start=/{/  end=/}/  contains=tsObjectKey,tsObjectKeyString,tsObjectKeyComputed,tsObjectShorthandProp,tsObjectSeparator,tsObjectFuncName,tsObjectMethodType,tsGenerator,tsComment,tsObjectStringKey,tsSpreadExpression,tsDecorator,tsAsyncKeyword extend fold
syntax region  tsBlock                        matchgroup=tsBraces              start=/{/  end=/}/  contains=@tsAll,tsSpreadExpression extend fold
syntax region  tsEnumBlock          contained matchgroup=tsBraces              start=/{/  end=/}/  contains=tsEnumComma,tsEnumKey,tsEnumEquals,tsString,tsNumber,tsOperator,tsComment extend fold
syntax region  tsModuleGroup        contained matchgroup=tsModuleBraces        start=/{/ end=/}/   contains=tsModuleKeyword,tsModuleComma,tsModuleAs,tsComment,tsTSCTypeKeyword skipwhite skipempty nextgroup=tsFrom fold
syntax region  tsSpreadExpression   contained matchgroup=tsSpreadOperator      start=/\.\.\./ end=/[,}\]]\@=/ contains=@tsExpression
syntax region  tsRestExpression     contained matchgroup=tsRestOperator        start=/\.\.\./ end=/[,)]\@=/
syntax region  tsTernaryIf                    matchgroup=tsTernaryIfOperator   start=/?:\@!/  end=/\%(:\|}\@=\)/  contains=@tsExpression extend skipwhite skipempty nextgroup=@tsExpression
" These must occur here or they will be override by tsTernaryIf
syntax match   tsOperator           /?\.\ze\_D/
syntax match   tsOperator           /??/ skipwhite skipempty nextgroup=@tsExpression

syntax match   tsGenerator            contained /\*/ skipwhite skipempty nextgroup=tsFuncName,tsFuncArgs,tsTSCFunctionGroup
syntax match   tsFuncName             contained /\<\K\k*/ skipwhite skipempty nextgroup=tsFuncArgs,tsTSCFunctionGeneric
syntax region  tsFuncArgExpression    contained matchgroup=tsFuncArgOperator start=/=/ end=/[,)]\@=/ contains=@tsExpression extend
syntax match   tsFuncArgCommas        contained ','
syntax keyword tsArguments            contained arguments
syntax keyword tsForAwait             contained await skipwhite skipempty nextgroup=tsParenRepeat

" Matches a single keyword argument with no parens
syntax match   tsArrowFuncArgs  /\<\K\k*\ze\s*=>/ skipwhite contains=tsFuncArgs skipwhite skipempty nextgroup=tsArrowFunction extend
" Matches a series of arguments surrounded in parens
syntax match   tsArrowFuncArgs  /([^()]*)\ze\s*=>/ contains=tsFuncArgs skipempty skipwhite nextgroup=tsArrowFunction extend

syntax match tsFunction /\<function\>/      skipwhite skipempty nextgroup=tsGenerator,tsFuncName,tsFuncArgs,tsTSCFunctionGroup,tsTSCFunctionGeneric skipwhite
syntax match tsArrowFunction /=>/           skipwhite skipempty nextgroup=tsFuncBlock,tsCommentFunction
syntax match tsArrowFunction /()\ze\s*=>/   skipwhite skipempty nextgroup=tsArrowFunction
syntax match tsArrowFunction /_\ze\s*=>/    skipwhite skipempty nextgroup=tsArrowFunction

" Classes
syntax keyword tsClassKeyword           contained class
syntax keyword tsExtendsKeyword         contained extends skipwhite skipempty nextgroup=@tsExpression
syntax match   tsClassNoise             contained /\./
syntax match   tsClassFuncName          contained /\<\K\k*\ze\s*[(<]/ skipwhite skipempty nextgroup=tsFuncArgs,tsTSCClassFunctionGroup
syntax match   tsClassMethodType        contained /\<\%([gs]et\|static\)\ze\s\+\K\k*/ skipwhite skipempty nextgroup=tsAsyncKeyword,tsClassFuncName,tsClassProperty
syntax region  tsClassDefinition                  start=/\<class\>/ end=/\(\<extends\>\s\+\)\@<!{\@=/ contains=tsClassKeyword,tsExtendsKeyword,tsClassNoise,@tsExpression,tsTSCClassGroup skipwhite skipempty nextgroup=tsCommentClass,tsClassBlock,tsTSCClassGroup
syntax match   tsClassProperty          contained /\<\K\k*\ze\s*=/ skipwhite skipempty nextgroup=tsClassValue,tsTSCClassDef
syntax match tsClassPrivateProperty     contained /private\|public\|readonly/ skipwhite skipempty nextgroup=tsClassProperty
syntax region  tsClassValue             contained start=/=/ end=/\_[;}]\@=/ contains=@tsExpression
syntax region  tsClassPropertyComputed  contained matchgroup=tsBrackets start=/\[/ end=/]/ contains=@tsExpression skipwhite skipempty nextgroup=tsFuncArgs,tsClassValue extend
syntax region  tsClassStringKey         contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1\|$+  contains=tsSpecial,@Spell extend skipwhite skipempty nextgroup=tsFuncArgs

" Destructuring
syntax match   tsDestructuringPropertyValue     contained /\k\+/
syntax match   tsDestructuringProperty          contained /\k\+\ze\s*=/ skipwhite skipempty nextgroup=tsDestructuringValue
syntax match   tsDestructuringAssignment        contained /\k\+\ze\s*:/ skipwhite skipempty nextgroup=tsDestructuringValueAssignment
syntax region  tsDestructuringValue             contained start=/=/ end=/[,}\]]\@=/ contains=@tsExpression extend
syntax region  tsDestructuringValueAssignment   contained start=/:/ end=/[,}=]\@=/ contains=tsDestructuringPropertyValue,tsDestructuringBlock,tsDestructuringArray,tsNoise,tsDestructuringNoise skipwhite skipempty nextgroup=tsDestructuringValue extend
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
syntax region  tsCommentFunction    contained start=+//+ end=/$/    contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsFuncBlock,tsTSCReturn extend keepend
syntax region  tsCommentFunction    contained start=+/\*+ end=+\*/+ contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsFuncBlock,tsTSCReturn fold extend keepend
syntax region  tsCommentClass       contained start=+//+ end=/$/    contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsClassBlock,tsTSCClassGroup extend keepend
syntax region  tsCommentClass       contained start=+/\*+ end=+\*/+ contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsClassBlock,tsTSCClassGroup fold extend keepend
syntax region  tsCommentIfElse      contained start=+//+ end=/$/    contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsIfElseBlock extend keepend
syntax region  tsCommentIfElse      contained start=+/\*+ end=+\*/+ contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsIfElseBlock fold extend keepend
syntax region  tsCommentRepeat      contained start=+//+ end=/$/    contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsRepeatBlock extend keepend
syntax region  tsCommentRepeat      contained start=+/\*+ end=+\*/+ contains=tsCommentTodo,@Spell skipwhite skipempty nextgroup=tsRepeatBlock fold extend keepend

" Decorators
syntax match   tsDecorator                    /^\s*@/ nextgroup=tsDecoratorFunction
syntax match   tsDecoratorFunction  contained /\h[a-zA-Z0-9_.]*/ nextgroup=tsParenDecorator

" NOTE: Look to re-implement this all properly into the existing settings...
syntax region  tsTSCDefinition     contained                        start=/:/    end=/\%(\s*[,=;)\n]\)\@=/ contains=@tsTSCCluster containedin=tsParen
syntax region  tsTSCArgumentDef    contained                        start=/:/    end=/\%(\s*[,)]\|=>\@!\)\@=/ contains=@tsTSCCluster
syntax region  tsTSCArray          contained matchgroup=tsTSCNoise start=/\[/   end=/\]/        contains=@tsTSCCluster,tsComment fold
syntax region  tsTSCObject         contained matchgroup=tsTSCNoise start=/{/    end=/}/         contains=@tsTSCCluster,tsComment fold
syntax region  tsTSCExactObject    contained matchgroup=tsTSCNoise start=/{|/   end=/|}/       contains=@tsTSCCluster,tsComment fold
syntax region  tsTSCParens         contained matchgroup=tsTSCNoise start=/(/  end=/)/ contains=@tsTSCCluster nextgroup=tsTSCArrow skipwhite keepend extend fold
syntax match   tsTSCNoise          contained /[:;,<>]/
syntax keyword tsTSCType           contained boolean number string null void any mixed JSON array Function object array bool class
syntax keyword tsTSCTypeof         contained typeof skipempty skipwhite nextgroup=tsTSCTypeCustom,tsTSCType
syntax match   tsTSCTypeCustom     contained /[0-9a-zA-Z_.]*/ skipwhite skipempty nextgroup=tsTSCGeneric
syntax region  tsTSCGeneric                  matchgroup=tsTSCNoise start=/\k\@<=</ end=/>/ keepend extend contains=@tsTSCCluster,tsTSCGenericBase containedin=@tsExpression,tsTSCDeclareBlock
syntax region  tsTSCGenericArrow             matchgroup=tsTSCNoise start=/</ end=/>\ze(/ keepend extend oneline contains=@tsTSCCluster,tsTSCGenericBase containedin=@tsExpression,tsTSCDeclareBlock nextgroup=tsArrowFunction
syntax region  tsTSCGenericBase    contained matchgroup=tsTSCNoise start=/</ end=/>/ keepend extend oneline contains=@tsTSCCluster
syntax region  tsTSCFunctionGeneric    contained matchgroup=tsTSCNoise start=/</ end=/>(\@=/ keepend extend contains=@tsTSCCluster nextgroup=tsFuncArgs
" syntax region  tsTSCFunctionGeneric contained matchgroup=tsTSCNoise start=/</ end=/>/ contains=@tsTSCCluster skipwhite skipempty nextgroup=tsFuncArgs
" syntax region  tsTSCObjectGeneric  contained matchgroup=tsTSCNoise start=/\k\@<=</ end=/>/ keepend extend contains=@tsTSCCluster nextgroup=tsFuncArgs
syntax match   tsTSCArrow          contained /=>/ skipwhite skipempty nextgroup=tsTSCType,tsTSCTypeCustom,tsTSCParens extend
syntax match   tsTSCObjectKey      contained /[0-9a-zA-Z_$?]*\(\s*:\)\@=/ contains=tsFunctionKey,tsTSCMaybe skipwhite skipempty nextgroup=tsObjectValue containedin=tsObject
syntax match   tsTSCOrOperator     contained /|/ skipwhite skipempty nextgroup=@tsTSCCluster
syntax match   tsTSCAndOperator     contained /&/ skipwhite skipempty nextgroup=@tsTSCCluster
syntax keyword tsTSCImportType     contained type typeof skipwhite skipempty nextgroup=tsModuleAsterisk,tsModuleKeyword,tsModuleGroup
syntax match   tsTSCWildcard       contained /*/
syntax region  tsTSCString         contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+ extend skipwhite skipempty nextgroup=tsTSCOrOperator,tsTSCAndOperator
syntax keyword tsTSCReadOnly       contained readonly skipwhite skipempty nextgroup=@tsTSCCluster

syntax match   tsTSCReturn         contained /:\s*/ contains=tsTSCNoise skipwhite skipempty nextgroup=@tsTSCReturnCluster,tsTSCArrow,tsTSCReturnParens
syntax region  tsTSCReturnObject   contained matchgroup=tsTSCNoise start=/{/    end=/}/  contains=@tsTSCCluster skipwhite skipempty nextgroup=tsFuncBlock,tsTSCReturnOrOp,tsTSCReturnAndOp extend fold
syntax region  tsTSCReturnArray    contained matchgroup=tsTSCNoise start=/\[/   end=/\]/ contains=@tsTSCCluster skipwhite skipempty nextgroup=tsFuncBlock,tsTSCReturnOrOp,tsTSCReturnAndOp,tsTSCReturnArray fold
syntax region  tsTSCReturnParens   contained matchgroup=tsTSCNoise start=/(/    end=/)/  contains=@tsTSCCluster skipwhite skipempty nextgroup=tsFuncBlock,tsTSCReturnOrOp,tsTSCReturnAndOp,tsTSCReturnArrow fold
syntax match   tsTSCReturnArrow    contained /=>/ skipwhite skipempty nextgroup=@tsTSCReturnCluster
syntax match   tsTSCReturnKeyword  contained /\k\+/ contains=tsTSCType,tsTSCTypeCustom skipwhite skipempty nextgroup=tsTSCReturnGroup,tsFuncBlock,tsTSCReturnOrOp,tsTSCReturnAndOp,tsTSCReturnArray
syntax match   tsTSCReturnMaybe    contained /?/ skipwhite skipempty nextgroup=@tsTSCReturnCluster,tsTSCReturnKeyword,tsTSCReturnObject,tsTSCReturnParens
syntax region  tsTSCReturnGroup    contained matchgroup=tsTSCNoise start=/</ end=/>/ contains=@tsTSCCluster skipwhite skipempty nextgroup=tsFuncBlock,tsTSCReturnOrOptsTSCReturnAndOp,tsTSCReturnArray
syntax match   tsTSCReturnOrOp     contained /\s*|\s*/ skipwhite skipempty nextgroup=@tsTSCReturnCluster
syntax match   tsTSCReturnAndOp    contained /\s*&\s*/ skipwhite skipempty nextgroup=@tsTSCReturnCluster
syntax match   tsTSCWildcardReturn contained /*/ skipwhite skipempty nextgroup=tsFuncBlock
syntax keyword tsTSCTypeofReturn   contained typeof skipempty skipwhite nextgroup=@tsTSCReturnCluster
syntax region  tsTSCReturnString   contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+ extend skipwhite skipempty nextgroup=tsFuncBlock,tsTSCReturnOrOp,tsTSCReturnAndOp
syntax keyword tsTSCReadOnlyReturn contained readonly skipwhite skipempty nextgroup=@tsTSCReturnCluster

syntax region  tsTSCClassGroup         contained matchgroup=tsTSCNoise start=/</ end=/>/ contains=@tsTSCCluster skipwhite skipempty nextgroup=tsClassBlock
syntax region  tsTSCClassFunctionGroup contained matchgroup=tsTSCNoise start=/</ end=/>/ contains=@tsTSCCluster skipwhite skipempty nextgroup=tsFuncArgs
syntax match   tsTSCObjectFuncName contained /\<\K\k*<\@=/ skipwhite skipempty nextgroup=tsTSCObjectGeneric,tsTSCFunctionGeneric containedin=tsObject

syntax region  tsTSCTypeStatement             start=/\(opaque\s\+\)\?type\%(\s\+\k\)\@=/    end=/=\@=/ contains=tsTSCTypeOperator,tsTSCTypeName,tsTSCTypeDef oneline skipwhite skipempty nextgroup=tsTSCTypeValue keepend
syntax match   tsTSCTypeName       contained  /\k\+/
syntax keyword tsTSCTypeDef        contained  type
syntax region  tsTSCTypeValue      contained     matchgroup=tsTSCNoise start=/=/ end=/\%(;\|\n\%(\s*|\)\@!\)/ contains=@tsTSCCluster,tsTSCGeneric,tsTSCMaybe
syntax match   tsTSCTypeOperator   contained /=/ containedin=tsTSCTypeValue
syntax match   tsTSCTypeOperator   contained /=/
syntax keyword tsTSCTypeKeyword    contained type

syntax keyword tsTSCDeclare                  declare skipwhite skipempty nextgroup=tsTSCTypeStatement,tsClassDefinition,tsStorageClass,tsTSCModule,tsTSCInterface,tsTSCExport
syntax keyword tsTSCInterface                interface skipwhite skipempty nextgroup=tsTSCInterfaceName
syntax match   tsTSCInterfaceComma  contained /[,]/ skipwhite skipempty skipnl nextgroup=tsTSCInterfaceName
syntax keyword tsTSCInterfaceExtends         extends skipwhite skipempty nextgroup=tsTSCInterfaceName
syntax match   tsTSCInterfaceName  contained /\<[0-9a-zA-Z_$]*\>/ skipwhite skipempty nextgroup=tsTSCInterfaceComma,@tsTSCCluster,tsTSCInterfaceExtends,tsTSCGenericInterface
syntax region  tsTSCGenericInterface contained matchgroup=tsTSCNoise start=/\k\@<=</ end=/>/ keepend extend contains=@tsTSCCluster skipwhite skipempty nextgroup=tsTSCObject,tsTSCInterfaceComma
syntax keyword tsTSCExport                   export skipwhite skipempty nextgroup=tsTSCTypeStatement,tsClassDefinition,tsStorageClass,tsTSCModule,tsTSCInterface,tsExportDefault
syntax match   tsTSCClassProperty  contained /\<[0-9a-zA-Z_$]*\>:\@=/ skipwhite skipempty nextgroup=tsTSCClassDef containedin=tsClassBlock
syntax region  tsTSCClassDef       contained start=/:/    end=/\%(\s*[,=;)\n]\)\@=/ contains=@tsTSCCluster skipwhite skipempty nextgroup=tsClassValue

syntax region  tsTSCModule         contained start=/module/ end=/\%({\|:\)\@=/ skipempty skipwhite nextgroup=tsTSCDeclareBlock contains=tsString
syntax region  tsTSCInterface      contained start=/interface/ end=/{\@=/ skipempty skipwhite nextgroup=tsTSCInterfaceBlock contains=@tsTSCCluster
syntax region  tsTSCDeclareBlock   contained matchgroup=tsTSCNoise start=/{/ end=/}/ contains=tsTSCDeclare,tsTSCNoise,tsComment fold

syntax match   tsTSCMaybe          contained /?/
syntax region  tsTSCInterfaceBlock contained matchgroup=tsTSCNoise start=/{/ end=/}/ contains=tsObjectKey,tsObjectKeyString,tsObjectKeyComputed,tsObjectSeparator,tsObjectFuncName,tsTSCObjectFuncName,tsObjectMethodType,tsGenerator,tsComment,tsObjectStringKey,tsSpreadExpression,tsTSCNoise,tsTSCParens,tsTSCGeneric keepend fold

syntax region  tsTSCParenAnnotation contained start=/:/ end=/[,=)]\@=/ containedin=tsParen contains=@tsTSCCluster

syntax cluster tsTSCReturnCluster            contains=tsTSCNoise,tsTSCReturnObject,tsTSCReturnArray,tsTSCReturnKeyword,tsTSCReturnGroup,tsTSCReturnMaybe,tsTSCReturnOrOp,tsTSCReturnAndOp,tsTSCWildcardReturn,tsTSCReturnArrow,tsTSCTypeofReturn,tsTSCGeneric,tsTSCReturnString,tsTSCReadOnlyReturn
syntax cluster tsTSCCluster                  contains=tsTSCArray,tsTSCObject,tsTSCExactObject,tsTSCNoise,tsTSCTypeof,tsTSCType,tsTSCGeneric,tsTSCMaybe,tsTSCParens,tsTSCOrOperator,tsTSCAndOperator,tsTSCWildcard,tsTSCString,tsTSCReadOnly

syntax keyword tsTypeAs as nextgroup=tsTSCReturn skipwhite skipempty

syntax cluster tsExpression  contains=tsStyledDefinition,tsBracket,tsParen,tsObject,tsTernaryIf,tsTaggedTemplate,tsTemplateString,tsString,tsRegexpString,tsNumber,tsFloat,tsOperator,tsOperatorKeyword,tsBooleanTrue,tsBooleanFalse,tsNull,tsFunction,tsArrowFunction,tsGlobalObjects,tsExceptions,tsFutureKeys,tsDomErrNo,tsDomNodeConsts,tsHtmlEvents,tsFuncCall,tsUndefined,tsNan,tsPrototype,tsBuiltins,tsNoise,tsClassDefinition,tsArrowFunction,tsArrowFuncArgs,tsParensError,tsComment,tsArguments,tsThis,tsSuper,tsDo,tsForAwait,tsAsyncKeyword,tsStatement,tsDot
syntax cluster tsAll         contains=@tsExpression,tsStorageClass,tsConditional,tsRepeat,tsReturn,tsException,tsTry,tsNoise,tsBlockLabel

hi def link tsComment              Comment
hi def link tsEnvComment           PreProc
hi def link tsParensIfElse         tsParens
hi def link tsParensRepeat         tsParens
hi def link tsParensSwitch         tsParens
hi def link tsParensCatch          tsParens
hi def link tsCommentTodo          Todo
hi def link tsString               String
hi def link tsObjectKeyString      String
hi def link tsTemplateString       String
hi def link tsObjectStringKey      String
hi def link tsClassStringKey       String
hi def link tsTaggedTemplate       StorageClass
hi def link tsTernaryIfOperator    Operator
hi def link tsRegexpString         String
hi def link tsRegexpBoundary       SpecialChar
hi def link tsRegexpQuantifier     SpecialChar
hi def link tsRegexpOr             Conditional
hi def link tsRegexpMod            SpecialChar
hi def link tsRegexpBackRef        SpecialChar
hi def link tsRegexpGroup          tsRegexpString
hi def link tsRegexpCharClass      Character
hi def link tsCharacter            Character
hi def link tsPrototype            Special
hi def link tsConditional          Conditional
hi def link tsBranch               Conditional
hi def link tsLabel                Label
hi def link tsReturn               Statement
hi def link tsRepeat               Repeat
hi def link tsDo                   Repeat
hi def link tsStatement            Statement
hi def link tsException            Exception
hi def link tsTry                  Exception
hi def link tsFinally              Exception
hi def link tsCatch                Exception
hi def link tsAsyncKeyword         Keyword
hi def link tsForAwait             Keyword
hi def link tsArrowFunction        Type
hi def link tsFunction             Type
hi def link tsGenerator            tsFunction
hi def link tsArrowFuncArgs        tsFuncArgs
hi def link tsFuncName             Function
hi def link tsFuncCall             Function
hi def link tsClassFuncName        tsFuncName
hi def link tsObjectFuncName       Function
hi def link tsArguments            Special
hi def link tsError                Error
hi def link tsParensError          Error
hi def link tsOperatorKeyword      tsOperator
hi def link tsOperator             Operator
hi def link tsOf                   Operator
hi def link tsStorageClass         StorageClass
hi def link tsClassKeyword         Keyword
hi def link tsExtendsKeyword       Keyword
hi def link tsThis                 Special
hi def link tsSuper                Constant
hi def link tsNan                  Number
hi def link tsNull                 Type
hi def link tsUndefined            Type
hi def link tsNumber               Number
hi def link tsFloat                Float
hi def link tsBooleanTrue          Boolean
hi def link tsBooleanFalse         Boolean
hi def link tsObjectColon          tsNoise
hi def link tsNoise                Noise
hi def link tsDot                  Noise
hi def link tsBrackets             Noise
hi def link tsParens               Noise
hi def link tsBraces               Noise
hi def link tsFuncBraces           Noise
hi def link tsFuncParens           Noise
hi def link tsClassBraces          Noise
hi def link tsClassNoise           Noise
hi def link tsIfElseBraces         Noise
hi def link tsTryCatchBraces       Noise
hi def link tsModuleBraces         Noise
hi def link tsObjectBraces         Noise
hi def link tsObjectSeparator      Noise
hi def link tsFinallyBraces        Noise
hi def link tsRepeatBraces         Noise
hi def link tsSwitchBraces         Noise
hi def link tsSpecial              Special
hi def link tsTemplateBraces       Noise
hi def link tsGlobalObjects        Constant
hi def link tsGlobalNodeObjects    Constant
hi def link tsExceptions           Constant
hi def link tsBuiltins             Constant
hi def link tsImport               Include
hi def link tsExport               Include
hi def link tsExportDefault        StorageClass
hi def link tsExportDefaultGroup   tsExportDefault
hi def link tsModuleAs             Include
hi def link tsModuleComma          tsNoise
hi def link tsModuleAsterisk       Noise
hi def link tsFrom                 Include
hi def link tsDecorator            Special
hi def link tsDecoratorFunction    Function
hi def link tsParensDecorator      tsParens
hi def link tsFuncArgOperator      tsFuncArgs
hi def link tsClassProperty        tsObjectKey
hi def link tsObjectShorthandProp  tsObjectKey
hi def link tsSpreadOperator       Operator
hi def link tsRestOperator         Operator
hi def link tsRestExpression       tsFuncArgs
hi def link tsSwitchColon          Noise
hi def link tsClassMethodType      Type
hi def link tsObjectMethodType     Type
hi def link tsClassDefinition      tsFuncName
hi def link tsBlockLabel           Identifier
hi def link tsBlockLabelKey        tsBlockLabel
hi def link tsClassPrivateProperty Statement

hi def link tsDestructuringBraces     Noise
hi def link tsDestructuringProperty   tsFuncArgs
hi def link tsDestructuringAssignment tsObjectKey
hi def link tsDestructuringNoise      Noise

hi def link tsCommentFunction       tsComment
hi def link tsCommentClass          tsComment
hi def link tsCommentIfElse         tsComment
hi def link tsCommentRepeat         tsComment

hi def link tsDomErrNo              Constant
hi def link tsDomNodeConsts         Constant
hi def link tsDomElemAttrs          Label
hi def link tsDomElemFuncs          PreProc

hi def link tsHtmlEvents            Special
hi def link tsHtmlElemAttrs         Label
hi def link tsHtmlElemFuncs         PreProc

hi def link tsCssStyles             Label

hi def link tsTSCDefinition         PreProc
hi def link tsTSCClassDef           tsTSCDefinition
hi def link tsTSCArgumentDef        tsTSCDefinition
hi def link tsTSCType               Type
hi def link tsTSCTypeCustom         PreProc
hi def link tsTSCTypeof             PreProc
hi def link tsTSCTypeofReturn       PreProc
hi def link tsTSCArray              PreProc
hi def link tsTSCObject             PreProc
hi def link tsTSCExactObject        PreProc
hi def link tsTSCParens             PreProc
hi def link tsTSCGeneric            PreProc
hi def link tsTSCGenericArrow       PreProc
hi def link tsTSCString             PreProc
hi def link tsTSCReturnString       PreProc
hi def link tsTSCFunctionGeneric    tsTSCGeneric
hi def link tsTSCObjectGeneric      tsTSCGeneric
hi def link tsTSCReturn             PreProc
hi def link tsTSCParenAnnotation    PreProc
hi def link tsTSCReturnObject       tsTSCReturn
hi def link tsTSCReturnArray        tsTSCArray
hi def link tsTSCReturnParens       tsTSCParens
hi def link tsTSCReturnGroup        tsTSCGeneric
hi def link tsTSCClassGroup         PreProc
hi def link tsTSCClassFunctionGroup PreProc
hi def link tsTSCArrow              Noise
hi def link tsTSCReturnArrow        PreProc
hi def link tsTSCTypeStatement      PreProc
hi def link tsTSCTypeKeyword        PreProc
hi def link tsTSCTypeOperator       Operator
hi def link tsTSCMaybe              PreProc
hi def link tsTSCReturnMaybe        PreProc
hi def link tsTSCClassProperty      tsClassProperty
hi def link tsTSCDeclare            PreProc
hi def link tsTSCExport             PreProc
hi def link tsTSCModule             PreProc
hi def link tsTSCInterface          PreProc
hi def link tsTSCReadOnly           PreProc
hi def link tsTSCReadOnlyReturn     PreProc
hi def link tsTSCNoise              Noise
hi def link tsTSCObjectKey          tsObjectKey
hi def link tsTSCOrOperator         tsOperator
hi def link tsTSCAndOperator        tsOperator
hi def link tsTSCReturnOrOp         tsTSCOrOperator
hi def link tsTSCReturnAndOp        tsTSCOrOperator
hi def link tsTSCWildcard           PreProc
hi def link tsTSCWildcardReturn     PreProc
hi def link tsTSCImportType         PreProc
hi def link tsTSCTypeValue          PreProc
hi def link tsTSCReturnKeyword      PreProc
hi def link tsTSCObjectFuncName     tsObjectFuncName
hi def link tsTypeAs                PreProc
hi def link tsTSCInterfaceName      tsTSCType
hi def link tsTSCTypeName           tsTSCType
hi def link tsTSCTypeDef            PreProc
hi def link tsEnum                  StorageClass
hi def link tsEnumKey               tsTSCObjectKey
hi def link tsEnumEquals            tsOperator
hi def link tsEnumComma             Noise
hi def link tsTSCInterfaceExtends   PreProc
hi def link tsTSCGenericInterface   PreProc
hi def link tsTSCInterfaceComma     Noise

let b:current_syntax = 'typescript'
if main_syntax == 'typescript'
  unlet main_syntax
endif
