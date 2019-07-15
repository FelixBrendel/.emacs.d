(use-package academic-phrases
  :defer t
  :ensure t)

(use-package htmlize
  :defer t
  :ensure t)

(if (version< emacs-version "26.0")
    (message "is before 26.0 - skipping company-childframe")
  (use-package company-posframe
    :defer t
    :ensure t
    :diminish
    :config
    (company-posframe-mode 1)))

(use-package company
  :defer t
  :ensure t
  :diminish "(C)"
  :config
  (setq company-dabbrev-downcase nil)
  ;; (setq-default company-lighter-base "(C)")
  (setq-default company-show-numbers          1)
  (setq-default company-idle-delay            0.1) ; start completion immediately
  (setq-default company-minimum-prefix-length 1) ; start completion after 1 character.
  (setq-default company-tooltip-align-annotations t)
  (global-company-mode 1)

  ;; filter companys suggestions, to not contaion numbers, or non ANSII
  ;; characters or if it is too long
  (push (apply-partially #'cl-remove-if
                         (lambda (c)
                           (or (string-match-p "[^\x00-\x7F]+" c)
                               (string-match-p "[0-9]+" c)
                               (if (equal major-mode "org")
                                   (>= (length c) 20)))))
        company-transformers))

(use-package wrap-region
  :defer t
  :ensure t)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :ensure t
  :config
  (setq
   rainbow-delimiters-depth-1-face '(:foreground "dark orange")
   rainbow-delimiters-depth-2-face '(:foreground "deep pink")
   rainbow-delimiters-depth-3-face '(:foreground "chartreuse")
   rainbow-delimiters-depth-4-face '(:foreground "deep sky blue")
   rainbow-delimiters-depth-5-face '(:foreground "yellow")
   rainbow-delimiters-depth-6-face '(:foreground "orchid")
   rainbow-delimiters-depth-7-face '(:foreground "spring green")
   rainbow-delimiters-depth-8-face '(:foreground "sienna1")))


(use-package hydra
  :defer t
  :ensure t)

(use-package browse-kill-ring
  :defer t
  :ensure t
  :config (browse-kill-ring-default-keybindings))

;; (use-package diff-hl
;;   :ensure t
;;   :config
;;   (global-diff-hl-mode t)
;;   (diff-hl-flydiff-mode -1)
;;   (diff-hl-margin-mode -1)
;;   (setq diff-hl-draw-borders t)
;;   (setq diff-hl-flydiff-delay 1)
;;   (setq diff-hl-fringe-bmp-function (quote diff-hl-fringe-bmp-from-pos))
;;   (setq diff-hl-margin-symbols-alist
;;     (quote
;;      ((insert . "|")
;;       (delete . "|")
;;       (change . "|")
;;       (unknown . "|")
;;       (ignored . "|"))))

;;   ;; Workaround for displaying correctly in other window
;;   (use-package frame
;;     :defer t
;;     :config
;;     (progn
;;       (setq window-divider-default-places 'right-only) ;Default 'right-only
;;       ;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=27830#20
;;       ;; Workaround on emacs 26+ to prevent fringe truncation. You need to use
;;       ;; either scroll bars or window dividers to prevent that.
;;       ;; I dislike the default face of `window-divider', so I customize that in my
;;       ;; `smyx-theme`.
;;       (setq window-divider-default-right-width 1) ;Default 6
;;       (window-divider-mode 1))))

;; (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

(use-package diminish
  :defer t
  :ensure t)

(use-package dumb-jump
  :defer t
  :ensure t
  :bind (("M-." . 'dumb-jump-go-set-mark)))

(use-package flycheck
  :defer t
  :ensure t)

(use-package flycheck-popup-tip
  :defer t
  :ensure t)

(add-hook 'flycheck-mode-hook 'flycheck-popup-tip-mode)

(use-package go-mode
  :defer t
  :ensure t)

(use-package company-go
  :defer t
  :ensure t)

(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode)
  :config
  (progn
    (global-hl-todo-mode)
    (setq hl-todo-activate-in-modes '(prog-mode org-mode))
    (setq hl-todo-keyword-faces
          (quote
           (("HOLD" . "#d0bf8f")
            ("TODO" . "#cc9393")
            ("NEXT" . "#dca3a3")
            ("THEM" . "#dc8cc3")
            ("PROG" . "#7cb8bb")
            ("OKAY" . "#7cb8bb")
            ("DONT" . "#5f7f5f")
            ("FAIL" . "#8c5353")
            ("DONE" . "#afd8af")
            ("NOTE" . "#d0bf8f")
            ("KLUDGE" . "#d0bf8f")
            ("HACK" . "#d0bf8f")
            ("FIXME" . "#cc9393")
            ("XXX" . "#cc9393")
            ("XXXX" . "#cc9393")
            ("???" . "#cc9393")
            ("BUG" . "#8c5353")
            ("QUESTION" . "#d0bf8f"))))))

(use-package ivy
  :defer t
  :ensure t
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x b"   . ivy-switch-buffer)
         ("C-x B"   . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-display-style 'fancy)
  (ivy-use-virtual-buffers t)
  :config
    (define-key ivy-minibuffer-map (kbd "RET") 'ivy-alt-done)
    (setq projectile-completion-system 'ivy)
    (setq ivy-on-del-error-function #'ignore)
    (ivy-mode))

(use-package counsel
  :defer t
  :ensure t
  :diminish
  :bind (("M-x" . counsel-M-x)
         ("M-S-s" . counsel-rg)))

(use-package ivy-rich
  :after ivy
  :ensure t
  :custom
  (ivy-virtual-abbreviate 'full
                          ivy-rich-switch-buffer-align-virtual-buffer t
                          ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer)
  (ivy-rich-mode))

(use-package swiper
  :defer t
  :ensure t
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

(use-package magit
  :defer t
  :ensure t
  :bind (("C-x g" . magit-status))
  :config
  (setenv "GIT_ASKPASS" "git-gui--askpass")
  (setenv "SSH_ASKPASS" "git-gui--askpass")
  (setq auto-revert-check-vc-info t))

(use-package magit-org-todos
  :after magit
  :ensure t
  :config
  (magit-org-todos-autoinsert))

(use-package multiple-cursors
  :ensure t
  :bind (("C-d" . 'mark-word-or-next-word-like-this)
         ("C-S-c C-S-c" . 'mc/edit-lines)
         ("C-<mouse-1>" . 'mc/add-cursor-on-click))
  :config (define-key mc/keymap (kbd "<return>") nil))

(use-package powerline
  :ensure t
  :config
   (setq powerline-default-separator (quote wave))
   (setq powerline-display-hud t)
   (setq powerline-gui-use-vcs-glyph nil)
   (setq powerline-height 25)
   (setq powerline-text-scale-factor nil)
   (powerline-default-theme))

(use-package projectile
  :ensure t
  :defer nil
  :diminish
  :bind ("C-c T" . projectile-find-todos)
  :init
  (progn
    (setq projectile-keymap-prefix (kbd "C-c p"))    
    ;; (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
    )
  :config
  (projectile-mode))




(use-package projectile-ripgrep
  :ensure t
  :defer t
  :after projectile)

(use-package rainbow-mode
  :defer t
  :ensure t
  :diminish
  :hook (prog-mode))

(use-package treemacs
  :defer t
  :ensure t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (setq treemacs-change-root-without-asking nil
        treemacs-collapse-dirs              (if (executable-find "python") 3 0)
        treemacs-file-event-delay           100
        treemacs-filewatch-mode             t
        treemacs-follow-after-init          t
        treemacs-follow-recenter-distance   0.1
        treemacs-goto-tag-strategy          'refetch-index
        treemacs-indentation                2
        treemacs-indentation-string         " "
        treemacs-is-never-other-window      t
        treemacs-never-persist              nil
        treemacs-no-png-images              nil
        treemacs-recenter-after-file-follow nil
        treemacs-recenter-after-tag-follow  nil
        treemacs-show-hidden-files          t
        treemacs-silent-filewatch           nil
        treemacs-silent-refresh             t
        treemacs-sorting                    'alphabetic-desc
        treemacs-tag-follow-cleanup         t
        treemacs-tag-follow-delay           1.5
        treemacs-width                      35)

  ;;   ;; (treemacs-follow-mode t)
  ;;   ;; (treemacs-filewatch-mode t)
  ;;   ;; (treemacs-git-mode 'simple)

  :bind
  (:map global-map
        ([f8]         . treemacs)
        ("M-0"        . treemacs-select-window)
        ("C-x 1"      . treemacs-delete-other-windows)))

(use-package treemacs-projectile
  :defer t
  :ensure t
  :after treemacs
  :config
  (setq treemacs-header-function #'treemacs-projectile-create-header))

(use-package wolfram
  :defer t
  :ensure t
  :config
  (setq wolfram-alpha-app-id "UX8T57-3WXAA24JHT"))


(use-package wttrin
  :defer t
  :ensure t
  :config
  (setq wttrin-default-accept-language '("Accept-Language" . "de-DE"))
  (setq wttrin-default-cities '("Munich" "서울" "구리시")))

(require 'winner)
(winner-mode 1)

(use-package drag-stuff
  :diminish
  :defer t
  :ensure t
  :bind (("<M-up>" . drag-stuff-up)
         ("<M-down>" . drag-stuff-down)
         ("<M-left>" . drag-stuff-left)
         ("<M-right>" . drag-stuff-right))
  :config
  (drag-stuff-global-mode 1)
  (with-eval-after-load 'org
    (define-key org-mode-map (kbd "<M-up>")
      (lambda () (interactive)
        (call-interactively (if (org-at-heading-p) 'org-metaup 'drag-stuff-up))))

    (define-key org-mode-map (kbd "<M-down>")
      (lambda () (interactive)
        (call-interactively (if (org-at-heading-p) 'org-metadown 'drag-stuff-down))))))
