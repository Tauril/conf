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

# Use True color (24-bit) if available.
if [[ "${terminfo[colors]}" -ge 256 ]]; then
    _turquoise="%F{73}"
    _orange="%F{179}"
    _red="%F{167}"
    _limegreen="%F{107}"
else
    _turquoise="%F{cyan}"
    _orange="%F{yellow}"
    _red="%F{red}"
    _limegreen="%F{green}"
fi

# Reset color.
_reset_color="%f"

# VCS style formats.
FMT_BRANCH=" %{$_turquoise%} %b%{$_reset_color%}"
FMT_STAGED=" %{$_limegreen%}●%{$_reset_color%}"
FMT_UNSTAGED=" %{$_orange%}●%{$_reset_color%}"
FMT_ACTION="%b (%{$_limegreen%}%a%{$_reset_color%})%c%u%m"
FMT_BASIC="%b%c%u%m"

# Git format:
# "BRANCH REBASE BEHIND AHEAD CLEAN STAGED UNSTAGED UNTRACKED STASH"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' branchformat   "${FMT_BRANCH}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_BASIC}"
zstyle ':vcs_info:git*+set-message:*' hooks git_behind git_ahead git_clean git_untrack git_stash

# Check if we are behind the remote.
+vi-git_behind() {
  local _state=$(git status --porcelain -b 2> /dev/null)
  if $(echo "$_state" | grep '^## [^ ]\+ .*behind' &> /dev/null); then
    hook_com[branch]+=" ↓"
#    hook_com[branch]+=" ⇣"
  fi
}

# Check if we are ahead of the remote.
+vi-git_ahead() {
  local _state=$(git status --porcelain -b 2> /dev/null)
  if $(echo "$_state" | grep '^## [^ ]\+ .*ahead' &> /dev/null); then
    hook_com[branch]+=" ↑"
#    hook_com[branch]+=" ⇡"
  fi
}

# Check if the repository is clean.
+vi-git_clean() {
  if [ -z "$(git status --porcelain --ignore-submodules=none)" ]; then
    if [ -z "$(git ls-files --others --modified --exclude-standard)" ]; then
      hook_com[branch]+=" %{$fg[green]%}✓%{$reset_color%}"
    fi
  fi
}

# Check if there are untracked elements.
+vi-git_untrack() {
  local _state=$(git status --porcelain -b 2> /dev/null)
  if $(echo "$_state" | grep -E '^\?\?' &> /dev/null); then
    hook_com[unstaged]+=" %{$_red%}●%{$_reset_color%}"
  fi
}

# Check if there are stashed elements.
+vi-git_stash() {
  if [[ -s $(git rev-parse --git-dir)/refs/stash ]]; then
    hook_com[misc]=" ($(git stash list 2>/dev/null | wc -l) stashed)"
  fi
}

add-zsh-hook precmd vcs_info

local _user="%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} %{$fg[cyan]%}%n%{$reset_color%}"
local _path="%{$_limegreen%}%~%{$_reset_color%}"
local _error_code=":: %(?,%{$fg[green]%},%{$fg[red]%})%?%{$reset_color%}"
local _prompt="%(?.%{%F{white}%}.%{$_red%})%(!.#.$)%{$_reset_color%}"

# Prompt format:
# "# USER PATH GIT ERROR_CODE TIME
#  $                              "
PROMPT=$'${_user} ${_path} ${vcs_info_msg_0_} ${_error_code}\n${_prompt} '
RPROMPT='(%*)'
