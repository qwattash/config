; add plugin dir to load path
(add-to-list 'load-path "~/.emacs.d/plugins/")
; add config folder to load path
(add-to-list 'load-path "~/.emacs.d/config/")

;; enable column number
(setq column-number-mode t)

;; remap arrow keys to resize windows
(global-set-key (kbd "<left>") 'shrink-window-horizontally)
(global-set-key (kbd "<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "<down>") 'shrink-window)
(global-set-key (kbd "<up>") 'enlarge-window)


; define useful macro

; execute config code only if library is successfully loaded
;(defmacro with-library (symbol &rest body)
;  '(condition-case nil
;       (progn (require ',symbol) ,@body)
;     nil)
;)
;(put 'with-library 'lisp-indent-function 1)
