# vim: ft=zsh ts=2 sw=2 sts=2 expandtab
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'

# Begin a segment
# Takes three arguments, background, foreground and intensity flag. All can be omitted,
# rendering default background/foreground/intensity.
prompt_segment() {
  local bg fg
  [[ -n $2 ]] && bg="%K{$2}" || bg="%k"
  [[ -n $3 ]] && fg="%F{$3}" || fg="%f"
  [[ -n $4 ]] && fg="%B$fg" || fg="%b$fg"
  if [[ $CURRENT_BG != 'NONE' && $2 != $CURRENT_BG ]]; then
    #echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
    echo -n " %{$bg%F{$CURRENT_BG}%}%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$2
  [[ -n $1 ]] && echo -n $1
}

# Start the prompt
prompt_start() {
  echo -n "%{%b%F{blue}%}┣━%{%f%b%k%}%{%f%b%k%}"
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%}"
  else
    echo -n "%{%k%}"
  fi
  local color
  if [[ $RETVAL -ne 0 ]]; then
    color="%{%B%F{red}%}❢%F{yellow} "
  fi
  echo -n "$color❱%{%f%b%k%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user host
  if [[ "$USER" != "$DEFAULT_USER" ]]; then
    user="%(!.%{%F{red}%}.)$USER"
  fi
  if [[ -n "$SSH_CLIENT" ]]; then
    host="@%M"
  fi
  if [[ -n "$user$host" ]]; then
    prompt_segment "$user$host" default white 1
  fi
}

setopt promptsubst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '%b'
zstyle ':vcs_info:*' actionformats '%b▶%a'

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  local dirty git_status stash color
  if git_status="$(git status --porcelain 2>/dev/null)"; then
    dirty=$(parse_git_dirty)
    if [[ -n $dirty ]]; then
      local unstaged="$(echo "$git_status" | grep '^.[^[:space:]]' -c)"
      if [[ $unstaged -gt 0 ]]; then
        color="yellow"
      else
        color="cyan"
      fi
    else
      color="green"
    fi
    if git stash show -s 2>/dev/null; then
      stash="%{%B%F{cyan}%}∗%{%b%F{$color}%}"
    fi
    vcs_info
    prompt_segment "" default $color
    echo -n "[${vcs_info_msg_0_}$stash]"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment "%4~" default yellow intensive
}

# Time: current time
prompt_time() {
  prompt_segment "%T" default yellow
}

# Battery: battery level
battery_level() {
  local charging_symbol
  if [[ $(acpi 2>/dev/null | grep -c '^Battery.*Discharging') -gt 0 ]]; then
    if [[ $(battery_pct_remaining) -le 5 ]]; then
      prompt_segment "⚡◯" default red 1
    elif [[ $(battery_pct_remaining) -le 10 ]]; then
      prompt_segment "⚡◯" default yellow 1
    elif [[ $(battery_pct_remaining) -le 25 ]]; then
      prompt_segment "⚡◯" default green
    elif [[ $(battery_pct_remaining) -le 50 ]]; then
      prompt_segment "⚡◔" default green
    elif [[ $(battery_pct_remaining) -le 75 ]]; then
      prompt_segment "⚡◑" default green
    elif [[ $(battery_pct_remaining) -le 99 ]]; then
      prompt_segment "⚡◕" default green
    else
      prompt_segment "⚡●" default green
    fi
  fi
}

# Status: of last command
prompt_status() {
  local symbols
  symbols=()

  # result of last command
  [[ $RETVAL -ne 0 ]] && symbols+="%{%B%F{red}%}❢$RETVAL"

  # fs usage
  fs_usage="$(df "`pwd`" --output=pcent |  grep -o "[0-9]\+")"
  [[ $fs_usage -gt 95 ]] && symbols+="%{%B%F{red}%}💾$fs_usage%%"

  [[ -n "$symbols" ]] && prompt_segment "$symbols" default
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_start
  prompt_git
  prompt_dir
  prompt_end
}

PROMPT='$(build_prompt) '

## Main right prompt
build_rprompt() {
  RETVAL=$?
  prompt_status
  battery_level
  prompt_context
  prompt_time
}

RPROMPT=' %{%f%b%k%}$(build_rprompt) '

