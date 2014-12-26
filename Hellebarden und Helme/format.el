(defun my-latex-to-org (start end)
  (interactive "r")
  (goto-char end)
  (while (search-backward "\\" start t)
    (forward-char 1)
    (cond ((looking-at "newthought\\|marginnote")
	   (forward-char -1)
	   (delete-region (point) (match-end 0))
	   (when (looking-at "\\[")
	     (zap-to-char 1 ?\]))
	   (let ((p (point)))
	     (forward-sexp 1)
	     (delete-char -1)
	     (goto-char p)
	     (delete-char 1)))
	  ((looking-at "hyperref")
	   (forward-char -1)
	   (zap-to-char 1 ?\])
	   (let ((p (point)))
	     (forward-sexp 1)
	     (delete-char -1)
	     (goto-char p)
	     (delete-char 1)))
	  ((looking-at "textbf")
	   (forward-char -1)
	   (delete-region (point) (match-end 0))
	   (let ((p (point)))
	     (forward-sexp 1)
	     (delete-char -1)
	     (insert "*")
	     (goto-char p)
	     (delete-char 1)
	     (insert "*")))
	  ((looking-at "emph")
	   (forward-char -1)
	   (delete-region (point) (match-end 0))
	   (let ((p (point)))
	     (forward-sexp 1)
	     (delete-char -1)
	     (insert "/")
	     (goto-char p)
	     (delete-char 1)
	     (insert "/")))
	  ((looking-at "unit")
	   (forward-char -1)
	   (delete-region (point) (match-end 0))
	   (delete-char 1)
	   (search-forward "]{")
	   (delete-char -2)
	   (when (looking-at "Fuss\\|Pfund")
	     (insert " "))
	   (when (looking-at "Minuten")
	     (replace-match "min" t))
	   (search-forward "}")
	   (delete-char -1))
	  ((looking-at "times")
	   (delete-region (- (match-beginning 0) 2) (+ (match-end 0) 1))
	   (insert "×"))
	  ((looking-at "%")
	   (delete-char -1))
	  (t
	   (forward-char 1))))
  (goto-char start)
  (while (search-forward "~" end t)
    (replace-match " ")))
  