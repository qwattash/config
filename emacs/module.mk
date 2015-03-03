#
# Emacs configuration install script
#

path := $(call anrem-current-path)

$(<@)
$(@)EMACS_CONF_BASE := $(HOME)
$(@)EMACS_MAIN_CONF_SRC := $(path)/emacs
$(@)EMACS_DIR_CONF_SRC := $(path)/emacs.d
$(@>)
$(<@)
$(@)EMACS_MAIN_CONF_TGT := $(@EMACS_CONF_BASE)/.emacs
$(@)EMACS_DIR_CONF_TGT := $(@EMACS_CONF_BASE)/.emacs.d
$(@>)

$(call anrem-target, @EMACS_MAIN_CONF_TGT): $(@EMACS_MAIN_CONF_SRC)
	cp $< $@

$(call anrem-target, @EMACS_DIR_CONF_TGT): $(@EMACS_DIR_CONF_SRC)
	cp -R $< $@/*

.PHONY: emacs
# main target for this module
$(call anrem-target, emacs): emacs-clean $(@EMACS_MAIN_CONF_TGT) $(@EMACS_DIR_CONF_TGT)

$(call anrem-clean, emacs-clean): emacs-bakclean
	-mv $(@EMACS_MAIN_CONF_TGT) $(@EMACS_MAIN_CONF_TGT).bak
	-mv $(@EMACS_DIR_CONF_TGT) $(@EMACS_DIR_CONF_TGT).bak

$(call anrem-target, emacs-bakclean):
	rm -f $(@EMACS_MAIN_CONF_TGT).bak
	rm -rf $(@EMACS_DIR_CONF_TGT).bak

# register backup cleaning target to the cleanup group
$(call anrem-target-group-add, BAK_CLEAN_GRP, emacs-bakclean)
