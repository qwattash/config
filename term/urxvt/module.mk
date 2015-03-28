#
# urxvt configuration install script
#

path := $(call anrem-current-path)

$(<@)
$(@)URXVT_CONF_BASE := $(HOME)/.config
$(@)URXVT_CONF_SRC := $(path)/urxvt
$(@)URXVT_XRESOURCES_PATCH := $(path)/xresources
$(@>)
$(<@)
$(@)URXVT_CONF_TGT := $(@URXVT_CONF_BASE)/urxvt
$(@)URXVT_XRESOURCES_TARGET = $(&XRESOURCES_FILE) # take the xresources name from the xresources module
$(@>)

# copy the config file to the user config file directory
$(call anrem-target, @URXVT_CONF_TGT): $(@URXVT_CONF_SRC)
	cp $< $@

# patch Xresources to include urxvt config and install
$(call anrem-target, urxvt): $(@URXVT_CONF_TGT) $(x11|xresources)
	if [ ! -e $@.bak ]; then cp $@ $@.bak; fi
	cp -R $< $@

$(call anrem-clean, urxvt-clean):
	-mv $(@URXVT_CONF_TGT) $(@URXVT_CONF_TGT).bak

$(call anrem-target, urxvt-bakclean):
	rm -f $(@URXVT_CONF_TGT).bak

# register backup cleaning target to the cleanup group
$(call anrem-target-group-add, BAK_CLEAN_GRP, urxvt-bakclean)
