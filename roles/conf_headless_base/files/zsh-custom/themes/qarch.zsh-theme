#
#
# Copyright (c) 2019 Alfredo Mazzinghi (qwattash)
#
# Custom zsh theme configuration.
# Note that this requries a powerline patched font to render correctly.
#

# QARCH_SEPARATOR="\uE0CC"
QARCH_SEPARATOR="\uE0B0"
QARCH_VCS_BAR_LEFT="\uE0B2"
QARCH_VCS_BAR_RIGHT="\uE0B0"
QARCH_PLUSMINUS="\u00B1"
QARCH_BRANCH="\uE0A0"
QARCH_DETACHED="\u2934"

# color shortcuts (based on oh-my-zsh spectrum)
# normal
n_black=000
n_red=001
n_green=002
n_yellow=003
n_blue=004
n_purple=005
n_cyan=006
n_white=007
# bright
b_black=008
b_red=009
b_green=010
b_yellow=011
b_blue=012
b_purple=013
b_cyan=014
b_white=015

qarch_host() {
    print -n "%{%F{$n_black}%K{$n_blue}%}%n@%m %{%F{$n_blue}%K{$n_green}%}$QARCH_SEPARATOR%{%k%f%}"
}

qarch_path() {
    print -n "%{%F{$n_black}%K{$n_green}%} %6~ %{%F{$n_green}%k%}$QARCH_SEPARATOR%{%k%f%}"
}

qarch_vcs() {
    local vcs_prompt vcs_fg vcs_bg branch

    vcs_prompt="${vcs_info_msg_0_}"
    vcs_fg="${n_black}"
    if [[ -n "$vcs_prompt" ]]; then
        if [[ -n "$(git status --porcelain --ignore-submodules)" ]]; then
            vcs_prompt="${vcs_prompt} $QARCH_PLUSMINUS"
            vcs_bg="${n_red}"
        else
            vcs_bg="${n_green}"
        fi
        vcs_prompt="%{%F{$vcs_fg}%K{$vcs_bg}%}$QARCH_VCS_BAR_LEFT ${vcs_info_msg_0_} $QARCH_VCS_BAR_RIGHT%{%k%f%}"
    fi

    print -n "${vcs_prompt}"
}

qarch_create() {
    vcs_info
    PROMPT="%{%f%k%b%} $(qarch_host)$(qarch_path) %(!.#.$) "
    RPROMPT="$(qarch_vcs)"
}

qarch_setup_prompt() {
    # React to specific events
    autoload -Uz add-zsh-hook
    # Version control information
    autoload -Uz vcs_info

    add-zsh-hook precmd qarch_create

    zstyle ":vcs_info:*" enable git
    zstyle ":vcs_info:*" check-for-changes false
    zstyle ":vcs_info:git*" formats "%b"
    zstyle ":vcs_info:git*" actionformats "%b (%a)"
}

qarch_setup_prompt
