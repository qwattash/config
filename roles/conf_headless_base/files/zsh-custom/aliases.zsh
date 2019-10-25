#
# Copyright (c) 2019 Alfredo Mazzinghi (qwattash)
#
# Custom collection of aliases.
#

# For a full list of active aliases, run `alias`.

# Screen resixing aliases
alias multiheadl='xrandr --output HDMI1 --mode 2560x1440 --right-of LVDS1'
alias dotol='xrandr --output HDMI1 --mode 1280x720 --right-of LVDS1'
alias multiheadr='xrandr --output HDMI1 --mode 2560x1440 --left-of LVDS1'
alias dotor='xrandr --output HDMI1 --mode 1280x720 --left-of LVDS1'
alias workscreen="xrandr --output HDMI1 --mode 1920x1080 --left-of LVDS1"
alias rstscreen="xrandr --output HDMI1 --off"

# archlinux java alias
alias jdk8='sudo archlinux-java set java-8-openjdk'
alias jdk7='sudo archlinux-java set java-7-openjdk'

# extra git aliases
alias gl="git log"
# bacause nobody cares about ghostscript
alias gs="git status"

# navigation aliases
alias u='cd ..'
alias uu='cd ../..'
alias uuu='cd ../../..'
alias c='cd'
alias l='ls'
alias ll='ls -l'
pd() {pushd $*}
alias pp='popd'

# programs shortcuts
alias e='emacsclient -q -c -s qwattash_emacsd'
alias pdf='evince'

# shadow tmux with create/attach to a session named after the current working directory
alias tmx='tmux new-session -A -s `shrink_path -t -l | sed s/~/!!!!/`'

# system management
alias sctl='systemctl'
alias sctlu='systemctl --user'
alias kkg='setxkbmap -layout gb'
alias kki='setxkbmap -layout it'

# misc virtualenv operations
venv() {source "$1"/bin/activate}
pve() {source ./venv/bin/activate}

# custom file handling operations
function swap()
{
    local TMPFILE=.swap_tmp_file.$$
    mv "${1}" ${TMPFILE}
    mv "${2}" "${1}"
    mv ${TMPFILE} "${2}"
}

# clean emacs temporary files
function eclean()
{
    find . -name '*.*~' | xargs rm
}
