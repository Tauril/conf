# Prompt:
# %F => Color codes
# %f => Reset color
# %~ => Current path
# %(x.true.false) => Specifies a ternary expression
#   ! => True if the shell is running with root privileges
#   ? => True if the exit status of the last command was success
#
# Git:
# %a => Current action (rebase/merge)
# %b => Current branch
# %c => Staged changes
# %u => Unstaged changes
# %m => misc
#
#  => \uE0A0
# ✓ => \u2713
# ↑ => \u2191
# ⇡ => \u21e1
# ↓ => \u2193
# ⇣ => \u21e3
# ● => \u25cf

setopt PROMPT_SUBST

autoload -U add-zsh-hook
autoload -Uz vcs_info

# Use True color (24-bit)
_black="%F{0}"
_green="%F{22}"
_spring_green="%F{35}"
_steel_blue="%F{68}"
_light_sea_green="%F{37}"
_dark_red="%F{88}"
_dark_olive_green="%F{107}"
_medium_purple="%F{140}"
_indian_red="%F{167}"
_light_golden_rod="%F{179}"
_red="%F{196}"
_grey="%F{246}"

# Reset color.
_reset_color="%f"

# Git format:
# "BRANCH REBASE BEHIND AHEAD CLEAN STAGED UNSTAGED UNTRACKED STASH"
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' actionformats  "%b (%{$_steel_blue%}%a%{$_reset_color%})%c%m"
zstyle ':vcs_info:*' formats        "%b%c%m"
zstyle ':vcs_info:git*+set-message:*' hooks git_branch git_remote_status git_local_status git_stash

# Change branch color and add fancy emote.
+vi-git_branch() {
  hook_com[branch]=" %{$_light_sea_green%} ${hook_com[branch]}%{$_reset_color%}"
}

+vi-git_remote_status() {
  # First try to retrieve the remote from upstream.
  local _remote=${$(command git rev-parse --verify ${hook_com[branch_orig]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
  # If upstream is not set, try to find the remote from the default origin.
  if [ -z $remote ]; then
    _remote=${$(command git rev-parse --verify origin/${hook_com[branch_orig]} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
  fi

  if [ -n $remote ]; then
    # Are we behind?
    if [ $(command git rev-list HEAD..$_remote 2>/dev/null | wc -l) -ne 0 ]; then
      hook_com[branch]+=" %{$_grey%}↓%{$_reset_color%}"
    fi
    # Are we ahead?
    if [ $(command git rev-list $_remote..HEAD 2>/dev/null | wc -l) -ne 0 ]; then
      hook_com[branch]+=" %{$_grey%}↑%{$_reset_color%}"
    fi
  fi
}

+vi-git_local_status() {
  # Check if the repository is clean.
  if [[ -z "$(command git status --porcelain --ignore-submodules=none)" &&
       -z "$(command git ls-files --others --modified --exclude-standard)" ]]; then
    hook_com[staged]=" %{$_dark_olive_green%}✓%{$_reset_color%}"
  else
    local _state=$(command git status --porcelain -b 2> /dev/null)
    # Check if there are staged elements.
    if $(echo "$_state" | grep '^[ADCMRU]' &> /dev/null); then
      hook_com[staged]=" %{$_dark_olive_green%}●%{$_reset_color%}"
    fi
    # Check if there are unstaged elements.
    if $(echo "$_state" | grep '^.[ADCMRU]' &> /dev/null); then
      hook_com[staged]+=" %{$_light_golden_rod%}●%{$_reset_color%}"
    fi
    # Check if there are untracked elements.
    if $(echo "$_state" | grep -E '^\?\?' &> /dev/null); then
      hook_com[staged]+=" %{$_indian_red%}●%{$_reset_color%}"
    fi
  fi
}

# Check if there are stashed elements.
+vi-git_stash() {
  if [[ -s $(command git rev-parse --git-dir)/refs/stash ]]; then
    hook_com[misc]=" (%{$_medium_purple%}$(git stash list 2>/dev/null | wc -l) stashed%{$_reset_color%})"
  else
    hook_com[misc]=""
  fi
}

add-zsh-hook precmd vcs_info
add-zsh-hook precmd _preprompt

# Compute padding to have two strings at both edges of the screen
_get_space() {
  local _venv=""
  if [[ -n "$VIRTUAL_ENV" ]]; then
    local _venv="($(basename $VIRTUAL_ENV)) "
  fi
  local _str=$_venv$1$2
  local _zero='%([BSUbfksu]|([FB]|){*})'
  local _len=${#${(S%%)_str//$~_zero/}}
  local _padding=$(($COLUMNS - $_len - 1))

  # If we are missing space on the first line, add an extra line
  if [[ $_padding -lt 0 ]]; then
    _padding=$(($_padding + $COLUMNS))
  fi

  echo ${(l:$_padding:: :)}
}

# Compute the preprompt.
_preprompt() {
  local _error_code=$?
  local _user="%{$_black%}#%{$_reset_color%} %{$_dark_red%}%n%{$_reset_color%}"
  local _path="%{$_spring_green%}%~%{$_reset_color%}"
  local _git="$vcs_info_msg_0_"
  local _error=":: %(?,%{$_green%},%{$_red%})$_error_code%{$reset_color%}"
  local _time="(%*)"
  local _left_preprompt="$_user $_path $_git $_error"
  local _right_preprompt="$_time"
  local _padding="$(_get_space $_left_preprompt $_right_preprompt)"
  _preprompt="$_left_preprompt$_padding$_right_preprompt"
}

local _prompt="%{$_grey%}%(!.#.$)%{$_reset_color%} "

# Format:
# "# USER PATH GIT ERROR_CODE TIME" <-- preprompt
# "$                              " <-- ps1
PROMPT=$'$_preprompt\n$_prompt'

# Define custom reset-prompt screen and add the widget.
# This allows the clock to display the actual time a command was executed at.
# The accept-line zle is what Enter is bound to by default, so we include it
# in the custom zle since this is what Enter will be bound to.
_reset-prompt() {
  zle reset-prompt
  zle accept-line
}

zle -N _reset-prompt
bindkey '^M' _reset-prompt
