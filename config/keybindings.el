(with-eval-after-load 'org
  ;; (define-key org-mode-map (kbd "<f2>") 'org-agenda-show-agenda-and-todo)
  (define-key org-mode-map (kbd "C-#") 'comment-line)

  (define-key org-mode-map (kbd "C-j") 'join-line)
  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c c") 'org-capture))

(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "<mouse-1>") 'org-agenda-goto-mouse))

(with-eval-after-load 'flyspell
  (define-key flyspell-mouse-map (kbd "<mouse-3>") 'flyspell-correct-word))

(with-eval-after-load 'rjsx-mode
  (define-key rjsx-mode-map (kbd "C-d") 'mark-word-or-next-word-like-this))

(with-eval-after-load 'dart-mode
  (define-key dart-mode-map (kbd "C-d") 'mark-word-or-next-word-like-this))

(add-hook 'java-mode-hook '(lambda () (interactive) (define-key java-mode-map (kbd "C-d") 'mark-word-or-next-word-like-this)))

(with-eval-after-load 'cc-mode (define-key c-mode-map (kbd "C-d") 'mark-word-or-next-word-like-this))
(with-eval-after-load 'cc-mode (define-key c++-mode-map (kbd "C-d") 'mark-word-or-next-word-like-this))

(with-eval-after-load 'doc-view
  (define-key doc-view-mode-map (kbd "<C-wheel-up>") 'doc-view-enlarge)
  (define-key doc-view-mode-map (kbd "<C-wheel-down>") 'doc-view-shrink))

(global-unset-key (kbd "ESC ESC ESC"))
(global-unset-key (kbd "<f2> <f2>"))
(global-set-key (kbd "<f2>") 'open-context-hydra)

(global-unset-key (kbd "C-<down-mouse-1>"))
(global-unset-key "\C-d")

(global-set-key (kbd "M-RET") (lambda () (interactive) (move-end-of-line 1) (newline)))

(global-set-key (kbd "C-S-d") 'duplicate-line)

(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(global-set-key (kbd "C-S-g") 'abort-recursive-edit)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-c e") 'save-and-find-build-script-and-compile)

(global-set-key (kbd "C-z") 'winner-undo)
(global-set-key (kbd "C-j") 'join-line)

(global-set-key (kbd "C-c i") 'find-user-init-file)

;; Open specific files / buffers
(global-set-key (kbd "C-c t") 'find-org-capture-file)

(global-set-key (kbd "C-#") 'comment-line)

;; ;; projectile
(global-set-key (kbd "C-c T") 'projectile-find-todos)
;; (global-set-key (kbd "C-c p p") 'projectile-switch-project)
;; (global-set-key (kbd "C-c p s r") 'projectile-ripgrep)
;; (global-set-key (kbd "C-c p f") 'projectile--find-file)
