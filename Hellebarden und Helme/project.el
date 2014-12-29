;; do need the latest org-mode for @<br/> to work?
;; (add-to-list 'load-path "~/src/org-mode")
(let ((dir (file-name-directory (buffer-file-name))))
  (setq org-publish-project-alist
	`(("Hellebarden und Helme"
	   :base-directory ,dir
	   :publishing-directory ,dir
	   :publishing-function org-html-publish-to-html
	   :exclude "-source\\.org"
	   :section-numbers nil
	   :html-postamble nil
	   :makeindex t))))
(org-publish-project "Hellebarden und Helme" t)
