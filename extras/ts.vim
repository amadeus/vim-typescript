syntax region  tsFlowDefinition     contained                        start=/:/    end=/\%(\s*[,=;)\n]\)\@=/ contains=@tsFlowCluster containedin=tsParen
syntax region  tsFlowArgumentDef    contained                        start=/:/    end=/\%(\s*[,)]\|=>\@!\)\@=/ contains=@tsFlowCluster
syntax region  tsFlowArray          contained matchgroup=tsFlowNoise start=/\[/   end=/\]/        contains=@tsFlowCluster,tsComment fold
syntax region  tsFlowObject         contained matchgroup=tsFlowNoise start=/{/    end=/}/         contains=@tsFlowCluster,tsComment fold
syntax region  tsFlowExactObject    contained matchgroup=tsFlowNoise start=/{|/   end=/|}/       contains=@tsFlowCluster,tsComment fold
syntax region  tsFlowParens         contained matchgroup=tsFlowNoise start=/(/  end=/)/ contains=@tsFlowCluster nextgroup=tsFlowArrow skipwhite keepend extend fold
syntax match   tsFlowNoise          contained /[:;,<>]/
syntax keyword tsFlowType           contained boolean number string null void any mixed JSON array Function object array bool class
syntax keyword tsFlowTypeof         contained typeof skipempty skipwhite nextgroup=tsFlowTypeCustom,tsFlowType
syntax match   tsFlowTypeCustom     contained /[0-9a-zA-Z_.]*/ skipwhite skipempty nextgroup=tsFlowGeneric
syntax region  tsFlowGeneric                  matchgroup=tsFlowNoise start=/\k\@<=</ end=/>/ keepend extend contains=@tsFlowCluster containedin=@tsExpression,tsFlowDeclareBlock
syntax region  tsFlowFunctionGeneric    contained matchgroup=tsFlowNoise start=/</ end=/>(\@=/ keepend extend oneline contains=@tsFlowCluster nextgroup=tsFuncArgs
" syntax region  tsFlowFunctionGeneric contained matchgroup=tsFlowNoise start=/</ end=/>/ contains=@tsFlowCluster skipwhite skipempty nextgroup=tsFuncArgs
" syntax region  tsFlowObjectGeneric  contained matchgroup=tsFlowNoise start=/\k\@<=</ end=/>/ keepend extend contains=@tsFlowCluster nextgroup=tsFuncArgs
syntax match   tsFlowArrow          contained /=>/ skipwhite skipempty nextgroup=tsFlowType,tsFlowTypeCustom,tsFlowParens
syntax match   tsFlowObjectKey      contained /[0-9a-zA-Z_$?]*\(\s*:\)\@=/ contains=tsFunctionKey,tsFlowMaybe skipwhite skipempty nextgroup=tsObjectValue containedin=tsObject
syntax match   tsFlowOrOperator     contained /|/ skipwhite skipempty nextgroup=@tsFlowCluster
syntax keyword tsFlowImportType     contained type typeof skipwhite skipempty nextgroup=tsModuleAsterisk,tsModuleKeyword,tsModuleGroup
syntax match   tsFlowWildcard       contained /*/
syntax region  tsFlowString         contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+ extend skipwhite skipempty nextgroup=tsFlowOrOperator

syntax match   tsFlowReturn         contained /:\s*/ contains=tsFlowNoise skipwhite skipempty nextgroup=@tsFlowReturnCluster,tsFlowArrow,tsFlowReturnParens
syntax region  tsFlowReturnObject   contained matchgroup=tsFlowNoise start=/{/    end=/}/  contains=@tsFlowCluster skipwhite skipempty nextgroup=tsFuncBlock,tsFlowReturnOrOp extend fold
syntax region  tsFlowReturnArray    contained matchgroup=tsFlowNoise start=/\[/   end=/\]/ contains=@tsFlowCluster skipwhite skipempty nextgroup=tsFuncBlock,tsFlowReturnOrOp fold
syntax region  tsFlowReturnParens   contained matchgroup=tsFlowNoise start=/(/    end=/)/  contains=@tsFlowCluster skipwhite skipempty nextgroup=tsFuncBlock,tsFlowReturnOrOp,tsFlowReturnArrow fold
syntax match   tsFlowReturnArrow    contained /=>/ skipwhite skipempty nextgroup=@tsFlowReturnCluster
syntax match   tsFlowReturnKeyword  contained /\k\+/ contains=tsFlowType,tsFlowTypeCustom skipwhite skipempty nextgroup=tsFlowReturnGroup,tsFuncBlock,tsFlowReturnOrOp,tsFlowReturnArray
syntax match   tsFlowReturnMaybe    contained /?/ skipwhite skipempty nextgroup=@tsFlowReturnCluster,tsFlowReturnKeyword,tsFlowReturnObject,tsFlowReturnParens
syntax region  tsFlowReturnGroup    contained matchgroup=tsFlowNoise start=/</ end=/>/ contains=@tsFlowCluster skipwhite skipempty nextgroup=tsFuncBlock,tsFlowReturnOrOp
syntax match   tsFlowReturnOrOp     contained /\s*|\s*/ skipwhite skipempty nextgroup=@tsFlowReturnCluster
syntax match   tsFlowWildcardReturn contained /*/ skipwhite skipempty nextgroup=tsFuncBlock
syntax keyword tsFlowTypeofReturn   contained typeof skipempty skipwhite nextgroup=@tsFlowReturnCluster
syntax region  tsFlowReturnString   contained start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ end=+$+ extend skipwhite skipempty nextgroup=tsFuncBlock,tsFlowReturnOrOp

syntax region  tsFlowClassGroup         contained matchgroup=tsFlowNoise start=/</ end=/>/ contains=@tsFlowCluster skipwhite skipempty nextgroup=tsClassBlock
syntax region  tsFlowClassFunctionGroup contained matchgroup=tsFlowNoise start=/</ end=/>/ contains=@tsFlowCluster skipwhite skipempty nextgroup=tsFuncArgs
syntax match   tsFlowObjectFuncName contained /\<\K\k*<\@=/ skipwhite skipempty nextgroup=tsFlowObjectGeneric containedin=tsObject

syntax region  tsFlowTypeStatement                                   start=/\(opaque\s\+\)\?type\%(\s\+\k\)\@=/    end=/=\@=/ contains=tsFlowTypeOperator oneline skipwhite skipempty nextgroup=tsFlowTypeValue keepend
syntax region  tsFlowTypeValue      contained     matchgroup=tsFlowNoise start=/=/ end=/\%(;\|\n\%(\s*|\)\@!\)/ contains=@tsFlowCluster,tsFlowGeneric,tsFlowMaybe
syntax match   tsFlowTypeOperator   contained /=/ containedin=tsFlowTypeValue
syntax match   tsFlowTypeOperator   contained /=/
syntax keyword tsFlowTypeKeyword    contained type

syntax keyword tsFlowDeclare                  declare skipwhite skipempty nextgroup=tsFlowTypeStatement,tsClassDefinition,tsStorageClass,tsFlowModule,tsFlowInterface,tsFlowExport
syntax keyword tsFlowInterface                interface skipwhite skipempty nextgroup=tsFlowInterfaceName
syntax match   tsFlowInterfaceName  contained /\<[0-9a-zA-Z_$]*\>/ skipwhite skipempty nextgroup=tsClassBlock
syntax keyword tsFlowExport                   export skipwhite skipempty nextgroup=tsFlowTypeStatement,tsClassDefinition,tsStorageClass,tsFlowModule,tsFlowInterface,tsExportDefault
syntax match   tsFlowClassProperty  contained /\<[0-9a-zA-Z_$]*\>:\@=/ skipwhite skipempty nextgroup=tsFlowClassDef containedin=tsClassBlock
syntax region  tsFlowClassDef       contained start=/:/    end=/\%(\s*[,=;)\n]\)\@=/ contains=@tsFlowCluster skipwhite skipempty nextgroup=tsClassValue

syntax region  tsFlowModule         contained start=/module/ end=/\%({\|:\)\@=/ skipempty skipwhite nextgroup=tsFlowDeclareBlock contains=tsString
syntax region  tsFlowInterface      contained start=/interface/ end=/{\@=/ skipempty skipwhite nextgroup=tsFlowInterfaceBlock contains=@tsFlowCluster
syntax region  tsFlowDeclareBlock   contained matchgroup=tsFlowNoise start=/{/ end=/}/ contains=tsFlowDeclare,tsFlowNoise,tsComment fold

syntax match   tsFlowMaybe          contained /?/
syntax region  tsFlowInterfaceBlock contained matchgroup=tsFlowNoise start=/{/ end=/}/ contains=tsObjectKey,tsObjectKeyString,tsObjectKeyComputed,tsObjectSeparator,tsObjectFuncName,tsFlowObjectFuncName,tsObjectMethodType,tsGenerator,tsComment,tsObjectStringKey,tsSpreadExpression,tsFlowNoise,tsFlowParens,tsFlowGeneric keepend fold

syntax region  tsFlowParenAnnotation contained start=/:/ end=/[,=)]\@=/ containedin=tsParen contains=@tsFlowCluster

syntax cluster tsFlowReturnCluster            contains=tsFlowNoise,tsFlowReturnObject,tsFlowReturnArray,tsFlowReturnKeyword,tsFlowReturnGroup,tsFlowReturnMaybe,tsFlowReturnOrOp,tsFlowWildcardReturn,tsFlowReturnArrow,tsFlowTypeofReturn,tsFlowGeneric,tsFlowReturnString
syntax cluster tsFlowCluster                  contains=tsFlowArray,tsFlowObject,tsFlowExactObject,tsFlowNoise,tsFlowTypeof,tsFlowType,tsFlowGeneric,tsFlowMaybe,tsFlowParens,tsFlowOrOperator,tsFlowWildcard,tsFlowString

hi def link tsFlowDefinition         PreProc
hi def link tsFlowClassDef           tsFlowDefinition
hi def link tsFlowArgumentDef        tsFlowDefinition
hi def link tsFlowType               Type
hi def link tsFlowTypeCustom         PreProc
hi def link tsFlowTypeof             PreProc
hi def link tsFlowTypeofReturn       PreProc
hi def link tsFlowArray              PreProc
hi def link tsFlowObject             PreProc
hi def link tsFlowExactObject        PreProc
hi def link tsFlowParens             PreProc
hi def link tsFlowGeneric            PreProc
hi def link tsFlowString             PreProc
hi def link tsFlowReturnString       PreProc
hi def link tsFlowFunctionGeneric    tsFlowGeneric
hi def link tsFlowObjectGeneric      tsFlowGeneric
hi def link tsFlowReturn             PreProc
hi def link tsFlowParenAnnotation    PreProc
hi def link tsFlowReturnObject       tsFlowReturn
hi def link tsFlowReturnArray        tsFlowArray
hi def link tsFlowReturnParens       tsFlowParens
hi def link tsFlowReturnGroup        tsFlowGeneric
hi def link tsFlowClassGroup         PreProc
hi def link tsFlowClassFunctionGroup PreProc
hi def link tsFlowArrow              PreProc
hi def link tsFlowReturnArrow        PreProc
hi def link tsFlowTypeStatement      PreProc
hi def link tsFlowTypeKeyword        PreProc
hi def link tsFlowTypeOperator       Operator
hi def link tsFlowMaybe              PreProc
hi def link tsFlowReturnMaybe        PreProc
hi def link tsFlowClassProperty      tsClassProperty
hi def link tsFlowDeclare            PreProc
hi def link tsFlowExport             PreProc
hi def link tsFlowModule             PreProc
hi def link tsFlowInterface          PreProc
hi def link tsFlowNoise              Noise
hi def link tsFlowObjectKey          tsObjectKey
hi def link tsFlowOrOperator         tsOperator
hi def link tsFlowReturnOrOp         tsFlowOrOperator
hi def link tsFlowWildcard           PreProc
hi def link tsFlowWildcardReturn     PreProc
hi def link tsFlowImportType         PreProc
hi def link tsFlowTypeValue          PreProc
hi def link tsFlowReturnKeyword      PreProc
hi def link tsFlowObjectFuncName     tsObjectFuncName
