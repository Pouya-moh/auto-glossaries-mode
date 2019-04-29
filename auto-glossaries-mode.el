(provide 'auto-gls-mode)

(setq agls-acn-file "acronyms.tex")
(setq agls-list '())


(defun agls-parse-acn-file()
  (setq acro-list '())
  ;(set-buffer (find-file-noselect agls-acn-file))
  (with-temp-buffer
    (insert-file-contents agls-acn-file)
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

(defun agls-acronym ()
  (backward-sexp)
  (insert "\\gls{")
  (forward-sexp)
  (insert "}"))

(defun agls-check-membership()
  (save-excursion
  (backward-char 1)
  (when (member (thing-at-point 'sexp) agls-list)
    (agls-acronym))))

(defun agls-check-word ()
  "Check if the word is in the acronym list"
  (message "ffff")
  (if (= last-command-event 32)
      (agls-check-membership)))   

(define-minor-mode auto-gls-mode
  "Documentation goes here"
  :lighter " AGLS"
;  (setq agls-list '("foo" "bar"))
  (setq agls-list (agls-parse-acn-file))
  (if auto-gls-mode
      (add-hook 'post-self-insert-hook
		'agls-check-word nil t)
    (remove-hook 'post-self-insert-hook
		 'agls-check-word t)))

