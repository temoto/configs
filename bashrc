# /etc/skel/.bashrc

# non-interactive -> quit
[ -z "$PS1" ] && return

[[ -f /etc/bash_completion ]] && source /etc/bash_completion
[[ -r /usr/share/bash-completion/git ]] && source /usr/share/bash-completion/git

shopt -s histappend
shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# my settings
export PATH=$PATH:$HOME/bin
export LANG=en_US.UTF-8
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export EDITOR=/usr/bin/vim
export PYTHONSTARTUP=~/.pythonrc.py

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias m='less'
alias l='ls -lh --color=auto'
alias p='python'
alias cal='cal -m3'
alias eix='apt-cache search'

# cd and show todo
cd()
{
    builtin cd "$*" && devtodo
}

alias ']find-py'='find . -name \*.py | xargs '
alias ']find-pyc'='find . -name \*.pyc | xargs '
alias ']py-wc-l'=']find-py cat | wc -l'

# subversion helpers
alias 'svn-list-filter'='grep -vE "\.(swp|swo|pyc)$"'
alias ']di'='svn diff | colordiff | less -R'
alias ']st'='svn st | svn-list-filter'
alias ']st?'='svn st | grep -E "^\?" | svn-list-filter'

# git helpers
alias '[b'='git branch'
alias '[ca'='[[ ! -x ./tests.py ]] || ./tests.py && git commit -a'
alias '[ci'='[[ ! -x ./tests.py ]] || ./tests.py && git commit'
alias '[co'='git checkout'
alias '[com'='git checkout master'
alias '[ci'='git commit'
alias '[ca'='git commit -a'
alias '[d'='git diff'
alias '[dc'='git diff --cached'
alias '[dms'='git daemon --detach --base-path=/home/temoto/project --export-all'
alias '[l'='git log --stat'
alias '[st'='git status'
alias '[s'='git stash'
alias '[sa'='git stash apply'
alias '[sd'='git stash drop'
# git-svn helpers
alias '[[l'='git svn log'
alias '[[u'='git stash && git svn rebase && git stash apply'
alias '[[ci'='git svn dcommit'

# django helpers
alias ']mr'='python manage.py runserver 0.0.0.0:8000'
alias ']ms'='python manage.py shell'
alias ']cd'='python syncdb.py && ./create-test-data'

# google appengine helpers
alias 'gae-upload'='~/google_appengine/appcfg.py update .'
alias 'gae-upload-all'='( [co stable && gae-upload ) ; ( [co master && gae-upload )'

# toys
alias sho='export PS1="" ; tput bold ; tput setaf 1 ; echo -e "\n\n\n\n\n\n\n\n\n\n\n    Шо?\n\n\n\n\n\n\n\n\n\n\n" ; tput sgr0'
