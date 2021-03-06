;;; flycheck-checkpatch.el -- Flyckeck support for checkpatch.pl tool

;; Copyright (c) 2016 Alexander Yarygin <yarygin.alexander@gmail.com>

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; An easy way to write Linux kernel or QEMU code
;; according to the style guidelines.

;; Enable this checker by adding code like the following
;; to your startup files:

;;     (eval-after-load 'flycheck
;;       '(flycheck-checkpatch-setup))

;;;; Code:

(require 'flycheck)

(defvar flycheck-scripts-directory "scripts")

(defun flycheck-checkpatch-scripts-directory (&optional checker)
  (and (buffer-file-name)
       (locate-dominating-file (buffer-file-name)
                               flycheck-scripts-directory)))

(defun flycheck-checkpatch-set-executable ()
  (when-let ((directory (flycheck-checkpatch-scripts-directory)))
    (setq-local flycheck-checkpatch-executable
		(concat directory flycheck-scripts-directory "/checkpatch.pl"))))

(flycheck-define-checker checkpatch
  "The Linux kernel (or qemu) checkpatch.pl checker"
  :command ("checkpatch.pl" "--terse" "-f" source)
  :error-patterns
  ((warning line-start (file-name) ":" line ": WARNING: " (message) line-end)
   (error line-start (file-name) ":" line ": ERROR: " (message) line-end))
  :modes (c-mode)
  :working-directory flycheck-checkpatch-scripts-directory
  :predicate flycheck-checkpatch-scripts-directory)

;;;###autoload
(defun flycheck-checkpatch-setup ()
  "Setup Flycheck checkpatch."
  (add-to-list 'flycheck-checkers 'checkpatch)
  (add-hook 'flycheck-mode-hook #'flycheck-checkpatch-set-executable))

(provide 'flycheck-checkpatch)
;;; flycheck-checkpatch.el ends here
