#
# Install zsh configuration
#
#

install(FILES zshrc DESTINATION $ENV{HOME} RENAME .zshrc)
install(DIRECTORY common/ DESTINATION $ENV{HOME}/.config/zsh)
