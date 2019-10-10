#
# Install X11 theme
#

install(FILES "tomorrow-theme/Xdefaults/XresourceTomorrowNight" DESTINATION $ENV{HOME}/.config/x11 RENAME theme.conf)
install(FILES "tomorrow-theme/GNU Emacs/tomorrow-night-theme.el" "tomorrow-theme/GNU Emacs/color-theme-tomorrow.el" DESTINATION $ENV{HOME}/.config/emacs)
