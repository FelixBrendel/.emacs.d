(use-package color-theme-sanityinc-solarized
  :ensure t
  :config (load-theme 'sanityinc-solarized-dark t))

(use-package doom-modeline
  :ensure t
  :config
  (setq doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-minor-modes t
        doom-modeline-major-mode-color-icon t
        )
  :hook (after-init . doom-modeline-mode))

(set-face-foreground 'font-lock-comment-face "#46BA3C")
(set-face-foreground 'font-lock-comment-delimiter-face "#46BA3C")

(setq mouse-wheel-scroll-amount '(3 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil)            ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)                  ;; scroll window under mouse
(setq scroll-step 1)                                ;; keyboard scroll one line at a time
(setq scroll-conservatively 101)
(setq fast-but-imprecise-scrolling t)

(set-default 'truncate-lines t)

(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "\
Love's a game
They all say it, they mean it
Might as well have fun
Play every single one")

;; (add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq frame-title-format "%b - Emacs ")
(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(show-paren-mode t)

(setq window-divider-default-places 'right-only)
(setq window-divider-default-right-width 3)
(window-divider-mode t)

(defvar blink-cursor-colors
  (list  "#92c48f" "#6785c5" "#be369c" "#d9ca65")
  "On each blink the cursor will cycle to the next color in this list.")

(setq blink-cursor-count 0)
(defun blink-cursor-timer-function ()
  "Zarza wrote this cyberpunk variant of timer `blink-cursor-timer'.
   Warning: overwrites original version in `frame.el'.

   This one changes the cursor color on each blink. Define colors in `blink-cursor-colors'."
  (when (not (internal-show-cursor-p))
    (when (>= blink-cursor-count (length blink-cursor-colors))
      (setq blink-cursor-count 0))
    (set-cursor-color (nth blink-cursor-count blink-cursor-colors))
    (setq blink-cursor-count (+ 1 blink-cursor-count)))
  (internal-show-cursor nil (not (internal-show-cursor-p))))

(blink-cursor-mode)

(set-frame-parameter (selected-frame) 'alpha '(100 . 96))
(add-to-list 'default-frame-alist '(alpha . (100 . 96)))
(defun transparency-toggle ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(100 . 96) '(100 . 96)))))

(transparency-toggle)
