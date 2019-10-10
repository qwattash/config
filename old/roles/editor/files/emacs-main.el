;; Package archives
(setq package-user-dir (concat user-emacs-directory "packages"))

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

;; List of packages to install
(defvar config-package-list
  '(
    ;; autocomplete

    ;; modes
    yaml-mode
    markdown-mode
    ;; gn-mode

    ;; utilities
    ag

    ;; templates
    yasnippet

    ;; themes
    )
  "List of packages that are installed and upgraded.")

;; Install or update configured emacs packages
(defun config-install-packages ()
  "Install configured packages"
  ;; refresh package contents
  (package-refresh-contents)
  (dolist (pkg config-package-list)
    (package-install pkg)))

