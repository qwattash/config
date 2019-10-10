#
# Install xresources and related files
#
# xresources is installed in ~/.Xresources
# related files are installed in ~/.config/x11
#

configure_file(xresources.in ${CMAKE_CURRENT_BINARY_DIR}/xresources)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/xresources DESTINATION $ENV{HOME} RENAME .Xresources)

