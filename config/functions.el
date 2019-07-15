(defun open-context-hydra ()
  (interactive)
  (cond
   ((member major-mode '(lawndart-mode)) (hydra-dart/body))
   ((member major-mode '(rjsx-mode)) (hydra-yarn/body))
   (t (error "There is no hydra defined for the current major mode"))))

(defun eshell-other-window ()
  "Open a `eshell' in a new window."
  (interactive)
  (let ((buf (eshell)))
    (switch-to-buffer (other-buffer buf))
    (switch-to-buffer-other-window buf)))

(defun org-agenda-show-agenda-and-todo (&optional arg)
  (interactive "P")
  (org-agenda arg "n" "buffer"))


(defalias 'raw-yank (symbol-function 'yank))

(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
           (and (not current-prefix-arg)
                (member major-mode '(emacs-lisp-mode lisp-mode
                                                     clojure-mode    scheme-mode
                                                     haskell-mode    ruby-mode
                                                     rspec-mode      python-mode
                                                     c-mode          c++-mode
                                                     objc-mode       latex-mode
                                                     plain-tex-mode))
                (let ((mark-even-if-inactive transient-mark-mode))
                  (indent-region (region-beginning) (region-end) nil))))))

(defun duplicate-line()
  (interactive)
  (let ((inhibit-message 1))
  (save-excursion
    (move-beginning-of-line 1)
    (set-mark (point-marker))
    (move-end-of-line 1)
    (copy-region-as-kill (region-beginning) (region-end))
    (deactivate-mark)
    (insert "\n")
    (raw-yank)
    (pop kill-ring))
  (call-interactively 'next-line)))

(defun dumb-jump-go-set-mark ()
  "Sets a mark and dumb jumps."
  (interactive)
  (kbd "C-SPC C-SPC")
  (dumb-jump-go nil))

(defun projectile-find-todos ()
  "find TODOS in the project."
  (interactive)
  (ripgrep-regexp find-todo-regex (projectile-project-root)))

(defun save-and-find-build-script-and-compile ()
  "Walks upward the directory tree until a buildscript is found"
  (interactive)
  (when (and buffer-file-name (buffer-modified-p)) (save-buffer))
  (let* ((build-script-path (locate-dominating-file (expand-file-name default-directory) build-script-name)))
    (if build-script-path (progn
                            (setq compile-command (concat build-script-path build-script-name))
                            (compile compile-command))
      (error (concat "The default buildscript '" build-script-name "' cannot be found")))))

(defun move-lines (n)
  (let ((beg) (end) (keep))
    (if mark-active
        (save-excursion
          (setq keep t)
          (setq beg (region-beginning)
                end (region-end))
          (goto-char beg)
          (setq beg (line-beginning-position))
          (goto-char end)
          (setq end (line-beginning-position 2)))
      (setq beg (line-beginning-position)
            end (line-beginning-position 2)))
    (let (
          (offset (if (and (mark t)
                           (and (>= (mark t) beg)
                                (< (mark t) end)))
                      (- (point) (mark t))))
          (marked-lines (if (region-active-p)
                            (count-lines (region-beginning) (region-end))
                          1))
          (rewind (- end (point))))

      (goto-char (if (< n 0) beg end))
      (forward-line n)
      (insert (delete-and-extract-region beg end))
      (backward-char rewind)
      (if offset (set-mark (- (point) offset))))
    (if keep
        (setq mark-active t
              deactivate-mark nil))))

(defun move-lines-up (n)
  "move the line(s) spanned by the active region up by N lines."
  (interactive "*p")
  (move-lines -1))

(defun move-lines-down (n)
  "move the line(s) spanned by the active region down by N lines."
  (interactive "*p")
  (move-lines 1))

(defun find-user-init-file ()
  "Edit the `init.org', in another window."
  (interactive)
  (find-file-other-window "~/.emacs.d/init.el"))

(defun find-org-capture-file ()
  "Edit the org capture file, in another window."
  (interactive)
  (find-file-other-window org-default-notes-file))

(defun browse-file-directory ()
  "Open the current file's directory however the OS would."
  (interactive)
  (if default-directory
      (browse-url-of-file (expand-file-name default-directory))
    (error "No `default-directory' to open")))

(defun delete-trailing-whitespace-except-current-line ()
  (interactive)
  (let ((begin (line-beginning-position))
        (end (line-end-position)))
    (save-excursion
      (when (< (point-min) begin)
        (save-restriction
          (narrow-to-region (point-min) (1- begin))
          (delete-trailing-whitespace)))
      (when (> (point-max) end)
        (save-restriction
          (narrow-to-region (1+ end) (point-max))
          (delete-trailing-whitespace))))))

(defun save-and-export-to-pdf ()
  "Save the buffer and then latex export to pdf."
  (interactive)
  (save-buffer)
  (org-latex-export-to-pdf)
  ;; (switch-to-buffer-other-window "*Org PDF LaTeX Output*")
  ;; (compilation-mode)
  )

(defun save-and-export-to-reavealjs ()
  "Save the buffer and then latex export to reavealjs slides."
  (interactive)
  (save-buffer)
  (org-reveal-export-to-html-and-browse))

(defun mark-current-word (&optional arg allow-extend)
  "Put point at beginning of current word, set mark at end."
  (interactive "p\np")
  (setq arg (if arg arg 1))
  (if (and allow-extend
           (or (and (eq last-command this-command) (mark t))
               (region-active-p)))
      (set-mark
       (save-excursion
         (when (< (mark) (point))
           (setq arg (- arg)))
         (goto-char (mark))
         (forward-word arg)
         (point)))
    (let ((wbounds (bounds-of-thing-at-point 'word)))
      (unless (consp wbounds)
        (error "No word at point"))
      (if (>= arg 0)
          (goto-char (car wbounds))
        (goto-char (cdr wbounds)))
      (push-mark (save-excursion
                   (forward-word arg)
                   (point)))
      (activate-mark))))

(defun mark-word-or-next-word-like-this ()
  "if there is no active region the word under
   the point will be marked, otherwise the next word is selected."
  (interactive)
  (if (region-active-p)
      ;; then
      (progn
        (mc/mark-more-like-this nil 'forwards)
        (mc/maybe-multiple-cursors-mode)
        (mc/cycle-forward))
    ;; else
    (mc--select-thing-at-point 'symbol)))


(defun insert-build-script()
  "Prompt user to pick a build script to insert."
  (interactive)
  (require 'ido)
  (let ((choices-alist '(("cl.exe" . "@echo off
pushd %~dp0

set exeName=main.exe
set binDir=bin

mkdir quickbuild
pushd quickbuild

cl^
   ../src/*.cpp^
   /Fe%exeName% /MP /openmp /W3 /std:c++latest^
   /nologo /EHsc /Z7^
   /link /incremental /debug:fastlink

if %errorlevel% == 0 (
   echo.
   if not exist ..\\%binDir% mkdir ..\\%binDir%
   move %exeName% ..\\%binDir%\\ > NUL
   pushd ..\\%binDir%
  echo ---------- Output start ----------
   %exeName%
   echo ---------- Output   end ----------
   del %exeName% /S /Q > NUL
   popd
) else (
  echo.
  echo Fucki'n 'ell
)

popd
rd quickbuild /S /Q
popd") ("generic" . "@echo off
pushd %~dp0

build
run

popd") ("java junit" . "@echo off
pushd %~dp0

rem we need `junit-4.12.jar` in the source folder
javac -cp junit-4.12.jar -d build *.java

if %errorlevel% == 0 (
   rem we need junit-4.12.jar and hamcrest-core-1.3.jar in the build folder
   pushd build
   java -cp .;junit-4.12.jar;hamcrest-core-1.3.jar org.junit.runner.JUnitCore MergeSortTest
   popd
) else (
   echo.
   echo Fucki'n 'ell
)
popd
") ("python" . "@echo off
pushd %~dp0

python filename.py

popd") ("go" . "@echo off

set mainFileName=main

pushd %~dp0

go build %mainFileName%.go

if %errorlevel% == 0 (
   echo.

   echo ---------- Output start ----------
   %mainFileName%
   echo ---------- Output   end ----------

) else (
  echo.
  echo Fucki'n 'ell
)

popd") ("org-mode" . "@echo off
pushd %~dp0

set fileName=\"Ausarbeitung\"
set pdfTempDir=\"temp_pdf\"

emacsclient -c ^
 -e \"(progn (require 'org) (find-file-other-window \\\"%fileName%.org\\\") (org-latex-export-to-latex) (save-buffers-kill-terminal))\"

echo.
echo ================================================
echo               Tex Export Finished
echo ================================================
echo.

if %errorlevel% == 0 (
    if not exist %pdfTempDir% (
        mkdir %pdfTempDir%
    ) else (
        call :copyfilesin
    )

    latexmk -Werror -pdf -shell-escape %fileName%.tex && (
        call :cleanup
        goto :success
    ) || (
        echo Errors converting to pdf ㅠㅠ
        call :cleanup
        goto :fail
    )
) else (
    echo Errors converting to tex ㅠㅠ
    goto:fail
)

:copyfilesin
for /f \"usebackq\" %%m in (`dir /b %pdfTempDir%\\*minted*`) do (
    move \"%pdfTempDir%\\%%m\" \"%%m\" > NUL
)
move %pdfTempDir%\\*.aux .\\ > NUL
move %pdfTempDir%\\*.bbl .\\ > NUL
move %pdfTempDir%\\*.blg .\\ > NUL
move %pdfTempDir%\\*.fdb_latexmk .\\ > NUL
move %pdfTempDir%\\*.fls .\\ > NUL
move %pdfTempDir%\\*.log .\\ > NUL
move %pdfTempDir%\\*.out .\\ > NUL
move %pdfTempDir%\\*.toc .\\ > NUL
goto :eof

:cleanup
for /f \"usebackq\" %%m in (`dir /b *minted*`) do (
    move \"%%m\" \"%pdfTempDir%\\%%m\" > NUL
)
move *.aux %pdfTempDir%\\ > NUL
move *.bbl %pdfTempDir%\\ > NUL
move *.blg %pdfTempDir%\\ > NUL
move *.fdb_latexmk %pdfTempDir%\\ > NUL
move *.fls %pdfTempDir%\\ > NUL
move *.log %pdfTempDir%\\ > NUL
move *.out %pdfTempDir%\\ > NUL
move *.toc %pdfTempDir%\\ > NUL
goto :eof

:success
popd
echo yey
exit 0

:fail
popd
exit 1")

)))
    (let ((choice (ido-completing-read "Insert build script for:" (mapcar #'car choices-alist))))
      (insert (alist-get choice choices-alist)))))
