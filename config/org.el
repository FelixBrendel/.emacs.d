(require 's)

(defun color-comp (&optional arg)
  "Completion function for color links."
  (let ((color-data (prog2
                        (save-selected-window
                          (list-colors-display))
                        (with-current-buffer (get-buffer "*Colors*")
                          (mapcar (lambda (line)
                                    (append (list line)
                                            (s-split " " line t)))
                                  (s-split "\n" (buffer-string))))
                      (kill-buffer "*Colors*"))))
    (format "color:%s"
            (s-trim (cadr (assoc (completing-read "Color: " color-data) color-data))))))


(defun color-link-face (path)
  "Face function for color links."
  ;; (message path)
  ;; (or 1 (cdr (assoc path org-link-colors))
  `(:underline ,nil :foreground ,path))
  ;; )


(defun color-link-export (path description backend)
  "Export function for color links."
  (cond
   ((eq backend 'latex)                          ; added by TL
    (format "{\\color{%s}%s}" path description)) ; added by TL
   ((or (eq backend 'html) (eq backend 'md) (eq backend 'hugo))
    (let ((rgb (assoc (downcase path) color-name-rgb-alist))
          r g b)
      (setq r (* 255 (/ (nth 1 rgb) 65535.0))
            g (* 255 (/ (nth 2 rgb) 65535.0))
            b (* 255 (/ (nth 3 rgb) 65535.0)))
      (format "<span style=\"color: rgb(%s,%s,%s)\">%s</span>"
              (truncate r) (truncate g) (truncate b)
              (or description path))))))

(with-eval-after-load 'org
  (org-link-set-parameters "color"
                           :face     'color-link-face
                           :complete 'color-comp
                           :export   'color-link-export))

(with-eval-after-load 'org-clock
  (setq org-clock-idle-time 10))

(with-eval-after-load 'compile
  (add-to-list 'compilation-error-regexp-alist 'latex-warning)
  (add-to-list 'compilation-error-regexp-alist-alist
               '(latex-warning
                 "\\(LaTeX.*? Warning:\\(.+\n\\)*\\)" 3 1))

  (add-to-list 'compilation-error-regexp-alist 'latex-error)
  (add-to-list 'compilation-error-regexp-alist-alist
               '(latex-error
                 "\\(.*Error:\\(.+\n\\)*\\)" 1))

  (add-to-list 'compilation-error-regexp-alist 'latex-error2)
  (add-to-list 'compilation-error-regexp-alist-alist
               '(latex-error2
                 "\\(^!\s.*\\)" 1)))


(with-eval-after-load 'org
  (require 'ox-latex)
  (setq org-latex-listings 'minted)
  (setq org-latex-pdf-process '("latexmk -pdf %f"))
  (setq org-default-notes-file "~/org/notes.org")
  (setq org-log-done 'time)
  (setq org-capture-templates
        (quote
         (("t" "Task" entry
           (file+headline "~/org/notes.org" "Tasks")
           "* TODO %?
  %i
  %a")
          ("s" "Schedule entry" entry
           (file+headline "~/org/notes.org" "Schedule")
           ""))))

  (setq org-default-notes-file "~/org/notes.org")
  (setq org-export-dispatch-use-expert-ui nil)
  (setq org-highlight-latex-and-related (quote (latex script entities)))
  (setq org-latex-prefer-user-labels t)
  (setq org-latex-classes
        (quote
         (("scrreprt" "\\documentclass{scrreprt}"
           ("\\chapter{%s}"       . "\\chapter*{%s}")
           ("\\section{%s}"       . "\\section*{%s}")
           ("\\subsection{%s}"    . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}"     . "\\paragraph*{%s}")
           ("\\subparagraph{%s}"  . "\\subparagraph*{%s}"))
          ("scrartcl" "\\documentclass{scrreprt}"
           ("\\chapter{%s}"       . "\\chapter*{%s}")
           ("\\section{%s}"       . "\\section*{%s}")
           ("\\subsection{%s}"    . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}"     . "\\paragraph*{%s}")
           ("\\subparagraph{%s}"  . "\\subparagraph*{%s}"))
          ("sig" "\\documentclass{sig-alternate}"
           ("\\section{%s}"       . "\\section*{%s}")
           ("\\subsection{%s}"    . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}"     . "\\paragraph*{%s}")
           ("\\subparagraph{%s}"  . "\\subparagraph*{%s}"))
          ("article" "\\documentclass[11pt]{article}"
           ("\\section{%s}"       . "\\section*{%s}")
           ("\\subsection{%s}"    . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}"     . "\\paragraph*{%s}")
           ("\\subparagraph{%s}"  . "\\subparagraph*{%s}"))
          ("report" "\\documentclass[11pt]{report}"
           ("\\part{%s}"          . "\\part*{%s}")
           ("\\chapter{%s}"       . "\\chapter*{%s}")
           ("\\section{%s}"       . "\\section*{%s}")
           ("\\subsection{%s}"    . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
          ("book" "\\documentclass[11pt]{book}"
           ("\\part{%s}"          . "\\part*{%s}")
           ("\\chapter{%s}"       . "\\chapter*{%s}")
           ("\\section{%s}"       . "\\section*{%s}")
           ("\\subsection{%s}"    . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))))

  (setq org-latex-default-packages-alist
        (quote
         (("utf8" "inputenc" t)
          ("T1" "fontenc" t)
          ("" "fixltx2e" nil)
          ("" "graphicx" t)
          ("" "grffile" t)
          ("" "longtable" nil)
          ("" "wrapfig" nil)
          ("" "rotating" nil)
          ("normalem" "ulem" t)
          ("" "amsmath" t)
          ("" "textcomp" t)
          ("" "amssymb" t)
          ("" "capt-of" nil))))

  (setq org-latex-hyperref-template nil)
  (setq org-latex-listings (quote minted))
  (setq org-src-fontify-natively t)
  (setq org-structure-template-alist
        (quote
         (("n" "#+begin_notes\n?\n#+end_notes")
          ("s" "#+begin_src ?\n\n#+end_src")
          ("e" "#+begin_example\n?\n#+end_example")
          ("q" "#+begin_quote\n?\n#+end_quote")
          ("v" "#+begin_verse\n?\n#+end_verse")
          ("V" "#+begin_verbatim\n?\n#+end_verbatim")
          ("c" "#+begin_center\n?\n#+end_center")
          ("C" "#+begin_comment\n?\n#+end_comment")
          ("l" "#+begin_export latex\n?\n#+end_export")
          ("L" "#+latex: ")
          ("h" "#+begin_export html\n?\n#+end_export")
          ("H" "#+html: ")
          ("a" "#+begin_export ascii\n?\n#+end_export")
          ("A" "#+ascii: ")
          ("i" "#+index: ?")
          ("I" "#+include: %file ?"))))

  ;; gnu plot
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((gnuplot . t)))

(setq org-babel-default-header-args:gnuplot
      '((:results . "file")
        (:exports . "results"))))



(add-hook 'org-mode-hook (lambda ()
                           (set-fill-column 100)
                           (org-bullets-mode 1)
                           (abbrev-mode 1)
                           (auto-fill-mode 1)))

;; (add-hook 'text-mode-hook #'turn-on-orgtbl)
;; (add-hook 'prog-mode-hook #'turn-on-orgtbl)

(use-package org-bullets
  :ensure t)

(use-package ox-reveal
  :ensure t)

(use-package ox-twbs
  :ensure t)

(use-package ox-hugo
  :ensure t)

(add-hook 'calendar-load-hook
          (lambda ()
            (calendar-set-date-style 'european)))

(setq calendar-week-start-day 1
      calendar-day-name-array ["Sonntag" "Montag" "Dienstag" "Mittwoch"
                               "Donnerstag" "Freitag" "Samstag"]
      calendar-month-name-array ["Januar" "Februar" "März" "April" "Mai"
                                 "Juni" "Juli" "August" "September"
                                 "Oktober" "November" "Dezember"])
(setq solar-n-hemi-seasons
      '("Frühlingsanfang" "Sommeranfang" "Herbstanfang" "Winteranfang"))

(setq holiday-general-holidays
      '((holiday-fixed 1 1 "Neujahr")
        (holiday-fixed 5 1 "1. Mai")
        (holiday-fixed 10 3 "Tag der Deutschen Einheit")))

;; Feiertage für Bayern, weitere auskommentiert
(setq holiday-christian-holidays
      '((holiday-float 12 0 -4 "1. Advent" 24)
        (holiday-float 12 0 -3 "2. Advent" 24)
        (holiday-float 12 0 -2 "3. Advent" 24)
        (holiday-float 12 0 -1 "4. Advent" 24)
        (holiday-fixed 12 25 "1. Weihnachtstag")
        (holiday-fixed 12 26 "2. Weihnachtstag")
        (holiday-fixed 1 6 "Heilige Drei Könige")
        (holiday-easter-etc -48 "Rosenmontag")
        (holiday-easter-etc -3 "Gründonnerstag")
        (holiday-easter-etc  -2 "Karfreitag")
        (holiday-easter-etc   0 "Ostersonntag")
        (holiday-easter-etc  +1 "Ostermontag")
        (holiday-easter-etc +39 "Christi Himmelfahrt")
        (holiday-easter-etc +49 "Pfingstsonntag")
        (holiday-easter-etc +50 "Pfingstmontag")
        (holiday-easter-etc +60 "Fronleichnam")
        (holiday-fixed 8 15 "Mariae Himmelfahrt")
        (holiday-fixed 11 1 "Allerheiligen")
        (holiday-float 11 3 1 "Buss- und Bettag" 16)
        (holiday-float 11 0 1 "Totensonntag" 20)))

(setq holiday-bahai-holidays nil)
(setq holiday-hebrew-holidays nil)
(setq holiday-islamic-holidays nil)
(setq org-agenda-include-diary t)


(setq org-log-done 'time)
