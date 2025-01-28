# enable some highlighters
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(cursor regexp)

# highlight sudo command
typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_REGEXP+=('\bsudo\b' bg=red,bold)

# highlight cursor background
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[cursor]='fg=202'

# unknown-token
# reserved-word
# alias
# suffix-alias
# global-alias
# builtin
# function
# command
# precommand
# commandseparator
# hashed-command
# autodirectory
ZSH_HIGHLIGHT_STYLES[path]="fg=#88a000"
# path_pathseparator
# path_prefix
# path_prefix_pathseparator
ZSH_HIGHLIGHT_STYLES[globbing]="fg=#ffcc00"
# history-expansion
# command-substitution
# command-substitution-unquoted
# command-substitution-quoted
# command-substitution-delimiter
# command-substitution-delimiter-unquoted
# command-substitution-delimiter-quoted
# process-substitution
# process-substitution-delimiter
# arithmetic-expansion
# single-hyphen-option
# double-hyphen-option
# back-quoted-argument
# back-quoted-argument-unclosed
# back-quoted-argument-delimiter
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#afafff"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]="fg=#b32240"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#afafff"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]="fg=#b32240"
# dollar-quoted-argument
# dollar-quoted-argument-unclosed
# rc-quote
# dollar-double-quoted-argument
# back-double-quoted-argument
# back-dollar-quoted-argument
# assign
# redirection
ZSH_HIGHLIGHT_STYLES[comment]="fg=#0087af"
# named-fd
# numeric-fd
# arg0
# default
