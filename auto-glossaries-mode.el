(provide 'auto-gls-mode)

(setq agls-acn-file "root.acn")
(set-buffer (find-file-noselect agls-acn-file))



(defun agls-parse-acn-file()
  (goto-char 1)
  (setq agls-list '())
  (while moreLines
    (search-forward "glossentry{")
    (set-mark (point))
    (search-forward "}")
    (backward-char 1)
    (add-to-list 'agls-list (buffer-substring-no-properties (region-beginning) (region-end)))
    (setq moreLines (= 0 (forward-line 1)))
    )
  )

(defun agls-acronym ()
  (backward-sexp)
  (insert "\\gls{")
  (forward-sexp)
  (insert "}")
  )

(defun agls-check-membership()
  (save-excursion
  (backward-char 1)
  (when (member (thing-at-point 'sexp) agls-list)
    (agls-acronym)
    )
  )
  )

(defun agls-check-word ()
  "Check if the word is in the acronym list"
  (if (= last-command-event 32)
      (agls-check-membership))
  )   

(define-minor-mode auto-gls-mode
  "Documentation goes here"
  :lighter " a-gls"
  (setq agls-list '("com" "foo" "svg"))
  (if auto-gls-mode
      (add-hook 'post-self-insert-hook
		'agls-check-word nil t)
    (remove-hook 'post-self-insert-hook
		 'agls-check-word T)
      )
  )


