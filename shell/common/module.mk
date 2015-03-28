#
# copy common shell conf helpers in place in the user filesystem
# common files are linked in ~/.config/shell-commons
#

path := $(call anrem-current-path)

$(<@)
$(@)COMM_TGT_DIR := $(HOME)/.config/shell-commons
$(@)COMM_GENERATOR := $(path)/gen-screen.py
$(@)COMM_SH_SRC := $(wildcard $(path)/*.sh)
$(@>)

$(<@)
$(@)COMM_TGT_SH := $(subst $(path), $(@COMM_TGT_DIR), $(@COMM_SH_SRC))
$(@)COMM_TGT_GENERATOR := $(@COMM_TGT_DIR)/gen-screen.py
$(@>)

$(call anrem-target, @COMM_TGT_GENERATOR): $(@COMM_GENERATOR)
	mkdir -p $(@COMM_TGT_DIR)
	if [ ! -e $@.bak -a -e $@ ]; then cp $@ $@.bak; fi
	ln -s -f $(abspath $<) $@

$(call anrem-target, $(@COMM_TGT_DIR)/%.sh): $(path)/%.sh
	mkdir -p $(@COMM_TGT_DIR)
	if [ ! -e $@.bak -a -e $@ ]; then cp $@ $@.bak; fi
	ln -s -f $(abspath $<) $@

$(call anrem-target, sh-common): $(@COMM_TGT_SH) $(@COMM_TGT_GENERATOR)

$(call anrem-clean, sh-common-clean):
	for tgt in $(@COMM_TGT_SH); do if [ -e $${tgt} ]; then unlink $${tgt}; fi; done
	if [ -e $(@COMM_TGT_GENERATOR) ]; then unlink $(@COMM_TGT_GENERATOR); fi

$(call anrem-target, sh-common-bakclean): sh-common-clean
	for tgt in $(@COMM_TGT_SH); do if [ -e $${tgt} ]; then mv $${tgt}.bak $${tgt}; fi; done
	if [ -e $(@COMM_TGT_GENERATOR).bak ]; then mv $(@COMM_TGT_GENERATOR).bak $(@COMM_TGT_GENERATOR); fi

# register backup cleaning target to the cleanup group
$(call anrem-target-group-add, BAK_CLEAN_GRP, sh-common-bakclean)
