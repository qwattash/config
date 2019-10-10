# local-conf-mode
Local configuration loader for emacs.
The minor mode attempts to load local file for every
buffer opened in a git repo.
Other vcs may be supported as well in the future.
This was primarily designed to add project-related skeletons and templates but may be used for other purposes as well.

# Installation
Just enable the mode in your .emacs or wherever you prefer
```elisp
(globalized-local-conf-mode t)
```
Or enable it from the buffer
```
M-x local-conf-mode
```
# Usage
Create a file named <repo-name>-local.el in the root of your git repo
and add your local project definitions there.
The file must provide the feature
```elisp
(provide '<repo-name>-local)
```
An example is shown in local-conf-mode-local.el

# Customize
You can customize the name of the file:
```elisp
(custom-set-variables
  '(local-conf-mode-file "my_file_name.el"))
```

