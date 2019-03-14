(setq find-todo-regex "\\b((TODO)|(NOTE)|(QUESTION)|(HACK)|(BUG))")

;;
;; Little Fixes
;;
(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))
;; (add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

;; after adding a word to the dictionary, run flyspell again, instead
;; of removing all the markup
(defun flyspell-buffer-after-pdict-save (&rest _)
  (flyspell-buffer))
(advice-add 'ispell-pdict-save :after #'flyspell-buffer-after-pdict-save)

;; auto overwrap i-search
;; (defadvice isearch-search (after isearch-no-fail activate)
;;   (unless isearch-success
;;     (ad-disable-advice 'isearch-search 'after 'isearch-no-fail)
;;     (ad-activate 'isearch-search)
;;     (isearch-repeat (if isearch-forward 'forward))
;;     (ad-enable-advice 'isearch-search 'after 'isearch-no-fail)
;;     (ad-activate 'isearch-search)))

;; Prevents issue where you have to press backspace twice when trying
;; to remove the first character that fails a search
;; (define-key isearch-mode-map [remap isearch-delete-char] 'isearch-del-char)

;; some performance improvements
;; https://github.com/sabof/org-bullets/issues/11#issuecomment-439228372
;; (setq inhibit-compacting-font-caches t)

;; the Minibuffer should inherit the active input method.
;; https://emacs.stackexchange.com/questions/38310/how-to-make-minibuffer-always-use-the-input-method-of-the-main-buffer
(defun my-inherit-input-method ()
  "Inherit input method from `minibuffer-selected-window'."
  (let* ((win (minibuffer-selected-window))
         (buf (and win (window-buffer win))))
    (when buf
      (activate-input-method (buffer-local-value 'current-input-method buf)))))

(add-hook 'minibuffer-setup-hook #'my-inherit-input-method)

;; search for highlighted if exist
;; (defun jrh-isearch-with-region ()
;;   "Use region as the isearch text."
;;   (when mark-active
;;     (let ((region (funcall region-extract-function nil)))
;;       (deactivate-mark)
;;       (isearch-push-state)
;;       (isearch-yank-string region))))
;; (add-hook 'isearch-mode-hook #'jrh-isearch-with-region)
;;
;; Garbage Collection
;;

;; (setq gc-cons-threshold (eval-when-compile (* 1024 1024 1024)))
;; (run-with-idle-timer 30 t (lambda () (garbage-collect)))

;;
;; Backups
;;
(setq backup-directory-alist `(("." . "~/.emacs-saves")))
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t
      create-lockfiles nil)

;;
;; Compilation
;;
(setq compilation-ask-about-save nil)
(setq compilation-auto-jump-to-first-error nil)
(setq compilation-read-command nil)
(setq compilation-srscroll-output t)
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (read-only-mode 1)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (read-only-mode 1))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; (defadvice yank (around html-yank-indent)
;;   "Indents after yanking."
;;   (let ((point-before (point)))
;;     ad-do-it
;;       (indent-region point-before (point))))
;; (ad-activate 'yank)

;;
;; Quality of Life; small settings
;;
(global-auto-revert-mode t)
(defalias 'yes-or-no-p 'y-or-n-p)
(modify-syntax-entry ?_ "w")
(setq visible-bell nil ring-bell-function #'ignore)
(setq sentence-end-double-space nil)
(delete-selection-mode 1)
(add-hook 'doc-view-mode-hook (lambda ()
                                (auto-revert-mode)
                                (setq doc-view-continuous t)))

;;
;; Save Hooks
;;
;; (defun untabify-except-makefiles ()
;;   "Replace tabs with spaces except in makefiles."
;;   (unless (derived-mode-p 'makefile-mode)
;;     (untabify (point-min) (point-max))))

(setq-default indent-tabs-mode nil)
(defun fix-tabification ()
  (if indent-tabs-mode
      (tabify (point-min) (point-max))
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'fix-tabification)
(add-hook 'before-save-hook 'delete-trailing-whitespace-except-current-line)

(add-hook 'focus-out-hook          (lambda () (when (and buffer-file-name (buffer-modified-p)) (save-buffer))))
(add-hook 'mouse-leave-buffer-hook (lambda () (when (and buffer-file-name (buffer-modified-p)) (save-buffer))))

 (defadvice switch-to-buffer (before save-buffer-now activate)
   (when (and buffer-file-name (buffer-modified-p)) (save-buffer)))
 (defadvice other-window (before other-window-now activate)
(when (and buffer-file-name (buffer-modified-p)) (save-buffer)))
