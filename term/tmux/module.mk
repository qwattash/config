#
# copy emacs conf in place in the user filesystem
#

path := $(call anrem-current-path)

$(<@)
$(@)TMUX_CONF := $(path)/tmux.conf
$(@)TMUX_DST := ~/.tmux.conf
$(@>)

$(call anrem-target, @TMUX_DST): $(@TMUX_CONF)
	cp $< $@

# main target for this module
$(call anrem-target, tmux): tmux-clean $(@TMUX_DST)


$(call anrem-clean, tmux-clean): tmux-bakclean
	-mv $(@TMUX_DST) $(@TMUX_DST).bak

$(call anrem-target, tmux-bakclean):
	rm -f $(@TMUX_DST).bak

# register backup cleaning target to the cleanup group
$(call anrem-target-group-add, BAK_CLEAN_GRP, tmux-bakclean)
