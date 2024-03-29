# zsh command history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history


setopt extended_glob


# Settings for umask
if (( EUID == 0 )); then
    umask 002
else
    umask 022
fi

# completion
for d in ~/.config/zsh-completion ~/.zfunc ; do
    [[ -d "$d" ]] && fpath+=("$d")
done
autoload -U +X compinit && compinit || print 'Notice: no compinit available :(' >&2
autoload -U +X bashcompinit && bashcompinit
autoload _git && _git >/dev/null 2>&1
setopt no_complete_aliases

# aliases
if exa &>/dev/null ; then
    alias ls='exa'
elif ls --color=auto -d . &>/dev/null ; then
    alias ls='ls --color=auto'
fi
alias fgrep='grep -F'
alias egrep='grep -E'
alias la='ls -lah'
alias lh='ls -lh'
alias ll='ls -l'
alias p2='/usr/bin/env python2 $(which ipython)'
alias p3='/usr/bin/env python3 $(which ipython)'
alias generate_passwords='base64 /dev/urandom |tr -d "+/" |fold -w20 |head -n7'

alias 'find-py'='find . -name \*.py -print0 |xargs -0 '
alias 'find-pyc'='find . -name \*.pyc -print0 |xargs -0 '

# git helpers
alias gb='git branch --verbose'
alias gba='git branch --all --list --verbose'
alias gca='git commit --all'
alias gcamn='git commit --all --amend --no-edit'
alias gcimn='git commit --amend --no-edit'
alias gci='git commit'
alias gco='git checkout'
alias gd='git diff --find-copies-harder -B -C --color-words --word-diff-regex="\\w+|[^[:space:]]"'
alias gdl='git diff --find-copies-harder -B -C'
alias gdc='git diff --find-copies-harder -B -C --color-words --cached --word-diff-regex="\\w+|[^[:space:]]"'
alias gdlc='git diff --find-copies-harder -B -C --cached'
alias gfap='git fetch --all --prune'
alias gfpp='git fetch --all --prune && git pull'
alias gfrom='git fetch && git rebase origin/master'
alias gl='git log --cherry --decorate=short --stat'
alias gla='git log --all --cherry --decorate=short --stat'
alias glp='git log --cherry --decorate=short --patch'
alias glpa='git log --all --cherry --decorate=short --patch'
alias gmf='git merge --ff-only'
alias gmfd=git_merge_delete
alias gpd=git_push_delete
alias gs='git stash'
alias gsa='git stash apply'
alias gsd='git stash drop'
alias gsp='git stash pop'
alias gst='git status'
alias gsw='git switch'
alias gswm='git switch master'
alias gt='git tag'
alias ghclone=github_clone
alias gor=goreplace
alias goag='ag --ignore-dir=build --ignore-dir=dist --ignore-dir=vendor'
alias tf=terraform

alias arch_instal_yay='git clone https://aur.archlinux.org/yay.git && ( cd yay && makepkg -si ) ; rm -rf ./yay/'


REPORTTIME=2

# TODO Linux GUI start script
if false ; then
    setxkbmap us,ru ,winkeys grp:caps_toggle compose:ralt 2>/dev/null

    # keyboard repeat rate
    xset r rate 300 34 2>/dev/null

    # disable bell
    xset -b 2>/dev/null
fi

if which pyenv >/dev/null; then eval "$(pyenv init -)"; fi

function mkdircd() {
    mkdir -p "$1" && cd "$1"
}
compdef _cd mkdircd

function git_push_delete() {
    local branch="${1-$(git symbolic-ref --short HEAD)}"
    git push --delete origin $branch
}
compdef _git-branch git_push_delete

function git_rebase_merge() {
    local branch="${1-$(git symbolic-ref --short HEAD)}"
    git rebase master && git checkout master && git merge --ff-only --stat $branch
    git branch --list --verbose master $branch
}
compdef _git-branch git_rebase_merge

function git_merge_delete() {
    local branch="${1-$(git symbolic-ref --short HEAD)}"
    local into="${2-master}"
    (
        set -eu
        echo "- switch $branch, rebase on $into" >&2
        git switch $branch && git rebase $into
        echo "- switch $into, ff-merge $branch" >&2
        git switch $into && git merge --ff-only $branch
        echo "- push $into" >&2
#        git push origin $into
        echo "- delete local and remote $branch" >&2
        git branch -d $branch
        git push --delete origin $branch || true
        git branch --list --verbose $into
    )
}
compdef _git-branch git_merge_delete
compdef _git-branch gmfd

function github_clone() {
    local repo=${1?"usage github_clone user/repo"}
    local suffix="github.com/$repo"
    local url="https://$suffix"
    local target="$HOME/dev/$suffix"
    local rc=0
    git clone --recursive "$url" "$target" "${@:2}" || rc=$?
    cd "$target"
    return $rc
}
compdef _git-clone github_clone
compdef _git-clone ghclone

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]] && bindkey "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]] && bindkey "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]] && bindkey "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]] && bindkey "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]] && bindkey "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]] && bindkey "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]] && bindkey "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]] && bindkey "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]] && bindkey "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]] && bindkey "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# my key bindings
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey ';5D' backward-word
bindkey ';5C' forward-word


function virtualenv_info {
    [ -n "$VIRTUAL_ENV" ] && echo `basename $VIRTUAL_ENV`
}


# Begin apex
# http://apex.run wrapper for AWS Lambda
_apex()  {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local opts="$(apex autocomplete -- ${COMP_WORDS[@]:1})"
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}
complete -F _apex apex
# End apex


# Begin copied from grml

# check for version/system
# check for versions (compatibility reasons)
is4(){
    [[ $ZSH_VERSION == <4->* ]] && return 0
    return 1
}

is41(){
    [[ $ZSH_VERSION == 4.<1->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is42(){
    [[ $ZSH_VERSION == 4.<2->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is425(){
    [[ $ZSH_VERSION == 4.2.<5->* || $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is43(){
    [[ $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is433(){
    [[ $ZSH_VERSION == 4.3.<3->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is437(){
    [[ $ZSH_VERSION == 4.3.<7->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

is439(){
    [[ $ZSH_VERSION == 4.3.<9->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

# autoload wrapper - use this one instead of autoload directly
# We need to define this function as early as this, because autoloading
# 'is-at-least()' needs it.
function zrcautoload() {
    emulate -L zsh
    setopt extended_glob
    local fdir ffile
    local -i ffound

    ffile=$1
    (( ffound = 0 ))
    for fdir in ${fpath} ; do
        [[ -e ${fdir}/${ffile} ]] && (( ffound = 1 ))
    done

    (( ffound == 0 )) && return 1
    if [[ $ZSH_VERSION == 3.1.<6-> || $ZSH_VERSION == <4->* ]] ; then
        autoload -U ${ffile} || return 1
    else
        autoload ${ffile} || return 1
    fi
    return 0
}

# Load is-at-least() for more precise version checks Note that this test will
# *always* fail, if the is-at-least function could not be marked for
# autoloading.
zrcautoload is-at-least || is-at-least() { return 1 }

# set some important options (as early as possible)

# append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history

# import new commands from the history file also in other zsh-session
is4 && setopt share_history

# save each command's beginning timestamp and the duration to the history file
setopt extended_history

# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
is4 && setopt histignorealldups

# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace

# display PID when suspending processes as well
setopt longlistjobs

# report the status of backgrounds jobs immediately
setopt notify

# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all

# not just at the end
setopt completeinword

# Don't send SIGHUP to background processes when the shell exits.
setopt nohup

# * shouldn't match dotfiles. ever.
setopt noglobdots

# use zsh style word splitting
setopt noshwordsplit

# Check if we can read a given file and 'cat(1)' it.
xcat() {
    emulate -L zsh
    if (( ${#argv} != 1 )) ; then
        printf 'usage: xcat FILE\n' >&2
        return 1
    fi

    [[ -r $1 ]] && cat $1
    return 0
}

TZ=$(xcat /etc/timezone)

export PAGER=${PAGER:-less}

# if we don't set $SHELL then aterm, rxvt,.. will use /bin/sh or /bin/bash :-/
export SHELL='/bin/zsh'

# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# Load a few modules
is4 && \
for mod in parameter complist deltochar mathfunc ; do
    zmodload -i zsh/${mod} 2>/dev/null || print "Notice: no ${mod} available :("
done

# autoload zsh modules when they are referenced
if is4 ; then
    zmodload -a  zsh/stat    zstat
    zmodload -a  zsh/zpty    zpty
    zmodload -ap zsh/mapfile mapfile
fi

# completion system

# called later (via is4 && grmlcomp)
# note: use 'zstyle' for getting current settings
#         press ^xh (control-x h) for getting tags in context; ^x? (control-x ?) to run complete_debug with trace output
grmlcomp() {
    # TODO: This could use some additional information

    # Make sure the completion system is initialised
    (( ${+_comps} )) || return 1

    # allow one error for every three characters typed in approximate completer
    zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

    # don't complete backup files as executables
    zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

    # start menu completion only if it could find no unambiguous initial string
    zstyle ':completion:*:correct:*'       insert-unambiguous true
    zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
    zstyle ':completion:*:correct:*'       original true

    # activate color-completion
    zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

    # format on completion
    zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

    # automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
    # zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

    # insert all expansions for expand completer
    zstyle ':completion:*:expand:*'        tag-order all-expansions
    zstyle ':completion:*:history-words'   list false

    # activate menu
    zstyle ':completion:*:history-words'   menu yes

    # ignore duplicate entries
    zstyle ':completion:*:history-words'   remove-all-dups yes
    zstyle ':completion:*:history-words'   stop yes

    # match uppercase from lowercase
    zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

    # separate matches into groups
    zstyle ':completion:*:matches'         group 'yes'
    zstyle ':completion:*'                 group-name ''

    if [[ "$NOMENU" -eq 0 ]] ; then
        # if there are more than 5 options allow selecting from a menu
        zstyle ':completion:*'               menu select=5
    else
        # don't use any menus at all
        setopt no_auto_menu
    fi

    zstyle ':completion:*:messages'        format '%d'
    zstyle ':completion:*:options'         auto-description '%d'

    # describe options in full
    zstyle ':completion:*:options'         description 'yes'

    # on processes completion complete all user processes
    zstyle ':completion:*:processes'       command 'ps -au$USER'

    # offer indexes before parameters in subscripts
    zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

    # provide verbose completion information
    zstyle ':completion:*'                 verbose true

    # recent (as of Dec 2007) zsh versions are able to provide descriptions
    # for commands (read: 1st word in the line) that it will list for the user
    # to choose from. The following disables that, because it's not exactly fast.
    zstyle ':completion:*:-command-:*:'    verbose false

    # set format for warnings
    zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

    # define files to ignore for zcompile
    zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
    zstyle ':completion:correct:'          prompt 'correct to: %e'

    # Ignore completion functions for commands you don't have:
    zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

    # Provide more processes in completion of programs like killall:
    zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

    # complete manual by their section
    zstyle ':completion:*:manuals'    separate-sections true
    zstyle ':completion:*:manuals.*'  insert-sections   true
    zstyle ':completion:*:man:*'      menu yes select

    # Search path for sudo completion
    zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                               /usr/local/bin  \
                                               /usr/sbin       \
                                               /usr/bin        \
                                               /sbin           \
                                               /bin            \
                                               /usr/X11R6/bin

    # provide .. as a completion
    zstyle ':completion:*' special-dirs ..

    # run rehash on completion so new installed program are found automatically:
    _force_rehash() {
        (( CURRENT == 1 )) && rehash
        return 1
    }

    ## correction
    # some people don't like the automatic correction - so run 'NOCOR=1 zsh' to deactivate it
    if [[ "$NOCOR" -gt 0 ]] ; then
        zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored
        setopt nocorrect
    else
        # try to be smart about when to use what completer...
        setopt correct
        zstyle -e ':completion:*' completer '
            if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
                _last_try="$HISTNO$BUFFER$CURSOR"
                reply=(_complete _match _ignored _prefix _files)
            else
                if [[ $words[1] == (rm|mv) ]] ; then
                    reply=(_complete _files)
                else
                    reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
                fi
            fi'
    fi

    # command for process lists, the local web server details and host completion
    zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'

    # caching
    [[ -d $ZSHDIR/cache ]] && zstyle ':completion:*' use-cache yes && \
                            zstyle ':completion::complete:*' cache-path $ZSHDIR/cache/

    # host completion
    if is42 ; then
        [[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
        [[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
    else
        _ssh_hosts=()
        _etc_hosts=()
    fi
    hosts=(
        $(hostname)
        "$_ssh_hosts[@]"
        "$_etc_hosts[@]"
        localhost
    )
    zstyle ':completion:*:hosts' hosts $hosts
    # TODO: so, why is this here?
    #  zstyle '*' hosts $hosts

    # use generic completion system for programs not yet defined; (_gnu_generic works
    # with commands that provide a --help option with "standard" gnu-like output.)
    for compcom in cp deborphan df feh fetchipac head hnb ipacsum mv \
                   pal stow tail uname ; do
        [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
    done; unset compcom

    # see upgrade function in this file
    compdef _hosts upgrade
}

# Keyboard setup: The following is based on the same code, we wrote for
# debian's setup. It ensures the terminal is in the right mode, when zle is
# active, so the values from $terminfo are valid. Therefore, this setup should
# work on all systems, that have support for `terminfo'. It also requires the
# zsh in use to have the `zsh/terminfo' module built.
#
# If you are customising your `zle-line-init()' or `zle-line-finish()'
# functions, make sure you call the following utility functions in there:
#
#     - zle-line-init():      zle-smkx
#     - zle-line-finish():    zle-rmkx

# Use emacs-like key bindings by default:
bindkey -e


# only slash should be considered as a word separator:
slash-backward-kill-word() {
    local WORDCHARS="${WORDCHARS:s@/@}"
    # zle backward-word
    zle backward-kill-word
}
zle -N slash-backward-kill-word


# Prompt setup for grml:

# set colors for use in prompts (modern zshs allow for the use of %F{red}foo%f
# in prompts to get a red "foo" embedded, but it's good to keep these for
# backwards compatibility).
if zrcautoload colors && colors 2>/dev/null ; then
    BLUE="%{${fg[blue]}%}"
    RED="%{${fg_bold[red]}%}"
    GREEN="%{${fg[green]}%}"
    CYAN="%{${fg[cyan]}%}"
    MAGENTA="%{${fg[magenta]}%}"
    YELLOW="%{${fg[yellow]}%}"
    WHITE="%{${fg[white]}%}"
    NO_COLOR="%{${reset_color}%}"
else
    BLUE=$'%{\e[1;34m%}'
    RED=$'%{\e[1;31m%}'
    GREEN=$'%{\e[1;32m%}'
    CYAN=$'%{\e[1;36m%}'
    WHITE=$'%{\e[1;37m%}'
    MAGENTA=$'%{\e[1;35m%}'
    YELLOW=$'%{\e[1;33m%}'
    NO_COLOR=$'%{\e[0m%}'
fi

# First, the easy ones: PS2..4:

# secondary prompt, printed when the shell needs more information to complete a
# command.
PS2='\`%_> '
# selection prompt used within a select loop.
PS3='?# '
# the execution trace prompt (setopt xtrace). default: '+%N:%i>'
PS4='+%N:%i:%_> '

# Some additional features to use with our prompt:
#
#    - battery status
#    - debian_chroot
#    - vcs_info setup and version specific fixes

# display battery status on right side of prompt via running 'BATTERY=1 zsh'
if [[ $BATTERY -gt 0 ]] ; then
    if ! check_com -c acpi ; then
        BATTERY=0
    fi
fi

battery() {
if [[ $BATTERY -gt 0 ]] ; then
    PERCENT="${${"$(acpi 2>/dev/null)"}/(#b)[[:space:]]#Battery <->: [^0-9]##, (<->)%*/${match[1]}}"
    if [[ -z "$PERCENT" ]] ; then
        PERCENT='acpi not present'
    else
        if [[ "$PERCENT" -lt 20 ]] ; then
            PERCENT="warning: ${PERCENT}%%"
        else
            PERCENT="${PERCENT}%%"
        fi
    fi
fi
}

# set variable debian_chroot if running in a chroot with /etc/debian_chroot
if [[ -z "$debian_chroot" ]] && [[ -r /etc/debian_chroot ]] ; then
    debian_chroot=$(</etc/debian_chroot)
fi

# gather version control information for inclusion in a prompt

if zrcautoload vcs_info; then
    # `vcs_info' in zsh versions 4.3.10 and below have a broken `_realpath'
    # function, which can cause a lot of trouble with our directory-based
    # profiles. So:
    if [[ ${ZSH_VERSION} == 4.3.<-10> ]] ; then
        function VCS_INFO_realpath () {
            setopt localoptions NO_shwordsplit chaselinks
            ( builtin cd -q $1 2> /dev/null && pwd; )
        }
    fi

    zstyle ':vcs_info:*' max-exports 2

    if [[ -o restricted ]]; then
        zstyle ':vcs_info:*' enable NONE
    fi
fi

# Change vcs_info formats for the grml prompt. The 2nd format sets up
# $vcs_info_msg_1_ to contain "zsh: repo-name" used to set our screen title.
# TODO: The included vcs_info() version still uses $VCS_INFO_message_N_.
#       That needs to be the use of $VCS_INFO_message_N_ needs to be changed
#       to $vcs_info_msg_N_ as soon as we use the included version.
if [[ "$TERM" == dumb ]] ; then
    zstyle ':vcs_info:*' actionformats "(%s%)-[%b|%a] " "zsh: %r"
    zstyle ':vcs_info:*' formats       "(%s%)-[%b] "    "zsh: %r"
else
    # these are the same, just with a lot of colors:
    zstyle ':vcs_info:*' actionformats "${MAGENTA}(${NO_COLOR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${YELLOW}|${RED}%a${MAGENTA}]${NO_COLOR} " \
                                       "zsh: %r"
    zstyle ':vcs_info:*' formats       "${MAGENTA}(${NO_COLOR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${MAGENTA}]${NO_COLOR}%} " \
                                       "zsh: %r"
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat "%b${RED}:${YELLOW}%r"
fi

# Now for the fun part: The grml prompt themes in `promptsys' mode of operation

# This actually defines three prompts:
#
#    - grml
#    - grml-large
#    - grml-chroot
#
# They all share the same code and only differ with respect to which items they
# contain. The main source of documentation is the `prompt_grml_help' function
# below, which gets called when the user does this: prompt -h grml

function prompt_grml_help () {
    cat <<__EOF0__
  prompt grml

    This is the prompt as used by the grml-live system <http://grml.org>. It is
    a rather simple one-line prompt, that by default looks something like this:

        <user>@<host> <current-working-directory>[ <vcs_info-data>]%

    The prompt itself integrates with zsh's prompt themes system (as you are
    witnessing right now) and is configurable to a certain degree. In
    particular, these aspects are customisable:

        - The items used in the prompt (e.g. you can remove \`user' from
          the list of activated items, which will cause the user name to
          be omitted from the prompt string).

        - The attributes used with the items are customisable via strings
          used before and after the actual item.

    The available items are: at, battery, change-root, date, grml-chroot,
    history, host, jobs, newline, path, percent, rc, rc-always, sad-smiley,
    shell-level, time, user, vcs

    The actual configuration is done via zsh's \`zstyle' mechanism. The
    context, that is used while looking up styles is:

        ':prompt:grml:<left-or-right>:<subcontext>'

    Here <left-or-right> is either \`left' or \`right', signifying whether the
    style should affect the left or the right prompt. <subcontext> is either
    \`setup' or 'items:<item>', where \`<item>' is one of the available items.

    The styles:

        - use-rprompt (boolean): If \`true' (the default), print a sad smiley
          in $RPROMPT if the last command a returned non-successful error code.
          (This in only valid if <left-or-right> is "right"; ignored otherwise)

        - items (list): The list of items used in the prompt. If \`vcs' is
          present in the list, the theme's code invokes \`vcs_info'
          accordingly. Default (left): rc change-root user at host path vcs
          percent; Default (right): sad-smiley

    Available styles in 'items:<item>' are: pre, post. These are strings that
    are inserted before (pre) and after (post) the item in question. Thus, the
    following would cause the user name to be printed in red instead of the
    default blue:

        zstyle ':prompt:grml:*:items:user' pre '%F{red}'

    Note, that the \`post' style may remain at its default value, because its
    default value is '%f', which turns the foreground text attribute off (which
    is exactly, what is still required with the new \`pre' value).
__EOF0__
}

function prompt_grml-chroot_help () {
    cat <<__EOF0__
  prompt grml-chroot

    This is a variation of the grml prompt, see: prompt -h grml

    The main difference is the default value of the \`items' style. The rest
    behaves exactly the same. Here are the defaults for \`grml-chroot':

        - left: grml-chroot user at host path percent
        - right: (empty list)
__EOF0__
}

function prompt_grml-large_help () {
    cat <<__EOF0__
  prompt grml-large

    This is a variation of the grml prompt, see: prompt -h grml

    The main difference is the default value of the \`items' style. In
    particular, this theme uses _two_ lines instead of one with the plain
    \`grml' theme. The rest behaves exactly the same. Here are the defaults
    for \`grml-large':

        - left: rc jobs history shell-level change-root time date newline user
                at host path vcs percent
        - right: sad-smiley
__EOF0__
}

function grml_prompt_setup () {
    emulate -L zsh
    autoload -Uz vcs_info
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd prompt_$1_precmd
}

function prompt_grml_setup () {
    grml_prompt_setup grml
}

function prompt_grml-chroot_setup () {
    grml_prompt_setup grml-chroot
}

function prompt_grml-large_setup () {
    grml_prompt_setup grml-large
}

# These maps define default tokens and pre-/post-decoration for items to be
# used within the themes. All defaults may be customised in a context sensitive
# matter by using zsh's `zstyle' mechanism.
typeset -gA grml_prompt_pre_default \
            grml_prompt_post_default \
            grml_prompt_token_default \
            grml_prompt_token_function

grml_prompt_pre_default=(
    at                ''
    battery           ' '
    change-root       ''
    date              '%F{blue}'
    grml-chroot       '%F{red}'
    history           '%F{green}'
    host              ''
    jobs              '%F{cyan}'
    newline           ''
    path              '%B'
    percent           ''
    rc                '%B%F{red}'
    rc-always         ''
    sad-smiley        ''
    shell-level       '%F{red}'
    time              '%F{blue}'
    user              '%B%F{blue}'
    vcs               ''
)

grml_prompt_post_default=(
    at                ''
    battery           ''
    change-root       ''
    date              '%f'
    grml-chroot       '%f '
    history           '%f'
    host              ''
    jobs              '%f'
    newline           ''
    path              '%b'
    percent           ''
    rc                '%f%b'
    rc-always         ''
    sad-smiley        ''
    shell-level       '%f'
    time              '%f'
    user              '%f%b'
    vcs               ''
)

grml_prompt_token_default=(
    at                '@'
    battery           'PERCENT'
    change-root       'debian_chroot'
    date              '%D{%Y-%m-%d}'
    grml-chroot       'GRML_CHROOT'
    history           '{history#%!} '
    host              '%m '
    jobs              '[%j running job(s)] '
    newline           $'\n'
    path              '%40<..<%~%<< '
    percent           '%# '
    rc                '%(?..%? )'
    rc-always         '%?'
    sad-smiley        '%(?..:()'
    shell-level       '%(3L.+ .)'
    time              '%D{%H:%M:%S} '
    user              '%n'
    vcs               '0'
)

function GRML_theme_add_token_usage () {
    cat <<__EOF__
  Usage: grml_theme_add_token <name> [-f|-i] <token/function> [<pre> <post>]

    <name> is the name for the newly added token. If the \`-f' or \`-i' options
    are used, <token/function> is the name of the function (see below for
    details). Otherwise it is the literal token string to be used. <pre> and
    <post> are optional.

  Options:

    -f <function>   Use a function named \`<function>' each time the token
                    is to be expanded.

    -i <function>   Use a function named \`<function>' to initialise the
                    value of the token _once_ at runtime.

    The functions are called with one argument: the token's new name. The
    return value is expected in the \$REPLY parameter. The use of these
    options is mutually exclusive.

  Example:

    To add a new token \`day' that expands to the current weekday in the
    current locale in green foreground colour, use this:

      grml_theme_add_token day '%D{%A}' '%F{green}' '%f'

    Another example would be support for \$VIRTUAL_ENV:

      function virtual_env_prompt () {
        REPLY=\${VIRTUAL_ENV+\${VIRTUAL_ENV:t} }
      }
      grml_theme_add_token virtual-env -f virtual_env_prompt

    After that, you will be able to use a changed \`items' style to
    assemble your prompt.
__EOF__
}

function grml_theme_add_token () {
    emulate -L zsh
    local name token pre post
    local -i init funcall

    if (( ARGC == 0 )); then
        GRML_theme_add_token_usage
        return 0
    fi

    init=0
    funcall=0
    pre=''
    post=''
    name=$1
    shift
    if [[ $1 == '-f' ]]; then
        funcall=1
        shift
    elif [[ $1 == '-i' ]]; then
        init=1
        shift
    fi

    if (( ARGC == 0 )); then
        printf '
grml_theme_add_token: No token-string/function-name provided!\n\n'
        GRML_theme_add_token_usage
        return 1
    fi
    token=$1
    shift
    if (( ARGC != 0 && ARGC != 2 )); then
        printf '
grml_theme_add_token: <pre> and <post> need to by specified _both_!\n\n'
        GRML_theme_add_token_usage
        return 1
    fi
    if (( ARGC )); then
        pre=$1
        post=$2
        shift 2
    fi

    if (( ${+grml_prompt_token_default[$name]} )); then
        printf '
grml_theme_add_token: Token `%s'\'' exists! Giving up!\n\n' $name
        GRML_theme_add_token_usage
        return 2
    fi
    if (( init )); then
        $token $name
        token=$REPLY
    fi
    grml_prompt_pre_default[$name]=$pre
    grml_prompt_post_default[$name]=$post
    if (( funcall )); then
        grml_prompt_token_function[$name]=$token
        grml_prompt_token_default[$name]=23
    else
        grml_prompt_token_default[$name]=$token
    fi
}

function grml_typeset_and_wrap () {
    emulate -L zsh
    local target="$1"
    local new="$2"
    local left="$3"
    local right="$4"

    if (( ${+parameters[$new]} )); then
        typeset -g "${target}=${(P)target}${left}${(P)new}${right}"
    fi
}

function grml_prompt_addto () {
    emulate -L zsh
    local target="$1"
    local lr it apre apost new v
    local -a items
    shift

    [[ $target == PS1 ]] && lr=left || lr=right
    zstyle -a ":prompt:${grmltheme}:${lr}:setup" items items || items=( "$@" )
    typeset -g "${target}="
    for it in "${items[@]}"; do
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" pre apre \
            || apre=${grml_prompt_pre_default[$it]}
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" post apost \
            || apost=${grml_prompt_post_default[$it]}
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" token new \
            || new=${grml_prompt_token_default[$it]}
        typeset -g "${target}=${(P)target}${apre}"
        if (( ${+grml_prompt_token_function[$it]} )); then
            ${grml_prompt_token_function[$it]} $it
            typeset -g "${target}=${(P)target}${REPLY}"
        else
            case $it in
            battery)
                grml_typeset_and_wrap $target $new '' ''
                ;;
            change-root)
                grml_typeset_and_wrap $target $new '(' ')'
                ;;
            grml-chroot)
                if [[ -n ${(P)new} ]]; then
                    typeset -g "${target}=${(P)target}(CHROOT)"
                fi
                ;;
            vcs)
                v="vcs_info_msg_${new}_"
                if (( ! vcscalled )); then
                    vcs_info
                    vcscalled=1
                fi
                if (( ${+parameters[$v]} )) && [[ -n "${(P)v}" ]]; then
                    typeset -g "${target}=${(P)target}${(P)v}"
                fi
                ;;
            *) typeset -g "${target}=${(P)target}${new}" ;;
            esac
        fi
        typeset -g "${target}=${(P)target}${apost}"
    done
}

function prompt_grml_precmd () {
    emulate -L zsh
    local grmltheme=grml
    local -a left_items right_items
    left_items=(rc change-root user at host path vcs percent)
    right_items=(sad-smiley)

    prompt_grml_precmd_worker
}

function prompt_grml-chroot_precmd () {
    emulate -L zsh
    local grmltheme=grml-chroot
    local -a left_items right_items
    left_items=(grml-chroot user at host path percent)
    right_items=()

    prompt_grml_precmd_worker
}

function prompt_grml-large_precmd () {
    emulate -L zsh
    local grmltheme=grml-large
    local -a left_items right_items
    left_items=(rc jobs history shell-level change-root time date newline
                user at host path vcs percent)
    right_items=(sad-smiley)

    prompt_grml_precmd_worker
}

function prompt_grml_precmd_worker () {
    emulate -L zsh
    local -i vcscalled=0

    grml_prompt_addto PS1 "${left_items[@]}"
    if zstyle -T ":prompt:${grmltheme}:right:setup" use-rprompt; then
        grml_prompt_addto RPS1 "${right_items[@]}"
    fi
}

grml_prompt_fallback() {
    setopt prompt_subst
    precmd() {
        (( ${+functions[vcs_info]} )) && vcs_info
    }

    p0="${RED}%(?..%? )${WHITE}${debian_chroot:+($debian_chroot)}"
    p1="${BLUE}%n${NO_COLOR}@%m %40<...<%B%~%b%<< "'${vcs_info_msg_0_}'"%# "
    if (( EUID == 0 )); then
        PROMPT="${BLUE}${p0}${RED}${p1}"
    else
        PROMPT="${RED}${p0}${BLUE}${p1}"
    fi
    unset p0 p1
}

if zrcautoload promptinit && promptinit 2>/dev/null ; then
    # Since we define the required functions in here and not in files in
    # $fpath, we need to stick the theme's name into `$prompt_themes'
    # ourselves, since promptinit does not pick them up otherwise.
    prompt_themes+=( grml grml-chroot grml-large )
    # Also, keep the array sorted...
    prompt_themes=( "${(@on)prompt_themes}" )
else
    print 'Notice: no promptinit available :('
    grml_prompt_fallback
fi

if is437; then
    # The prompt themes use modern features of zsh, that require at least
    # version 4.3.7 of the shell. Use the fallback otherwise.
    if [[ $BATTERY -gt 0 ]]; then
        zstyle ':prompt:grml:right:setup' items sad-smiley battery
        add-zsh-hook precmd battery
    fi
    if [[ "$TERM" == dumb ]] ; then
        zstyle ":prompt:grml(|-large|-chroot):*:items:grml-chroot" pre ''
        zstyle ":prompt:grml(|-large|-chroot):*:items:grml-chroot" post ' '
        for i in rc user path jobs history date time shell-level; do
            zstyle ":prompt:grml(|-large|-chroot):*:items:$i" pre ''
            zstyle ":prompt:grml(|-large|-chroot):*:items:$i" post ''
        done
        unset i
        zstyle ':prompt:grml(|-large|-chroot):right:setup' use-rprompt false
    elif (( EUID == 0 )); then
        zstyle ':prompt:grml(|-large|-chroot):*:items:user' pre '%B%F{red}'
    fi

    # Finally enable one of the prompts.
    if [[ -n $GRML_CHROOT ]]; then
        prompt grml-chroot
    elif [[ $GRMLPROMPT -gt 0 ]]; then
        prompt grml-large
    else
        prompt grml
    fi
else
    grml_prompt_fallback
fi


# Terminal-title wizardry

function ESC_print () {
    info_print $'\ek' $'\e\\' "$@"
}
function set_title () {
    info_print  $'\e]0;' $'\a' "$@"
}

function info_print () {
    local esc_begin esc_end
    esc_begin="$1"
    esc_end="$2"
    shift 2
    printf '%s' ${esc_begin}
    printf '%s' "$*"
    printf '%s' "${esc_end}"
}

function grml_reset_screen_title () {
    # adjust title of xterm
    # see http://www.faqs.org/docs/Linux-mini/Xterm-Title.html
    [[ ${NOTITLE:-} -gt 0 ]] && return 0
    case $TERM in
        (xterm*|rxvt*)
            host="${(%):-"%m"}"
            host=${host/temoto-/}
            dir="${(%):-"%~"}"
            dir=${dir/*bitbucket.org\//}
            dir=${dir/*github.com\//}
            title="$host $dir $(virtualenv_info)"
            set_title "$title"
            ;;
    esac
}

function grml_vcs_to_screen_title () {
    if [[ $TERM == screen* ]] ; then
        if [[ -n ${vcs_info_msg_1_} ]] ; then
            ESC_print ${vcs_info_msg_1_}
        else
            ESC_print "zsh"
        fi
    fi
}

function grml_maintain_name () {
    # set hostname if not running on host with name 'grml'
    if [[ -n "$HOSTNAME" ]] && [[ "$HOSTNAME" != $(hostname) ]] ; then
       NAME="@$HOSTNAME"
    fi
}

function grml_cmd_to_screen_title () {
    # get the name of the program currently running and hostname of local
    # machine set screen window title if running in a screen
    if [[ "$TERM" == screen* ]] ; then
        local CMD="${1[(wr)^(*=*|sudo|ssh|-*)]}$NAME"
        ESC_print ${CMD}
    fi
}

function grml_control_xterm_title () {
    case $TERM in
        (xterm*|rxvt*)
            host="${(%):-"%m"}"
            host=${host/temoto-/}
            dir="${(%):-"%~"}"
            dir=${dir/*bitbucket.org\//}
            dir=${dir/*github.com\//}
            cmd="$1"
            title="$host $dir $cmd"
            set_title "$title"
            ;;
    esac
}

zrcautoload add-zsh-hook || add-zsh-hook () { :; }
if [[ $NOPRECMD -eq 0 ]]; then
    add-zsh-hook precmd grml_reset_screen_title
    add-zsh-hook precmd grml_vcs_to_screen_title
    add-zsh-hook preexec grml_maintain_name
    add-zsh-hook preexec grml_cmd_to_screen_title
    if [[ $NOTITLE -eq 0 ]]; then
        add-zsh-hook preexec grml_control_xterm_title
    fi
fi

# End copied from grml

# Begin percol

function exists { which $1 &> /dev/null }

if exists percol; then
    function percol_select_history() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --auto-fail --auto-match --prompt-bottom --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N percol_select_history
    bindkey '^R' percol_select_history
fi

# End percol

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Begin broot https://github.com/Canop/broot

# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
function br {
    f=$(mktemp)
    (
	set +e
	broot --outcmd "$f" "$@"
	code=$?
	if [ "$code" != 0 ]; then
	    rm -f "$f"
	    exit "$code"
	fi
    )
    code=$?
    if [ "$code" != 0 ]; then
	return "$code"
    fi
    d=$(<"$f")
    rm -f "$f"
    eval "$d"
}

# End broot

complete -o nospace -C $(which terraform) terraform
test -r /usr/share/nvm/init-nvm.sh && source /usr/share/nvm/init-nvm.sh

which broot &>/dev/null && source /home/temoto/.config/broot/launcher/bash/br

which direnv &>/dev/null && eval "$(direnv hook zsh)"
