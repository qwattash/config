; add plugin dir to load path
(add-to-list 'load-path "~/.emacs.d/plugins/")
; add config folder to load path
(add-to-list 'load-path "~/.emacs.d/config/")


; define useful macro

; execute config code only if library is successfully loaded
;(defmacro with-library (symbol &rest body)
;  '(condition-case nil
;       (progn (require ',symbol) ,@body)
;     nil)
;)
;(put 'with-library 'lisp-indent-function 1)
