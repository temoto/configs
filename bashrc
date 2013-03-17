# /etc/skel/.bashrc

# non-interactive -> quit
[ -z "$PS1" ] && return

path_prepend() {
    while [ -n "$1" ]; do
        if [ ":$PATH:" != *":$1:"* ]; then
            PATH="${1}:${PATH}"
        fi
        shift
    done
}

# Important environment settings, must go first.
path_prepend /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin "$HOME/.cabal/bin" "$HOME/bin"
export PATH
export LANG=en_US.UTF-8
export LC_TIME=en_DK.UTF-8

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
    if [ ${__ec-0} -ne 0 ]
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

    # get cursor position and add new line if we're not in first column
    local cursor_pos
    stty -echo
    echo -n $'\e[6n'
    read -r -dR cursor_pos
    stty echo
    cursor_pos=${cursor_pos#??}
    cursor_line=${cursor_pos##*;}
    if [ ${cursor_line-1} -gt 1 ]; then
        echo "${c_error}↵${c_clr}"
    fi
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
export CDPATH=$HOME/dev
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export EDITOR=$(which vim)
export PAGER=less
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/lib
export XDG_DATA_HOME=$HOME/.config
export XDG_CONFIG_HOME=$HOME/.config
export GOPATH=$HOME
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
if which time >/dev/null 2>&1; then
    alias time=$(which time)
fi

# ls or less depending on type
m()
{
    if [ $# = 0 ] || [ -d "$1" ]; then
        _l "$@"
    else
        _m "$@"
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
alias ']b'='git branch'
alias ']ca'='git commit -a'
alias ']ci'='git commit'
alias ']co'='git checkout'
alias ']com'='git checkout master'
alias ']ci'='git commit'
alias ']ca'='git commit -a'
alias ']d'='git diff --find-copies-harder -B -C --color-words --word-diff-regex="\\w+|[^[:space:]]"'
alias ']dc'='git diff --find-copies-harder -B -C --color-words --cached --word-diff-regex="\\w+|[^[:space:]]"'
alias ']dms'='git daemon --detach --base-path=/home/temoto/project --export-all'
alias ']l'='git log --stat'
alias ']st'='git status'
alias ']s'='git stash'
alias ']sa'='git stash apply'
alias ']sd'='git stash drop'
alias ']sp'='git stash pop'
alias ']t'='git tag'
if declare -f __git_complete >/dev/null; then
    __git_complete ]b _git_branch
    __git_complete ]co _git_checkout
    __git_complete ]d _git_diff
    __git_complete ]l _git_log
fi

# google appengine helpers
alias 'gae-upload'='PYTHONPATH=~/python2.7/bin/python2.7 ~/google_appengine/appcfg.py -q update .'
alias 'gae-upload-all'='( git checkout stable && gae-upload ) ; ( git checkout master && gae-upload )'

# toys
alias sho='export PS1="" ; tput bold ; tput setaf 1 ; echo -e "\n\n\n\n\n\n\n\n\n\n\n    Шо?\n\n\n\n\n\n\n\n\n\n\n" ; tput sgr0'
