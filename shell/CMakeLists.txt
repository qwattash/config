#
# Install zsh configuration
#
#

set(HOME $ENV{HOME})
set(ZSH_CONF_PATH $ENV{HOME}/.config/zsh)

configure_file(zshrc.in ${CMAKE_CURRENT_BINARY_DIR}/zshrc @ONLY)
configure_file(common/stat.zsh.in ${CMAKE_CURRENT_BINARY_DIR}/stat.zsh @ONLY)
configure_file(common/arch.zsh.in ${CMAKE_CURRENT_BINARY_DIR}/arch.zsh @ONLY)
configure_file(common/fortune.zsh.in ${CMAKE_CURRENT_BINARY_DIR}/fortune.zsh @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/zshrc DESTINATION $ENV{HOME} RENAME .zshrc)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/stat.zsh ${CMAKE_CURRENT_BINARY_DIR}/arch.zsh ${CMAKE_CURRENT_BINARY_DIR}/fortune.zsh
	DESTINATION ${ZSH_CONF_PATH})
install(FILES common/gen_screen.py common/colors.zsh
	DESTINATION ${ZSH_CONF_PATH})
