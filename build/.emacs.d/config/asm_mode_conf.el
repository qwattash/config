(defun conf-asm-mode ()
  (setq indent-tabs-mode nil)
  (setq tab-stop-list (number-sequence 4 120 4))
)

(add-hook 'asm-mode-hook 'conf-asm-mode)
