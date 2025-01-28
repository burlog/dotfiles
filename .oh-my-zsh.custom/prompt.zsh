# Thanks to:
# https://www.reddit.com/r/zsh/comments/cgbm24/multiline_prompt_the_missing_ingredient/

BURLOG_PROMPT_CURRENT_BG=''

# Usage: prompt-length RESULT TEXT [COLUMNS]
#
# If you run `print -P TEXT`, how many characters will be printed on the last
# line?
#
# Or, equivalently, if you set PROMPT=TEXT with prompt_subst option unset, on
# which column will the cursor be?
#
# The second argument specifies terminal width. Defaults to the real terminal
# width.
#
# The result is stored in a variable with the name given in the RESULT arg.
#
# Assumes that `%{%}` and `%G` don't lie.
#
# Examples:
#   prompt-length ''            => 0
#   prompt-length 'abc'         => 3
#   prompt-length $'abc\nxy'    => 2
#   prompt-length '❎'          => 2
#   prompt-length $'\t'         => 8
#   prompt-length $'\u274E'     => 2
#   prompt-length '%F{red}abc'  => 3
#   prompt-length $'%{a\b%Gb%}' => 1
#   prompt-length '%D'          => 8
#   prompt-length '%1(l..ab)'   => 2
#   prompt-length '%(!.a.)'     => 1 if root, 0 if not
#
function prompt-length() {
    emulate -L zsh
    local -i x y=${#2} m
    if (( y )); then
        while (( ${${(%):-$2%$y(l.1.0)}[-1]} )); do
            x=y
            (( y *= 2 ))
        done
        while (( y > x + 1 )); do
            (( m = x + (y - x) / 2 ))
            (( ${${(%):-$2%$m(l.x.y)}[-1]} = m ))
        done
    fi
    typeset -i -g "$1=$x"
}

# Usage: fill-line RESULT LEFT RIGHT
#
# Returns LEFT<spaces>RIGHT with enough spaces in # the middle to fill a
# terminal line.
#
# The result is stored in a variable with the name given in the RESULT arg.
#
function fill-line() {
    emulate -L zsh
    local left_len right_len
    prompt-length left_len $1
    prompt-length right_len $2 9999
    local -i pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1}))
    if (( pad_len < 1 )); then
        # Not enough space for the right part. Drop it.
        echo "$1"
    else
        local pad=${(pl.$pad_len.. .)}  # pad_len spaces
        echo "${1}${pad}${2}"
    fi
}

# Usage: prompt-segment ARGUMENT BACKGROUND FOREGROUND INTENSITY
#
# Prints segment string.
#
function prompt-segment() {
    emulate -L zsh
    local arg bg fg
    [[ -n $1 ]] && arg="$1"
    [[ -n $2 ]] && bg="%K{$2}" || bg="%k"
    [[ -n $3 ]] && fg="%F{$3}" || fg="%f"
    [[ -n $4 ]] && fg="%B$fg"  || fg="%b$fg"
    local current_bg="$BURLOG_PROMPT_CURRENT_BG"
    if [[ $current_bg != "NONE" && $2 != $current_bg ]]; then
        echo -n "%{$bg%F{$current_bg}%}%{$fg%}$arg"
    else
        echo -n "%{$bg%}%{$fg%}$arg"
    fi
    BURLOG_PROMPT_CURRENT_BG=$2
}

# Usage: prompt-start LEADER
#
# Prints the prompt leader.
#
function prompt-start() {
    emulate -L zsh
    echo -n "%{%b%F{blue}%}$1%{%f%b%k%}"
}

# Usage: promp-end
#
# Prints the prompt end with closes any open segments.
#
function prompt-end() {
    emulate -L zsh
    echo -n "%{%k%}%{%f%b%k%}"
    BURLOG_PROMPT_CURRENT_BG=""
}

# Usage: prompt-dir
#
# Prints current working directory.
#
function prompt-dir() {
    emulate -L zsh
    prompt-segment "%4~" default yellow intensive
}

# Usage: prompt-prompt
#
# Prints current prompt.
#
function prompt-prompt() {
    emulate -L zsh
    prompt-segment "❱" default "%(?.yellow.red)" intensive
}

# Usage: prompt-time
#
# Prints current time.
#
function prompt-time() {
    emulate -L zsh
    prompt-segment "%T" default yellow
}

# Usage: prompt-battery-level
#
# Prints current battery level.
#
function prompt-battery-level() {
    emulate -L zsh
    local charging_path="/sys/class/power_supply/BAT0/status"
    local capacity_path="/sys/class/power_supply/BAT0/capacity"
    if [[ -r $capacity_path ]]; then
        local battery_pct_remaining="$(cat $capacity_path)"
        if [[ -r $charging_path ]]; then
            local battery_state="$(cat $charging_path)"
        fi
        if [[ "$battery_state" = "Charging" ]]; then
            prompt-segment "⮬" default green
        fi
        if [[ ${battery_pct_remaining} -le 5 ]]; then
            prompt-segment "◯" default red intensive
        elif [[ ${battery_pct_remaining} -le 10 ]]; then
            prompt-segment "◯" default yellow intensive
        elif [[ ${battery_pct_remaining} -le 25 ]]; then
            prompt-segment "◯" default green
        elif [[ ${battery_pct_remaining} -le 50 ]]; then
            prompt-segment "◔" default green
        elif [[ ${battery_pct_remaining} -le 75 ]]; then
            prompt-segment "◑" default green
        elif [[ ${battery_pct_remaining} -le 99 ]]; then
            prompt-segment "◕" default green
        else
            prompt-segment "●" default green
        fi
    fi
    if [[ "$battery_state" = "Discharging" ]]; then
        prompt-segment "⮯" default "#fc4903"
    fi
}

# Usage: prompt-host
#
# Prints the current user@host.
#
function prompt-host() {
    local user host
    if [[ "$USER" != "$DEFAULT_USER" ]]; then
        user="%(!.%{%F{red}%}.)$USER"
    fi
    if [[ -n "$SSH_CLIENT" ]]; then
        host="%M"
    fi
    if [[ -n "$user$host" ]]; then
        prompt-segment "$user@$host" default white intensive
    fi
}

# Usage: prompt-git-branch
#
# Taken from oh-my-zsh git-prompt plugin.
#
# Prints current branch name and a lot of other stuff.
#
local function prompt-git-branch() {
    emulate -L zsh
    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}["
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}]"
    ZSH_THEME_GIT_PROMPT_SEPARATOR="%{$fg[blue]%}|"
    ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[green]%}"
    ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}%{∉%G%}"
    ZSH_THEME_GIT_PROMPT_STAGED="%F{#5674fc}%{✚%G%}"
    ZSH_THEME_GIT_PROMPT_DELETED="%F{#fc4903}%{−%G%}"
    ZSH_THEME_GIT_PROMPT_CHANGED="%F{#93fc56}%{●%G%}"
    ZSH_THEME_GIT_PROMPT_BEHIND="%{🡓%G%}"
    ZSH_THEME_GIT_PROMPT_AHEAD="%{🡑%G%}"
    ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[yellow]%}%{⚑%G%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"
    ZSH_THEME_GIT_PROMPT_UPSTREAM_SEPARATOR="->"

    unset __CURRENT_GIT_STATUS
    _GIT_STATUS=$(python3 ~/.oh-my-zsh/plugins/git-prompt/gitstatus.py 2>/dev/null)
    __CURRENT_GIT_STATUS=("${(@s: :)_GIT_STATUS}")
    GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
    GIT_AHEAD=$__CURRENT_GIT_STATUS[2]
    GIT_BEHIND=$__CURRENT_GIT_STATUS[3]
    GIT_STAGED=$__CURRENT_GIT_STATUS[4]
    GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
    GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
    GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
    GIT_STASHED=$__CURRENT_GIT_STATUS[8]
    GIT_CLEAN=$__CURRENT_GIT_STATUS[9]
    GIT_DELETED=$__CURRENT_GIT_STATUS[10]

    if [ -n "$__CURRENT_GIT_STATUS" ]; then
      STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH$GIT_UPSTREAM%{${reset_color}%}"
      if [ "$GIT_BEHIND" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND%{${reset_color}%}"
      fi
      if [ "$GIT_AHEAD" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD%{${reset_color}%}"
      fi
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
      if [ "$GIT_CONFLICTS" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
      fi
      if [ "$GIT_UNTRACKED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED$GIT_UNTRACKED%{${reset_color}%}"
      fi
      if [ "$GIT_STAGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
      fi
      if [ "$GIT_DELETED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_DELETED$GIT_DELETED%{${reset_color}%}"
      fi
      if [ "$GIT_CHANGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
      fi
      if [ "$GIT_STASHED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STASHED$GIT_STASHED%{${reset_color}%}"
      fi
      if [ "$GIT_CLEAN" -eq "1" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
      fi
      STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
      echo -n "$STATUS"
    fi
}

# Usage: prompt-disk-warning
#
# Prints warning icon if disk is almost full.
#
function prompt-disk-warning() {
    local usage="$(df "$(pwd)" --output=pcent | grep -o "[0-9]\+")"
    if [[ $usage -gt 95 ]]; then
        echo -n "%{%B%F{red}%}🖴 $usage%%"
    fi
}

# Usage: prompt-ram-warning
#
# Prints warning icon if ram is almost full.
#
function prompt-ram-warning() {
    local -i usage="$(free | grep Mem | awk '{print $3/$2 * 100.0}')"
    if [[ $usage -gt 95 ]]; then
        echo -n "%{%B%F{red}%}≣$usage%%"
    elif [[ $usage -gt 85 ]]; then
        echo -n "%{%B%F{yellow}%}≣$usage%%"
    fi
}

# Usage: prompt-kubectx-info
#
# Prints current k8s context
#
function prompt-kubectx-info() {
    if [ $(find ~/.kube/config -type f -mmin -60 | wc -l) -gt 0 ]; then
        echo -n "%{%B%F{#6e4b03}%} `kubectx -c`"
    fi
}

# Usage: build-top-left
#
# Prints bottom left prompt.
#
function build-top-left() {
    emulate -L zsh
    local elements=()
    elements+="$(prompt-start "╲")"
    elements+="$(prompt-host)"
    elements+="$(prompt-git-branch)"
    elements+="$(prompt-kubectx-info)"
    elements+="$(prompt-end)"
    echo -n "${(@j[ ])elements:#}"
}

# Usage: build-top-right
#
# Prints top right prompt.
#
function build-top-right() {
    emulate -L zsh
    local elements=()
    elements+="$(prompt-disk-warning)"
    elements+="$(prompt-ram-warning)"
    elements+="$(prompt-battery-level)"
    elements+="$(prompt-time)"
    elements+="$(prompt-end)"
    echo -n "${(@j[ ])elements:#}"
}

# Usage: build-bottom-left
#
# Prints bottom left prompt.
#
function build-bottom-left() {
    emulate -L zsh
    local elements=()
    elements+="$(prompt-start "╱")"
    elements+="$(prompt-dir)"
    elements+="$(prompt-prompt)"
    elements+="$(prompt-end)"
    echo -n "${(@j[ ])elements:#}"
}

# Usage: build-bottom-right
#
# Prints bottom right prompt.
#
function build-bottom-right() {
    emulate -L zsh
}

# Sets PROMPT and RPROMPT.
#
# Requires: prompt_percent and no_prompt_subst.
#
function set-prompt() {
    emulate -L zsh

    # online/offline
    # kubectx ale jen kdyz jsem lognutej
    # pyenv / venv

    # build prompt
    local new_line=$'\n'
    local top_line="$(fill-line "$(build-top-left)" "$(build-top-right)")"
    PROMPT="${top_line}${new_line}$(build-bottom-left)"
    RPROMPT="$(build-bottom-right)"
}

setopt no_prompt_{bang,subst} prompt_{cr,percent,sp}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set-prompt
