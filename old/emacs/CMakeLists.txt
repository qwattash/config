#
# Install targets for emacs configuration files
# 
# emacs is installed in ~/.emacs
# emacs.d is installed in ~/.emacs.d

install(FILES emacs DESTINATION $ENV{HOME} RENAME .emacs)
install(DIRECTORY emacs.d/ DESTINATION $ENV{HOME}/.emacs.d)

# we should automatically pull emacs packages from melpa instead
# of having a static copy here
# add_custom_command()
