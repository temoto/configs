# /etc/skel/.bashrc

# non-interactive -> quit
[ -z "$PS1" ] && return

[[ -f /etc/bash_completion ]] && source /etc/bash_completion

shopt -s histappend
shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colors
c_clr="$(tput sgr 0)"; ec_clr="\[$c_clr\]"
c_host="$(tput setaf 2)"; ec_host="\[$c_host\]" # green
c_path="$(tput setaf 4)"; ec_path="\[$c_path\]" # blue
c_success="$(tput setaf 7)"; ec_success="\[$c_success\]" # grey
c_error="$(tput setaf 1)$(tput bold)"; ec_error="\[$c_error\]" # red bold

function print_exit_code { __ec=${?-0}
    if [ $__ec -eq 0 ]
    then printf "%b✔" "$c_success"
    else printf "%b%s" "$c_error" "$__ec"; fi
}

# my settings
# command prompt: (two lines)
# First: green time and hostname, blue current dir, green/red exitcode
# Second: $/#
PS1="$ec_clr$ec_host\u@\h$ec_clr:$ec_path\w$ec_clr \[\$(print_exit_code)\]$ec_clr\n\
\\$ "
export PATH=$PATH:$HOME/bin
export LANG=en_US.UTF-8
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export EDITOR=/usr/bin/vim
export PYTHONSTARTUP=~/.pythonrc.py

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias _m='less'
alias _l='ls -lh --color=auto'
alias l=_l
alias p='python'
alias cal='cal -m3'
alias eix='apt-cache search'

# cd and show todo
cd()
{
    builtin cd "$*" && devtodo
}

# ls or less depending on type
m()
{
    if [ $# = 0 ] || [ -d "$1" ]; then
        _l $@
    else
        _m $@
    fi
}

# execute command in other dir
function in_ {
    local ret
    pushd "$1" > /dev/null || return 255
    shift
    "$@"; ret=$?
    popd > /dev/null
    return $ret
}
function in_s() ( cd "$1"; shift; "$@" )
alias ']i'=in_
alias ']i_'=in_s

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
complete -o default -o nospace -F _git_log '[l'
complete -o default -o nospace -F _git_diff '[d'
complete -o default -o nospace -F _git_checkout '[co'
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
