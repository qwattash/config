#
# Install targets for emacs configuration files
# 
# emacs is installed in ~/.emacs
# emacs.d is installed in ~/.emacs.d

install(FILES emacs DESTINATION $ENV{HOME} RENAME .emacs)
install(DIRECTORY emacs.d/ DESTINATION $ENV{HOME}/.emacs.d)
