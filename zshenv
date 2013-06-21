export CDPATH=$HOME/dev
export GOPATH=$HOME
export LANG=en_US.UTF-8
export LC_TIME=en_DK.UTF-8
export PATH=$PATH:$HOME/bin

alias la='ls -la --color=auto'
alias lh='ls -lh --color=auto'
alias ll='ls -l --color=auto'
alias p='/usr/bin/env python $(which ipython)'

alias ']find-py'='find . -name \*.py -print0 |xargs -0 '
alias ']find-pyc'='find . -name \*.pyc -print0 |xargs -0 '

# git helpers
alias ']b'='git branch'
alias ']ca'='git commit -a'
alias ']ci'='git commit'
alias ']co'='git checkout'
alias ']com'='git checkout master'
alias ']ci'='git commit'
alias ']ca'='git commit -a'
alias ']d'='git diff --find-copies-harder -B -C --color-words --word-diff-regex="\\w+|[^[:space:]]"'
alias ']dc'='git diff --find-copies-harder -B -C --color-words --cached --word-diff-regex="\\w+|[^[:space:]]"'
alias ']l'='git log --stat'
alias ']st'='git status'
alias ']s'='git stash'
alias ']sa'='git stash apply'
alias ']sd'='git stash drop'
alias ']sp'='git stash pop'
alias ']t'='git tag'
