# /etc/skel/.bashrc

# non-interactive -> quit
[ -z "$PS1" ] && return

# Important environment settings, must go first.
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH=$HOME/bin:$HOME/.cabal/bin:$PATH
export LANG=en_US.UTF-8

[[ -f /etc/bash_completion ]] && source /etc/bash_completion

shopt -s histappend
shopt -s checkwinsize

export LESS="-iR"
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colors
c_clr="$(tput sgr 0)"; ec_clr="\[$c_clr\]"
c_user="$(tput setaf 2)"; ec_user="\[$c_user\]" # green
c_path="$(tput setaf 4)"; ec_path="\[$c_path\]" # blue
c_success="$(tput setaf 7)"; ec_success="\[$c_success\]" # grey
c_error="$(tput setaf 1)$(tput bold)"; ec_error="\[$c_error\]" # red bold

function print_exit_code {
    if [ $__ec -ne 0 ]
    then printf "%b%s" "$c_error" "$__ec"; fi
    #then printf "%bok" "$c_success"
    #else printf "%b%s" "$c_error" "$__ec"; fi
    tput sgr0
}

function print_vcs_info {
    printf "%b" "$head_local"
}

function on_prompt {
    __ec=${?-0} # save last executed command exit code
    # these two are from git-prompt.sh
    if declare -f parse_vcs_status >/dev/null; then
        set_shell_label
        unset head_local
        parse_vcs_status
    fi

    host_id=$(which hostid >/dev/null && hostid || echo 1)
    host_hash=$(( (${#HOSTNAME}+0x${host_id}) % 15+1))
    c_host="$(tput setaf $host_hash)"
    ec_host="\[$c_host\]"
    unset host_hash
}

# run git-prompt
[[ $- == *i* ]] && which git-prompt.sh >/dev/null && . $(which git-prompt.sh)

# my settings
# command prompt: (two lines)
# First: green username, different color hostname, blue current dir, green/red exitcode
# Second: $/#
prompt=(
    "$ec_clr"
    "$ec_user"                 '\u'
    "$ec_clr"                  '@'
    "\$(echo \$c_host)"        '\h'
    "$ec_clr"                  ':'
    "$ec_path"                 '\w'
    "$ec_clr"                  ' '
    ""                         "\$(print_vcs_info)"
    "$ec_clr"                  "\[\$(print_exit_code)\]"
    "$ec_clr"                  '\n'
    ""                         "\\$ "
)
printf -v PS1 "%s" "${prompt[@]}"
PROMPT_COMMAND=on_prompt
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export EDITOR=$(which vim)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/lib
export XDG_DATA_HOME=$HOME/.config
export XDG_CONFIG_HOME=$HOME/.config
export GOROOT=$HOME/src/go
# Set <TAB> width to 4 characters.
# Thanks http://superuser.com/questions/110421/tab-character-width-in-terminal
tabs -4
# Use parallel build in SCons by default.
export SCONSFLAGS="-j 4"

if ls --color >/dev/null 2>&1 ; then
    ls_color_flag="--color=auto"
else
    ls_color_flag="-G"
fi

alias grep='grep --color=auto'
alias ls='ls ${ls_color_flag}'
alias _m='less'
alias _l='ls -lh ${ls_color_flag}'
alias l=_l
alias p='/usr/bin/env python $(which ipython)'
alias py='/usr/bin/env python'
alias la='_l -a'
alias cal='cal -h3'
alias eix='apt-cache search'
alias appt='apt-cache show'
# Use time program, it reports more information than builtin command.
alias time=$(which time)

# cd and show todo
if which devtodo >/dev/null ; then
    cd()
    {
        builtin cd "$*" && devtodo
    }
fi

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
alias '[d'='git diff --find-copies-harder -B -C'
alias '[dc'='git diff --find-copies-harder -B -C --cached'
alias '[dms'='git daemon --detach --base-path=/home/temoto/project --export-all'
alias '[l'='git log --stat'
alias '[st'='git status'
alias '[s'='git stash'
alias '[sa'='git stash apply'
alias '[sd'='git stash drop'
alias '[sp'='git stash pop'
alias '[t'='git tag'
complete -o default -o nospace -F _git_branch '[b'
complete -o default -o nospace -F _git_checkout '[co'
complete -o default -o nospace -F _git_log '[l'
complete -o default -o nospace -F _git_diff '[d'

# google appengine helpers
alias 'gae-upload'='PYTHONPATH= ~/python2.5/bin/python2.5 ~/google_appengine/appcfg.py -q update .'
alias 'gae-upload-all'='( [co stable && gae-upload ) ; ( [co master && gae-upload )'

# toys
alias sho='export PS1="" ; tput bold ; tput setaf 1 ; echo -e "\n\n\n\n\n\n\n\n\n\n\n    Шо?\n\n\n\n\n\n\n\n\n\n\n" ; tput sgr0'
