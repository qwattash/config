
;; gas mode
;(require 'gas-mode)
;(add-to-list 'auto-mode-alist '("\\.S\\'" . gas-mode))


(defun conf-asm-mode ()
  (setq indent-tabs-mode nil)
  (setq tab-stop-list (number-sequence 4 120 4))
  ;;(setq tab-width 4)
)

(add-hook 'asm-mode-hook 'conf-asm-mode)
