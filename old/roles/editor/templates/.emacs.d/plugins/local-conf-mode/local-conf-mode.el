;;
;; A minor mode that loads skeletons defined in a version controlled project
;; in parent directories of the cwd.
;; The default name used for the custom skeleton definition file can be changed.
;; The skeleton definition file is loaded by emacs as soon as it is discovered.
;;
;; Author: Alfredo Mazzinghi (qwattash)
;; 
;; License: GPLv3
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;;     along with this program.  If not, see <http://www.gnu.org/licenses/>.
;; 

(defcustom local-conf-mode-file-pattern
  "%s-local"
  "Format string used to build the name of the local configuration resource
from the repository name"
  :group 'local-conf-mode)

(defun local-conf-load ()
  "Load local emacs file if any"
  (let ((vc-root (local-conf-get-vc-root)))
    (message "<local conf mode> VCS root found at %s" vc-root)
    (if (null vc-root)
	nil
      (let* ((vc-root-dir (file-name-as-directory vc-root))
	     ;; path root directory of the repository with trailing '/'
	     (vc-repo-name (file-name-nondirectory (directory-file-name vc-root-dir)))
	     ;; name of the version control repository
	     (resource-id (format local-conf-mode-file-pattern vc-repo-name))
	     ;; id of the resource to 'require
	     )
	(if (file-exists-p (concat vc-root-dir resource-id ".el"))
	    (progn
	      ;; add repository root to emacs load path and import the feature
	      (add-to-list 'load-path vc-root-dir)
	      (message resource-id)
	      (require (intern resource-id)))
	  nil)))))

;; currently only support git
(defun local-conf-get-vc-root ()
  "Get the version control root in which the pwd is contained.
If the cwd is not under version control return nil"
  (condition-case err
      (let ((vc-root-list (process-lines "git" "rev-parse" "--show-toplevel")))
	(car vc-root-list))
    (error
     nil)))

(define-minor-mode local-conf-mode
  "A minor mode that loads project-local emacs files"
  :lighter " local-conf"
  :group 'local-conf-mode
  (local-conf-load))

(define-globalized-minor-mode globalized-local-conf-mode ; name of the new mode
  local-conf-mode ; name of the mode that is activated
  (lambda () (local-conf-mode t)) ; mode enable function
  )
  
(provide 'local-conf-mode)
