# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="custom"

plugins=(git)

source $ZSH/oh-my-zsh.sh

#setxkbmap us -option 'caps:swapescape' -variant altgr-intl
setxkbmap gb -option 'caps:swapescape'
xset r rate 300 50

#alias sshfencepost="ssh tauril@fencepost.gnu.org"

# ctrl+u remove before cursor
bindkey \^U backward-kill-line

# Beep beep boop
finish() {
  spd-say "finished $1"
}

# Source every timernal when .zshrc gets modified
precmd() { eval "$PROMPT_COMMAND" }
zshrc_sourced=$(stat -c %Y ~/set-up-environment/conf/.zshrc)
PROMPT_COMMAND='test $(stat -c %Y ~/set-up-environment/conf/.zshrc) -ne \
  $zshrc_sourced && source ~/.zshrc'
