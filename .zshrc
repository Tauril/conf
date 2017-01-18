xrdb ~/.Xdefaults
export NAME=''
export FULLNAME=$NAME
export EMAIL="$USER@yaka.epita.fr"
export REPLYTO=$EMAIL

export PATH=~/.local/bin:~/bin:~/.gem/ruby/2.2.0/bin:~/.gem/ruby/2.1.0/bin:$PATH
export PATH="$PATH:$HOME/.npm-packages/bin"
export PATH="$PATH:$HOME/.meteor"
export CC=gcc
export CVS_RSH="ssh"
export EDITOR="vim"
export HISTFILE=~/.zsh_history
export HISTSIZE=4096
export LANG=en_US.UTF-8
export MALLOC_CHECK_=3
export NNTPSERVER='news.epita.fr'
export SAVEHIST=4096
[ "$USER" = "root" ] && export TMOUT=600

if command most 2> /dev/null; then
    export PAGER="most"
elif command less 2> /dev/null; then
    export PAGER="less"
fi

export LESSCHARSET="utf-8"
export LESS_TERMCAP_mb=$(printf "\e[1;37m")
export LESS_TERMCAP_md=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;47;30m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[1;32m")

setopt appendhistory nomatch
setopt extended_glob
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt sh_word_split # Do not quote expanded vars
unsetopt beep notify

which gnuls > /dev/null && alias ls='gnuls --color=auto -F -h' ||
alias ls='ls --color=auto -F -h'
alias ll='ls -l'
alias la='ls -lA'
alias lla='ls -lA'
alias l='lla'
alias df='df -h'
alias reload="source ~/.zshrc"
alias g='git'
alias gst='git status'
alias zshrc='vim ~/.zshrc'
alias source_venv='source venv/bin/activate'
alias fact='/sgoinfre/fact-devel/FactExe.exe --nologo'
alias sso='ssh -l root'
alias pytree="tree -I 'venv|__pycache__'"
alias unscp='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias unssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

fpath=(~/.zsh/completion $fpath)

autoload -U colors && colors

zstyle ':completion:*:default' list-colors ''

MD5CMD=`(which md5sum > /dev/null && echo "md5sum") ||
(which md5 > /dev/null && echo "md5") || echo "cat"`

case `echo $(hostname) | $MD5CMD | sed -E 's/^(.).*$/\1/'` in
    "b"|"6")
        HOST_COLOR="red" ;;
    "1"|"8"|"7")
        HOST_COLOR="magenta" ;;
    "5"|"4"|"a")
        HOST_COLOR="yellow" ;;
    "2"|"9"|"d")
        HOST_COLOR="blue" ;;
    "f"|"c"|"e")
        HOST_COLOR="cyan" ;;
    "3"|"0"|"f")
        HOST_COLOR="green" ;;
    *)
        HOST_COLOR="white" ;;
esac

autoload -U compinit && compinit

# Git wrapper
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
        '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
        '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
    fi
}

PROMPT="%(!.%F{red}%B.%F{white})%n@%F{${HOST_COLOR}}%m%(!.%b.)%f:%F{cyan}%~%f%(?.%F{green}.%B%F{red})%#%f%b "
RPROMPT='%F{blue}%T%f %(?.%F{green}.%F{red}%B)%?%f'
#RPROMPT=$'$(vcs_info_wrapper)' $RPROMPT
setopt nopromptcr

export CLICOLOR="YES"
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
which dircolors > /dev/null && eval `dircolors`

# Fix keyboard
bindkey -e
bindkey '^W' vi-backward-kill-word
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '[D' emacs-backward-word

setxkbmap -option 'caps:swapescape'
bindkey '[C' emacs-forward-word
