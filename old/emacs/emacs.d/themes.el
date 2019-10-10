; add load path
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/.config/emacs/")
(add-to-list 'load-path "~/.config/emacs/")

; load the zenburn theme
(load-theme 'zenburn t)
; (load-theme `tomorrow-night-eighties t)
; (load-theme `tomorrow-night t)
