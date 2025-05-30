# aliases
alias ebp=/home/burlog/git/email/util/src/email-buildpackage
alias xmlrpc-netcat="xmlrpc-netcat3"

# I want cores
ulimit -c unlimited

# color codes explained: https://en.wikipedia.org/wiki/ANSI_escape_code
export GREP_COLORS='ms=01;33:mc=01;31:sl=32:cx=:fn=01;30:ln=36:se='
export GCC_COLORS="error=1;38;5;124:warning=1;38;5;202:note=38;5;34:locus=48;5;22;38;5;0:quote=38;5;33"

# exported variables
export PKG_CONFIG_PATH=/usr/lib64/pkgconfig/:/usr/local/lib64/pkgconfig:/usr/local/lib64/pkgconfig.szn/:/usr/local/share/pkgconfig/
export LOG_MASK=A
export LOG_STDERR=1
export SZN_LOCALITY=go

# pyenv initialization
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
