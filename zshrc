# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=/home/burlog/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="burlog"
DEFAULT_USER="burlog"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"
CORRECT_IGNORE_FILE=".*"
CORRECT_IGNORE="_*"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    autojump
    battery
    colored-man-pages
    colorize
    docker
    docker-compose
    docker-machine
    kops
    kubectl
    pip
    sudo
    tig
    zsh-autosuggestions
    zsh-completions
)

source $ZSH/oh-my-zsh.sh

# User configuration

export MANPATH="/usr/local/man:$MANPATH"

# git-clone-zsh-completion variables
GIT_CLONE_ZSH_CMPL_AUTH_TOKEN="`cat ~/.gitlab.kancelar.seznam.cz.private.token 2>/dev/null`"
GIT_CLONE_ZSH_CMPL_HOST="gitlab.kancelar.seznam.cz"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
EDITOR=vim
TERM=xterm-256color

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# identity path for ssh agent
export SSH_KEY_PATH="~/.ssh/rsa_id"

# automatic escape url danger chars
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias sl="ls"
alias c="cd .."
alias df="df -h"
alias pine=alpine
function findn() { find -L $1 -name "*$2*" ; }
function zv() { sed "s/$1/[01;31m&[01;0m/g" }

# HAVE TO BE LAST BECAUSE WRAPS A LOT OF ZSH STUFF
source ~/.oh-my-zsh/custom/syntax-highlighting.zsh run

