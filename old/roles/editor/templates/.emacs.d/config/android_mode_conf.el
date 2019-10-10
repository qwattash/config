; elpa package
; android-mode (minor mode)
; use android-mode-hook
(defun conf-android-mode ()
  (custom-set-variable android-mode-sdk-dir "~/opt/android-sdk")
)

(add-hook 'android-mode-hook 'conf-android-mode)
