#
# copy emacs conf in place in the user filesystem
#

path := $(call anrem-current-path)

$(<@)
$(@)ZSH_CONF_BASE := $(HOME)
$(@)ZSH_CONF_SRC := $(path)/zshrc
$(@>)
$(<@)
$(@)ZSH_CONF_TGT := $(@ZSH_CONF_BASE)/.zshrc
$(@>)

$(call anrem-target, @ZSH_CONF_TGT): $(@ZSH_CONF_SRC)
	cp $< $@

# main target for this module
$(call anrem-target, zsh): $(@ZSH_CONF_TGT)


$(call anrem-clean): zsh-bakclean
	-mv $(@ZSH_CONF_TGT) $(@ZSH_CONF_TGT).bak

$(call anrem-target, zsh-bakclean):
	rm -f $(@ZSH_CONF_TGT).bak

# register backup cleaning target to the cleanup group
$(call anrem-target-group-add, BAK_CLEAN_GRP, zsh-bakclean)
