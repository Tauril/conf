# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="custom"

plugins=(git zsh-256color)

source $ZSH/oh-my-zsh.sh

#setxkbmap us -option 'caps:swapescape' -variant altgr-intl
setxkbmap gb -option 'caps:swapescape'
xset r rate 300 50

#alias sshfencepost="ssh tauril@fencepost.gnu.org"

# ctrl+u remove before cursor
bindkey '^U' backward-kill-line
# ctrl_l custom clear-screen defiend in custom zsh theme
bindkey '^L' _clear-screen

# Beep beep boop
finish() {
  spd-say "finished $1"
}
