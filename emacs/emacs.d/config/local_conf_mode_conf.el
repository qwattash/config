;; configure and enable auto instert mode for templates

(require 'local-conf-mode)

;; enable mode
(globalized-local-conf-mode t)

;; enable auto insert on empyt buffer
;; skeletons are registered in the auto-insert-alist
;; see emacs autotyping documentation for more
(add-hook 'find-file-hook 'auto-insert)



