#
# Install urxvt and xterm configurations
#

install(FILES urxvt.conf DESTINATION $ENV{HOME}/.config/x11)
install(FILES xterm.conf DESTINATION $ENV{HOME}/.config/x11)
install(FILES tmux.conf DESTINATION $ENV{HOME} RENAME .tmux.conf)
