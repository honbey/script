au BufRead,BufNewFile *.test set ft=test

if exists("b:current_syntax")
  finish
endif

syn keyword testComment Commentkeyword
hi def link testComment Comment

syn keyword testConstant Constantkeyword
hi def link testConstant Constant
syn keyword testString Stringkeyword
hi def link testString String
syn keyword testCharacter Characterkeyword
hi def link testCharacter Character
syn keyword testNumber Numberkeyword
hi def link testNumber Number
syn keyword testBoolean Booleankeyword
hi def link testBoolean Boolean
syn keyword testFloat Floatkeyword
hi def link testFloat Float

syn keyword testIdentifier Identifierkeyword
hi def link testIdentifier Identifier
syn keyword testFunction Functionkeyword
hi def link testFunction Function

syn keyword testStatement Statementkeyword
hi def link testStatement Statement
syn keyword testConditional Conditionalkeyword
hi def link testConditional Conditional
syn keyword testRepeat Repeatkeyword
hi def link testRepeat Repeat
syn keyword testLabel Labelkeyword
hi def link testLabel Label
syn keyword testOperator Operatorkeyword
hi def link testOperator Operator
syn keyword testKeyword Keywordkeyword
hi def link testKeyword Keyword
syn keyword testException Exceptionkeyword
hi def link testException Exception

syn keyword testPreProc PreProckeyword
hi def link testPreProc PreProc
syn keyword testInclude Includekeyword
hi def link testInclude Include
syn keyword testDefine Definekeyword
hi def link testDefine Define
syn keyword testMacro Macrokeyword
hi def link testMacro Macro
syn keyword testPreCondit PreConditkeyword
hi def link testPreCondit PreCondit

syn keyword testType Typekeyword
hi def link testType Type
syn keyword testStorageClass StorageClasskeyword
hi def link testStorageClass StorageClass
syn keyword testStructure Structurekeyword
hi def link testStructure Structure
syn keyword testTypedef Typedefkeyword
hi def link testTypedef Typedef

syn keyword testSpecial Specialkeyword
hi def link testSpecial Special
syn keyword testSpecialChar SpecialCharkeyword
hi def link testSpecialChar SpecialChar
syn keyword testTag Tagkeyword
hi def link testTag Tag
syn keyword testDelimiter Delimiterkeyword
hi def link testDelimiter Delimiter
syn keyword testSpecialComment SpecialCommentkeyword
hi def link testSpecialComment SpecialComment
syn keyword testDebug Debugkeyword
hi def link testDebug Debug

syn keyword testUnderlined Underlinedkeyword
hi def link testUnderlined Underlined

syn keyword testIgnore Ignorekeyword
hi def link testIgnore Ignore

syn keyword testError Errorkeyword
hi def link testError Error

syn keyword testTodo Todokeyword
hi def link testTodo Todo

let b:current_syntax = 'test'
