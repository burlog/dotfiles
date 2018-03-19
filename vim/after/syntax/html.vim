" Vim syntax file
"
" Language:	HTML with teng extension
" Maintainer:	Michal Bukovsky <michal.bukovsky@firma.seznam.cz>
"

syn cluster htmlPreproc add=tengClausule

syn keyword tengKeyword1 contained  if else elseif frag endfrag endif include
syn keyword tengKeyword1 contained  format set case
syn keyword tengKeyword2 contained  exist date escape int isenabled
syn keyword tengKeyword2 contained  isnumber len nl2br now numformat random
syn keyword tengKeyword2 contained  reorder round sectotime substr unescape
syn keyword tengKeyword2 contained  urlescape wordsubstr

syn match tengStart1 "<?teng"
syn match tengEnd1 "?>"

syn match tengStart2 "${"
syn match tengEnd2 "}"

syn match tengDict "#{[^}]*}"

syn region tengClausule start=+\s*<?teng+ end=+?>+ contains=tengKeyword1,tengKeyword2,htmlString,tengStart1,tengEnd1,tengStart2,tengEnd2,tengDict keepend
syn region tengClausule start=+\s*${+ end=+}+ contains=tengKeyword1,tengKeyword2,htmlString,tengStart1,tengEnd1,tengStart2,tengEnd2,tengDict keepend

hi def link tengKeyword1 Statement
hi def link tengKeyword2 Type
hi def link tengStart1 Comment
hi def link tengEnd1 Comment
hi def link tengStart2 Comment
hi def link tengEnd2 Comment
hi def link tengDict Constant

