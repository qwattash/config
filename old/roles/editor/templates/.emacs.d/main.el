; add plugin dir to load path
(add-to-list 'load-path "~/.emacs.d/plugins/")
(add-to-list 'load-path "~/.emacs.d/plugins/forge-mode/")
(add-to-list 'load-path "~/.emacs.d/plugins/local-conf-mode/")
; add config folder to load path
(add-to-list 'load-path "~/.emacs.d/config/")

;; enable modes
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; enable column number
(setq column-number-mode t)

;; enable flyspell on latex
(add-hook 'latex-mode (lambda () (flyspell-mode 1)))

(defun my-indent-setup ()
  (c-set-offset 'arglist-intro '+))
(add-hook 'java-mode-hook 'my-indent-setup)


;; key remapping

;; remap arrow keys to resize windows
(global-set-key (kbd "<left>") 'shrink-window-horizontally)
(global-set-key (kbd "<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "<down>") 'shrink-window)
(global-set-key (kbd "<up>") 'enlarge-window)

(require 'ox-latex)

; define useful macro

(defun print-to-pdf ()
 (interactive)
 (ps-spool-buffer-with-faces)
 (switch-to-buffer "*PostScript*")
 (write-file "tmp.ps")
 (kill-buffer "tmp.ps")
 (setq cmd (concat "ps2pdf14 tmp.ps " (buffer-name) ".pdf"))
 (shell-command cmd)
 (shell-command "rm tmp.ps")
 (message (concat "File printed in : "(buffer-name) ".pdf"))
 )

; execute config code only if library is successfully loaded
;(defmacro with-library (symbol &rest body)
;  '(condition-case nil
;       (progn (require ',symbol) ,@body)
;     nil)
;)
;(put 'with-library 'lisp-indent-function 1)
