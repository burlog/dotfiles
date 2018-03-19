" class and namespaces
syntax match cppCustomNamespace "\<\w\+\s*::"me=e-2
syntax match cCustomClass       "::\s*\w\+\s*[ !@#$%^&*()+=\-~\[\]{};'\"<>,\.?/]"ms=s+2,me=e-1
syntax match cCustomClass       "\<\w\+_t\>"
syntax match cCustomClass       "\<\w\+_type\>"
syntax match cCustomClass       "\<\w\+_iterator\>"

" std namespace
syntax match cppType "std::\<\w\+\>"hs=s+5 contains=cppCustomNamespace

" some c/linux constasts
syntax keyword cConstant EALREADY EWOULDBLOCK IPPROTO_TCP TCP_NODELAY O_NONBLOCK SOCK_STREAM PF_INET F_SETFL AF_INET

" function
syn match   cCustomParen    "(" contains=cParen contains=cCppParen
syn match   cCustomFunc     "\w\+\s*(\@="
hi def link cCustomFunc  Function

" fix above for templates
"syntax match cCustomAngleBracketStart "<\_[^;()]\{-}>" contained contains=cCustomAngleBracketStart,cCustomAngleBracketEnd
"highlight link cCustomAngleBracketStart  cCustomAngleBracketContent
"
"syntax match cCustomAngleBracketEnd ">\_[^<>;()]\{-}>" contained contains=cCustomAngleBracketEnd
"highlight link cCustomAngleBracketEnd  cCustomAngleBracketContent
"
"syntax match cCustomTemplateFunc "\<\l\w*\s*<\_[^;()]\{-}>(\@="hs=s,he=e-1 contains=cCustomAngleBracketStart
"highlight link cCustomTemplateFunc  cCustomFunc
"
"syntax match cCustomTemplateClass "\<\w\+\s*<\_[^;()]\{-}>" contains=cCustomAngleBracketStart,cCustomTemplateFunc
"highlight link cCustomTemplateClass cCustomClass

" raw string literals and binary numbers
syntax region cppRawString matchgroup=cppRawDelimiter start=@\%(u8\|[uLU]\)\=R"\z([[:alnum:]_{}[\]#<>%:;.?*\+\-/\^&|~!=,"']\{,16}\)(@ end=/)\z1"/ contains=@Spell
syn match cNumber "0b[01]\+"

