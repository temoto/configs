CDPATH=$HOME/dev
GOPATH=$HOME
LANG=en_US.UTF-8
LC_TIME=en_DK.UTF-8
PATH=$PATH:$HOME/bin

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
