if [[ $- != *i* ]]
then
    return
fi

if [[ -v SSH_CLIENT && -v SSH_CONNECTION && -v SSH_TTY ]]
then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

shopt -s histappend
HISTCONTROL='ignoredups:ignorespace'
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s globstar
shopt -s nullglob
shopt -s extglob

shopt -s checkwinsize

alias l='ls --color -F';
alias lsa='ls --color -F -a';
alias la='ls --color -F -a';
alias lsl='ls --color -F -l';
alias ll='ls --color -F -l';
alias lsla='ls --color -F -la';
alias lla='ls --color -F -la';
alias cpr='cp -r';
alias rmr='rm -r';
alias rr='rm -r';
alias gi='git';
alias gic='git commit';
alias gico='git checkout';
alias gis='git status';
alias gid='git diff';
alias gidh='git diff HEAD';
alias gia='git add';
alias s='sudo';
alias g='grep';
alias gn='grep -n';
alias gin='grep -in';
alias grin='grep -rin';
alias df='df -h';
alias du='du -h';
alias c='cd';
alias ffmpeg='ffmpeg -hide_banner';
alias ffprobe='ffprobe -hide_banner';
alias ffplay='ffplay -hide_banner';
