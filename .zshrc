# zsh config
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="custom"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ctrl+u remove before cursor
bindkey '^U' backward-kill-line

export SDKROOT=`xcrun -sdk macosx.internal --show-sdk-path`

export PATH="$PATH":/Users/guillaumemarques/Arcanist/arcanist/bin
export EDITOR=/usr/bin/vim

svngrep() { grep  --color=always --exclude-dir=".svn" -r $1 $2 $3 | less -R; }

eval `ssh-agent -s`
ssh-add
