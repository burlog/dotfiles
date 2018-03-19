
# I want preserve the syntax-highlighting.zsh placing in the
# ~/.oh-my-zsh/custom directory but the oh-my-zsh run all scripts in that
# directory in random order wich is in conflict with the zsh syntax
# highlighting plugin requirements. The plugin has to be the last because it
# wraps a lot of zsh zle.* stuff and any zle changes does not work after
# wrapping.

if [ "$1" = "run" ]; then
    source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)

    ZSH_HIGHLIGHT_STYLES[path]="fg=33"
    ZSH_HIGHLIGHT_STYLES[globbing]="fg=202"
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=99"
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]="fg=124"
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=99"
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]="fg=124"
    ZSH_HIGHLIGHT_STYLES[cursor]='fg=202'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=220'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=11'
fi

