" Vim syntax file
" Language:	Seznam XMLRPC help file
" Maintainer:	Michal Bukovsky <michal.bukovsky@firma.seznam.cz>
" URL:		...
" Last Change:  2006-10-24 (bukovsky)

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

" Klicova slova...
syn match xmlrpchelpnumber "\<[0-9]*\>"
syn match xmlrpchelpmethod1 "^[^ ]*$"
syn match xmlrpchelpsection "^[^ ]*:\s*$"
syn match xmlrpchelpmethod2 contained "^\s*[^(]*"
syn region xmlrpchelpmethodregion start="^\(\s*\|\s*struct\s*\)[^ ]*(.*" end="$" contains=xmlrpchelpmethod2,xmlrpchelpkeyword
syn match xmlrpchelpdot "^\.$"
syn region xmlrpchelpstring start=+"+ skip=+\\"+ end=+"+
syn region xmlrpchelpstring start=+`+ skip=+\\'+ end=+'+
syn region xmlrpchelpstring start=+`+ skip=+\\'+ end=+`+
syn keyword xmlrpchelpkeyword int double string array struct dateTime boolean binary base64 iso8601 bool datetime DateTime
syn match xmlrpchelpcomment "#.*$"

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_xmlrpchelp_syn_inits")
	if version < 508
		let did_xmlrpchelp_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif

        HiLink xmlrpchelpkeyword Type
        HiLink xmlrpchelpsection Keyword
        HiLink xmlrpchelpmethod1 Function
        HiLink xmlrpchelpmethod2 Function
        HiLink xmlrpchelpdot     Error
        HiLink xmlrpchelpnumber  Number
        HiLink xmlrpchelpstring  String
        HiLink xmlrpchelpcomment Comment

	delcommand HiLink
endif

let b:current_syntax = "xmlrpchelp"
