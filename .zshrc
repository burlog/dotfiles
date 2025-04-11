# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="$HOME/.oh-my-zsh.custom"
ZSH_CACHE_DIR="/tmp/oh-my-zsh.$USER"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    # battery
    # branch
    command-not-found
    docker
    # emoji
    # git-prompt
    # grc
    kubectl
    kubectx
    # kube-ps1
    ssh-agent
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Let Oh My Zsh do its work
source $ZSH/oh-my-zsh.sh

# User configuration for python
export PYTHONSTARTUP="$HOME/.pythonrc.py"

# User configuration
export DEFAULT_USER="burlog"

# Enable time stamps in history
setopt extendhistory
# Appends every command to the history file once it is executed
setopt inc_append_history
# Shares history between all sessions
setopt share_history
# Avoids duplicates in the history file
setopt hist_ignore_all_dups
# Sets the maximum number of lines contained in the history file
export HISTSIZE=100000
# Sets the maximum number of lines contained in the history list
export SAVEHIST=100000

# Switch term to use more than 8 colors
export TERM="xterm-256color"

# The basic aliases
alias sl="ls"
alias c="cd .."
alias vi="vim -o"
alias vim="vim -o"

# Force stupid go to put binaries into hidden directory
export GOPATH=~/.go
