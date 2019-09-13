﻿;; utf-8 everywhere
(setq locale-coding-system 'utf-8)   ; pretty
(set-terminal-coding-system 'utf-8)  ; pretty
(set-keyboard-coding-system 'utf-8)  ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8)        ; with sugar on top

(require 'package)
(load-library "url-handlers")

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org"   . "http://orgmode.org/elpa/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; (byte-recompile-directory "~/.emacs.d/config" 0)

(load-file "~/.emacs.d/config/general.el")
(load-file "~/.emacs.d/config/systemdependent.el")
(when (getenv "EMACS_PORTABLE")
  (load-file "~/.emacs.d/config/portable.el"))
(load-file "~/.emacs.d/config/keybindings.el")
(load-file "~/.emacs.d/config/packages.el")
(load-file "~/.emacs.d/config/org.el")
(load-file "~/.emacs.d/config/functions.el")
(load-file "~/.emacs.d/config/theming.el")

(load-file "~/.emacs.d/config/languages/js.el")
(load-file "~/.emacs.d/config/languages/dart.el")
(load-file "~/.emacs.d/config/languages/go.el")
(load-file "~/.emacs.d/config/languages/c.el")



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#839496" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"))
 '(beacon-color "#dc322f")
 '(blink-cursor-mode t)
 '(company-auto-complete nil)
 '(company-clang-arguments nil)
 '(company-clang-executable "clang")
 '(company-clang-insert-arguments nil)
 '(company-dabbrev-downcase nil)
 '(company-idle-delay 0)
 '(company-lighter-base "(C)")
 '(company-minimum-prefix-length 1)
 '(company-posframe-mode t nil (company-posframe))
 '(company-show-numbers 1)
 '(company-tooltip-align-annotations t)
 '(company-tooltip-maximum-width 2305843009213693951)
 '(company-tooltip-minimum-width 0)
 '(company-transformers
   (quote
    (#[128 "\302\300\303\301\"\"\207"
           [cl-remove-if
            ((lambda
               (c)
               (or
                (string-match-p "[^ -]+" c)
                (string-match-p "[0-9]+" c)
                (if
                    (equal major-mode "org")
                    (>=
                     (length c)
                     20)))))
            apply append]
           6 "

(fn &rest ARGS2)"])))
 '(compilation-ask-about-save nil)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-read-command nil)
 '(compilation-scroll-output (quote first-error))
 '(eldoc-idle-delay 0.1)
 '(fci-rule-color "#073642")
 '(flycheck-check-syntax-automatically (quote (save idle-change mode-enabled)))
 '(flycheck-clang-args (quote ("-Wno-pragma-once-outside-header")))
 '(flycheck-clang-ms-extensions t)
 '(flycheck-clang-no-exceptions nil)
 '(flycheck-clang-warnings nil)
 '(flycheck-gcc-language-standard "c++11")
 '(flyspell-default-dictionary "english")
 '(frame-background-mode (quote dark))
 '(global-company-mode t)
 '(global-linum-mode nil)
 '(icomplete-mode t)
 '(isearch-allow-scroll t)
 '(ivy-count-format "(%d/%d) ")
 '(ivy-display-style (quote fancy))
 '(ivy-use-virtual-buffers t)
 '(ivy-virtual-abbreviate (quote full))
 '(markdown-fontify-code-blocks-natively t)
 '(menu-bar-mode nil)
 '(org-latex-default-table-environment "tabular")
 '(org-latex-hyperref-template nil)
 '(org-latex-listings (quote minted))
 '(org-latex-pdf-process (quote ("latexmk -pdf %f")))
 '(org-latex-prefer-user-labels t)
 '(package-selected-packages
   (quote
    (paredit pdf-tools w3m rainbow-mode unicode-fonts all-the-icons-dired doom-modeline elpy ivy-posframe ivy-postframe buffer-expose dired-git-info spaceline iedit imenu-list dap-mode lsp-java modern-cpp-font-lock yasnippet-classic-snippets auto-complete auto-complete-clang-async counsel ivy-rich sr-speedbar racket-mode restclient counsel-tramp ivy-explorer markdown-mode drag-stuff evil flucui-themes flatui-dark-theme ivy-youtube md4rd markdown-mode+ wgrep deadgrep yasnippet-snippets yasnippet dart-mode ov w3 www-synonyms htmlize ox-gfm markdown-preview-mode comment-tags magit rainbow-delimiters yaml-mode telephone-line super-save clang-format cloc gradle-mode lsp-javascript-typescript company-lsp lsp-javascript-flow hy-mode ranger dired-ranger c-eldoc eglot lsp-clangd lsp-mode web-mode wrap-region octicons major-mode-icons mode-icons ivy-gitlab all-the-icons-ivy emmet-mode tide ng2-mode color-theme-sanityinc-solarized ox-twbs ox-reveal org-bullets wttrin wolfram treemacs-projectile treemacs projectile-ripgrep projectile powerline multiple-cursors ivy hl-todo company-go go-mode flycheck-popup-tip flycheck dumb-jump diminish diff-hl browse-kill-ring company-posframe academic-phrases use-package)))
 '(pos-tip-background-color "#1A3734")
 '(pos-tip-foreground-color "#FFFFC8")
 '(rainbow-ansi-colors-major-mode-list (quote (sh-mode)))
 '(rainbow-x-colors-major-mode-list (quote (emacs-lisp-mode lisp-interaction-mode java-mode)))
 '(safe-local-variable-values
   (quote
    ((eval progn
           (defvar context-mode-map
             (make-sparse-keymap)
             "Keymap while context-mode is active.")
           (define-minor-mode context-mode "A temporary minor mode to be activated only specific to a buffer." nil :lighter " [f2]-Context" context-mode-map)
           (context-mode 1)
           (defun start-debugger nil
             (async-shell-command
              (concat "cdbg64.exe" " -t "
                      (expand-windows-path
                       (concat
                        (projectile-project-root)
                        "bin/slime.exe")))))
           (defhydra hydra-context
             (context-mode-map "<f2>")
             "Context Actions:"
             ("b" save-and-find-build-script-and-compile "build" :color blue)
             ("d" start-debugger "debug" :color blue)
             ("o" browse-file-directory "open" :color blue)
             ("q" nil "quit" :color blue))
           (define-key context-mode-map
             (kbd "<f2>")
             (quote hydra-context/body))
           (font-lock-add-keywords
            (quote c++-mode)
            (quote
             (("\\<\\(if_debug\\|if_windows\\|if_linux\\|defer\\|proc\\|try\\|try_void\\|for_array_list\\|for_lisp_vector\\|for_lisp_list\\|ignore_logging\\|dont_break_on_errors\\)\\>" . font-lock-keyword-face)))))
     (eval progn
           (defvar context-mode-map
             (make-sparse-keymap)
             "Keymap while context-mode is active.")
           (define-minor-mode context-mode "A temporary minor mode to be activated only specific to a buffer." nil :lighter " [f2]-Context" context-mode-map)
           (context-mode 1)
           (defun start-debugger nil
             (async-shell-command
              (concat "cdbg64.exe" " -t "
                      (expand-windows-path
                       (concat
                        (projectile-project-root)
                        "bin/slime.exe")))))
           (defhydra hydra-context
             (context-mode-map "<f2>")
             "Context Actions:"
             ("b" save-and-find-build-script-and-compile "build" :color blue)
             ("d" start-debugger "debug" :color blue)
             ("o" browse-file-directory "open" :color blue)
             ("q" nil "quit" :color blue))
           (define-key context-mode-map
             (kbd "<f2>")
             (quote hydra-context/body))
           (font-lock-add-keywords
            (quote c++-mode)
            (quote
             (("\\<\\(if_debug\\|if_windows\\|if_linux\\|defer\\|proc\\|try\\|try_void\\|for_array_list\\|for_lisp_list\\|ignore_logging\\|dont_break_on_errors\\)\\>" . font-lock-keyword-face)))))
     (eval progn
           (defvar context-mode-map
             (make-sparse-keymap)
             "Keymap while context-mode is active.")
           (define-minor-mode context-mode "A temporary minor mode to be activated only specific to a buffer." nil :lighter " [f2]-Context" context-mode-map)
           (context-mode 1)
           (defun start-debugger nil
             (async-shell-command
              (concat "cdbg64.exe" " -t "
                      (expand-windows-path
                       (concat
                        (projectile-project-root)
                        "bin/slime.exe")))))
           (defhydra hydra-context
             (context-mode-map "<f2>")
             "Context Actions:"
             ("b" save-and-find-build-script-and-compile "build" :color blue)
             ("d" start-debugger "debug" :color blue)
             ("o" browse-file-directory "open" :color blue)
             ("q" nil "quit" :color blue))
           (define-key context-mode-map
             (kbd "<f2>")
             (quote hydra-context/body))
           (font-lock-add-keywords
            (quote c++-mode)
            (quote
             (("\\<\\(if_debug\\|if_windows\\|if_linux\\|defer\\|proc\\|try\\|try_void\\|ignore_logging\\|dont_break_on_errors\\)\\>" . font-lock-keyword-face)))))
     (eval progn
           (defvar context-mode-map
             (make-sparse-keymap)
             "Keymap while context-mode is active.")
           (define-minor-mode context-mode "A temporary minor mode to be activated only specific to a buffer." nil :lighter " [f2]-Context" context-mode-map)
           (context-mode 1)
           (defun start-debugger nil
             (async-shell-command
              (concat "cdbg64.exe" " -t "
                      (expand-windows-path
                       (concat
                        (projectile-project-root)
                        "bin/slime.exe")))))
           (defhydra hydra-context
             (context-mode-map "<f2>")
             "Context Actions:"
             ("b" save-and-find-build-script-and-compile "build" :color blue)
             ("d" start-debugger "debug" :color blue)
             ("o" browse-file-directory "open" :color blue)
             ("q" nil "quit" :color blue))
           (define-key context-mode-map
             (kbd "<f2>")
             (quote hydra-context/body))
           (font-lock-add-keywords
            (quote c++-mode)
            (quote
             (("\\<\\(if_debug\\|if_windows\\|if_linux\\|defer\\|proc\\|try\\|try_void\\|without_logging\\)\\>" . font-lock-keyword-face)))))
     (eval progn
           (defvar context-mode-map
             (make-sparse-keymap)
             "Keymap while context-mode is active.")
           (define-minor-mode context-mode "A temporary minor mode to be activated only specific to a buffer." nil :lighter " [f7]-git-status" context-mode-map)
           (context-mode 1)
           (define-key context-mode-map
             (kbd "<f7>")
             (lambda nil
               (interactive)
               (eshell-command "git status"))))
     (org-confirm-babel-evaluate)
     (eval company-clang-set-prefix "slime.h")
     (eval progn
           (defvar context-mode-map
             (make-sparse-keymap)
             "Keymap while context-mode is active.")
           (define-minor-mode context-mode "A temporary minor mode to be activated only specific to a buffer." nil :lighter " [f2]-Context" context-mode-map)
           (context-mode 1)
           (defhydra hydra-context
             (context-mode-map "<f2>")
             "Context Actions:"
             ("b" save-and-find-build-script-and-compile "build" :color blue)
             ("o" browse-file-directory "open" :color blue)
             ("q" nil "quit" :color blue))
           (define-key context-mode-map
             (kbd "<f2>")
             (quote hydra-context/body))
           (font-lock-add-keywords
            (quote c++-mode)
            (quote
             (("\\<\\(if_debug\\|if_windows\\|if_linux\\|defer\\|proc\\|try\\|try_void\\|without_logging\\)\\>" . font-lock-keyword-face))))))))
 '(send-mail-function (quote mailclient-send-it))
 '(show-paren-mode t)
 '(special-display-buffer-names (quote ("*shell - flutter run*")))
 '(tide-format-options (quote (indentSize 4)))
 '(tool-bar-mode nil)
 '(web-mode-markup-indent-offset 2))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Noto Sans Mono" :foundry "outline" :slant normal :weight normal :height 113 :width normal))))
 '(company-preview ((t (:background "#657b83" :foreground "#eee8d5"))))
 '(company-scrollbar-fg ((t (:background "#002B36"))))
 '(company-tooltip-annotation-selection ((t (:inherit company-tooltip-selection :foreground "#859900"))))
 '(diff-hl-change ((t (:background "orange" :foreground "orange"))))
 '(diff-hl-delete ((t (:background "orange red" :foreground "orange red"))))
 '(diff-hl-insert ((t (:inherit diff-added :background "green" :foreground "green"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "#46BA3C" :slant italic))))
 '(font-lock-comment-face ((t (:foreground "#46BA3C" :slant italic))))
 '(linum ((t (:background "#073642" :foreground "#2aa198" :underline nil :slant normal))))
 '(markdown-code-face ((t nil)))
 '(minimap-active-region-background ((t (:background "#001E26"))))
 '(mode-line ((t (:background "#073642" :box nil :weight normal :height 1.0))))
 '(mode-line-buffer-id-inactive ((t (:inherit mode-line-buffer-id :box nil))))
 '(mode-line-inactive ((t (:inherit mode-line :background "#073642" :foreground "#586e75" :box nil :weight normal :height 1.0))))
 '(org-level-1 ((t (:inherit outline-1 :height 1.8))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.5))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.3))))
 '(org-meta-line ((t (:inherit mode-line-buffer-id))))
 '(powerline-active1 ((t (:background "#14282D" :foreground "#839496" :box nil))))
 '(powerline-active2 ((t (:background "#073642" :foreground "#839496" :box nil))))
 '(powerline-inactive1 ((t (:inherit mode-line-inactive :background "grey11" :box nil))))
 '(powerline-inactive2 ((t (:inherit mode-line-inactive :background "grey20" :box nil))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "deep pink"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "chartreuse"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "orchid"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "spring green"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "sienna1"))))
 '(region ((t (:background "#93a1a1" :foreground "SteelBlue4"))))
 '(treemacs-directory-collapsed-face ((t (:inherit default))))
 '(treemacs-directory-face ((t (:inherit default))))
 '(treemacs-git-added-face ((t (:inherit diff-hl-insert :background "#002B36"))))
 '(treemacs-git-ignored-face ((t (:inherit file-name-shadow))))
 '(treemacs-git-modified-face ((t (:inherit diff-hl-change :background "#002B36"))))
 '(treemacs-git-untracked-face ((t (:inherit diff-hl-insert :background "#002B36"))))
 '(treemacs-tags-face ((t (:inherit file-name-shadow))))
 '(window-divider ((t (:foreground "#14282D"))))
 '(window-divider-first-pixel ((t (:foreground "#14282D"))))
 '(window-divider-last-pixel ((t (:foreground "#14282D")))))


(defvar lang :de)
(defun change-lang ()
  (interactive)
  (cond ((eq lang :de)
         (keyboard-translate ?y ?z)  ; For german keyboards
         (keyboard-translate ?z ?y)
         (set-input-method 'korean-hangul)
         (setq lang :kr))
        (t
         (toggle-input-method nil)
         (keyboard-translate ?y ?y)  ; For german keyboards
         (keyboard-translate ?z ?z)
         (setq lang :de)))
    )

(global-set-key (kbd "<f1>") 'change-lang)

(let ((fontset "fontset-default"))
  (set-fontset-font fontset 'hangul "noto sans mono cjk kr regular:pixelsize=20")
  (set-fontset-font fontset 'han    "noto sans mono cjk tc regular:pixelsize=18"))

(add-to-list 'load-path "~/.emacs.d/config/3rd-party/")
(require 'slime-mode)

(setq tramp-default-method "plink")
