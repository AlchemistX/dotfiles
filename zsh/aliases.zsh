#!/bin/sh

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# easier to read disk
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB

# easer to change directory
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# List directory contents
if command -v eza &> /dev/null; then
    alias l='eza -lah --icons --git --git-repos'
    alias ls='eza --icons --git --git-repos'
    alias ll='eza -lhg --icons --git --git-repos'
    alias la='eza -lAhg --icons --git --git-repos'
    alias lt='eza -lTAhg --icons --git --git-repos'
    alias lt1='eza -lTAhg --level=1 --icons --git --git-repos'
    alias lt2='eza -lTAhg --level=2 --icons --git --git-repos'
    alias lt3='eza -lTAhg --level=3 --icons --git --git-repos'
else
    alias lsa='ls -lah'
    alias l='ls -lah'
    alias ll='ls -lh'
    alias la='ls -lAh'
fi

# vi
alias vi='nvim'
alias vim='nvim'
