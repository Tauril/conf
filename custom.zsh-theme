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
#   => \u21e1
# ↓ => \u2193
#   => \u21e3

setopt PROMPT_SUBST

autoload -U add-zsh-hook
autoload -Uz vcs_info

# Use True color (24-bit)
_silver="%F{7}"
_grey="%F{8}"
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

# Reset color.
_reset_color="%f"

# VCS style formats.
FMT_STAGED=" %{$_dark_olive_green%}●%{$_reset_color%}"
FMT_UNSTAGED=" %{$_light_golden_rod%}●%{$_reset_color%}"
FMT_ACTION="%b (%{$_steel_blue%}%a%{$_reset_color%})%c%u%m"
FMT_BASIC="%b%c%u%m"

# Git format:
# "BRANCH REBASE BEHIND AHEAD CLEAN STAGED UNSTAGED UNTRACKED STASH"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_BASIC}"
zstyle ':vcs_info:git*+set-message:*' hooks git_branch git_behind git_ahead git_clean git_untrack git_stash

# Change branch color and add fancy emote.
+vi-git_branch() {
  hook_com[branch]=" %{$_light_sea_green%} ${hook_com[branch]}%{$_reset_color%}"
}

# Check if we are behind the remote.
+vi-git_behind() {
  local _state=$(git status --porcelain -b 2> /dev/null)
  if $(echo "$_state" | grep '^## [^ ]\+ .*behind' &> /dev/null); then
    hook_com[branch]+=" %{$_silver%}↓%{$_reset_color%}"
#    hook_com[branch]+=" %{$_silver%}⇣%{$_reset_color%}"
  fi
}

# Check if we are ahead of the remote.
+vi-git_ahead() {
  local _state=$(git status --porcelain -b 2> /dev/null)
  if $(echo "$_state" | grep '^## [^ ]\+ .*ahead' &> /dev/null); then
    hook_com[branch]+=" %{$_silver%}↑%{$_reset_color%}"
#    hook_com[branch]+=" %{$_silver%}⇡%{$_reset_color%}"
  fi
}

# Check if the repository is clean.
+vi-git_clean() {
  if [ -z "$(git status --porcelain --ignore-submodules=none)" ]; then
    if [ -z "$(git ls-files --others --modified --exclude-standard)" ]; then
      hook_com[branch]+=" %{$_dark_olive_green%}✓%{$reset_color%}"
    fi
  fi
}

# Check if there are untracked elements.
+vi-git_untrack() {
  local _state=$(git status --porcelain -b 2> /dev/null)
  if $(echo "$_state" | grep -E '^\?\?' &> /dev/null); then
    hook_com[unstaged]+=" %{$_indian_red%}●%{$_reset_color%}"
  fi
}

# Check if there are stashed elements.
+vi-git_stash() {
  hook_com[misc]=""
  if [[ -s $(git rev-parse --git-dir)/refs/stash ]]; then
    hook_com[misc]=" (%{$_medium_purple%}$(git stash list 2>/dev/null | wc -l) stashed%{$reset_color%})"
  fi
}

# Compute padding to have two strings at both edges of the screen
_get_space() {
    local _str=$1$2
    local _zero='%([BSUbfksu]|([FB]|){*})'
    local _len=${#${(S%%)_str//$~_zero/}}
    local _size=$(( $COLUMNS - $_len - 1 ))
    local _space=""
    while [[ $_size -gt 0 ]]; do
        _space="$_space "
        let _size=$_size-1
    done
    echo $_space
}

# Compute the preprompt.
_preprompt() {
  local _user="%{$_grey%}#%{$reset_color%} %{$_dark_red%}%n%{$reset_color%}"
  local _path="%{$_spring_green%}%~%{$_reset_color%}"
  local _error_code=":: %(?,%{$_green%},%{$_red%})%?%{$reset_color%}"
  local _left_preprompt="${_user} ${_path} ${vcs_info_msg_0_} ${_error_code}"
  local _right_preprompt="(%*)"
  local _padding="$(_get_space $_left_preprompt $_right_preprompt)"
  print -rP "$_left_preprompt$_padding$_right_preprompt"
}

add-zsh-hook precmd vcs_info
add-zsh-hook precmd _preprompt

local _prompt="%{$_silver%}%(!.#.$)%{$_reset_color%} "

# Format:
# "# USER PATH GIT ERROR_CODE TIME" <-- preprompt
# "$                              " <-- ps1
PROMPT='${_prompt}'

# Define custom clear screen and add the widget.
# Clears the screen - Reload vcs_info - Print preprompt - Print prompt
_clear-screen() {
  clear
  vcs_info
  _preprompt
  print -rnP "${_prompt}"
}

zle -N _clear-screen
