;;; auto-glossaries-mode.el
;;
;; This little minor mode parses an acronym file and creates a list
;; out of it first. The aim is to facilitate the latex workflow of
;; typing \gls{foo} dicated by glossaries package. In this case, foo
;; is extraced from acronym file and when user types foo, the minor
;; mode automatically replaces it with \gls{foo}
;;
;;
;;
;;        Author: Pouya-moh
;;           URL: https://github.com/Pouya-moh/auto-glossaries-mode
;;       Version: 0.1
;; Dependencies : none
;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.


(provide 'auto-glossaries-mode)

(setq agls-acronym-file "acronyms.tex")
(setq agls-acronym-list '())


(defun agls-parse-acronym-file()
  "Parses and the file, extracts acronyms, and store them in a list"
  (setq acro-list '())
  (with-temp-buffer
    (insert-file-contents agls-acronym-file)
    (goto-char 1)
    (setq eol-flag nil)
    (while (not eol-flag)
      (search-forward "newacronym{")
      (set-mark (point))
      (search-forward "}")
      (backward-char 1)
      (add-to-list 'acro-list (buffer-substring-no-properties (region-beginning) (region-end)))
      (forward-line 1)
      (setq eol-flag (eq (point) (point-max)))))
  acro-list)

(defun agls-acronymize ()
  "This is the string that will surround the typed acronym"
  (backward-sexp)
  (insert "\\gls{")
  (forward-sexp)
  (insert "}"))

(defun agls-check-membership()
  "check weather the last sexp is in the acronym list"
  (save-excursion
  (backward-char 1)
  (when (member (thing-at-point 'sexp) agls-acronym-list)
    (agls-acronymize))))

(defun agls-check-if-word ()
  "If the last key stroke was whitespace, then check for sexp membership in the list"
  (if (= last-command-event 32)
      (agls-check-membership)))   

(define-minor-mode auto-glossaries-mode
  "A simple minor mode to automatically surrond acronyms in gls macro in latex mode"
  :lighter " AGLS"
  (setq agls-acronym-list (agls-parse-acronym-file))
  (if auto-glossaries-mode
      (add-hook 'post-self-insert-hook
		'agls-check-if-word nil t)
    (remove-hook 'post-self-insert-hook
		 'agls-check-if-word t)))

