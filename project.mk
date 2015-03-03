# main build target

# home directory alias
HOME := $(abspath $(wildcard ~/))


.PHONY: conf_all bakclean

$(call anrem-build, conf_all): emacs

$(call anrem-target, bakclean): $(call anrem-target-group-depend, BAK_CLEAN_GRP)
