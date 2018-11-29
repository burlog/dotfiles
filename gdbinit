# turn on history
set history save on
# expand history
set history expansion on
# save 100k commands in history file
set history size 100000

# allow pretty printes
set print pretty on
# print whole dynamic objects - based on vtable
set print object on
# turn off printing static members
set print static-members off
# print vtable
set print vtbl on
# allow symbol demangling
set print demangle on
# use v3 version of demangling
set demangle-style gnu-v3

# turn off loading debug symbols
# set auto-solib-add off

# decrease verbosity of gdb
set verbose off

# load python extension
python
import sys, os

USER = os.environ.get('USER')

# load pretty printers
sys.path.insert(0, '/home/' + USER + '/.gdb/gdb-python-printers/')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers(None)
from libfastrpc.printers import register_fastrpc_printers
register_fastrpc_printers(None)
from teng.printers import register_teng_printers
register_teng_printers(None)

# other python gdb extension
sys.path.insert(0, '/home/' + USER + '/.gdb/')
from voidwalker import voidwalker
from gdb_color_bt import color
end

# make promp colorfull
set extended-promp \n\[\e[01;36m\][\F] \f(\a) > \[\e[0m\]

# extend promp "variables"
python
import gdb.prompt
from gdb.FrameDecorator import FrameVars

def _prompt_frame_args(attr):
    try:
        return ",".join(arg.sym.name for arg in FrameVars(gdb.selected_frame()).fetch_frame_args())
    except gdb.error:
        return ""

def _prompt_frame_number(attr):
    try:
        i = 0
        fr = gdb.selected_frame()
        while fr.newer():
            fr = fr.newer()
            i += 1
        return i
    except gdb.error:
        return "?"

gdb.prompt.prompt_substitutions.update({
    'a': _prompt_frame_args,
    'F': _prompt_frame_number
})
end

# print ascii
define ascii_char
    if $argc != 1
        help ascii_char
    else
        set $_c = *(unsigned char *)($arg0)
        if ($_c < 0x20 || $_c > 0x7E)
            printf "."
        else
            printf "%c", $_c
        end
    end
end
document ascii_char
Print ASCII value of byte at address ADDR.
Print "." if the value is unprintable.
Usage: ascii_char ADDR
end
