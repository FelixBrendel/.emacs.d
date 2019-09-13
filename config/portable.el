(message "-- Welcome to emacs portable --")

(defvar emax-root    (expand-file-name "~/../3rd-party/emax"))
(defvar emax-bin     (concat emax-root "/bin"))
(defvar emax-bin64   (concat emax-root "/bin64"))
(defvar emax-mingw64 (concat emax-root "/mingw64/bin"))
(defvar emax-lisp    (concat emax-root "/lisp"))
(defvar emax-elpa    (concat emax-root "/elpa"))

(defun replace-in-string (what with in)
  (replace-regexp-in-string (regexp-quote what) with in nil 'literal))

(defun make-windows-path (path)
  (replace-in-string "/" "\\" path))

(defun expand-windows-path (path)
  (make-windows-path (expand-file-name path)))

(setq exec-path (cons "~/../3rd-party/GhostScript/bin/" exec-path))
(setq exec-path (cons "~/../3rd-party/PortableGit/bin/" exec-path))
(setq exec-path (cons "~/../3rd-party/LLVM/bin/"        exec-path))

(setenv "PATH"
        (concat (expand-windows-path "~/../3rd-party/GhostScript/bin/") ";"
                (expand-windows-path "~/../3rd-party/PortableGit/bin/") ";"
                (expand-windows-path "~/../3rd-party/LLVM/bin/") ";"
                (getenv "PATH")))

(setq exec-path (cons emax-bin exec-path))
(setenv "PATH" (concat emax-bin ";" (getenv "PATH")))

(setq exec-path (cons emax-bin64 exec-path))
(setenv "PATH" (concat emax-bin64 ";" (getenv "PATH")))

(setq exec-path (cons emax-mingw64 exec-path))
(setenv "PATH" (concat emax-mingw64 ";" (getenv "PATH")))

(setenv "PATH"
        (concat (expand-windows-path "~/../3rd-party/msys64/bin")         ";"
                (expand-windows-path "~/../3rd-party/msys64/mingw64/bin") ";"
                (getenv "PATH")))

(dolist (dir (list (concat emax-root "/")
                   (concat emax-bin "/")
                   (concat emax-bin64 "/")
                   (concat emax-mingw64 "/")
                   (concat emax-elpa "/")
                   (concat emax-lisp "/")))
  (add-to-list 'load-path dir))


;; Changes made for Aspell
(setq-default ispell-program-name (concat emax-mingw64 "/aspell.exe"))
(setq-default ispell-extra-args  '("--sug-mode=ultra"))
;; (setq ispell-dictionary "en_US")

;; Set "DICTDIR" variable
(setenv "DICTDIR" (concat emax-root "/mingw64/lib/aspell-0.60/"))


;; Automatically enable flyspell-mode in text-mode
;;(require 'flyspell)
;; (add-hook 'text-mode-hook 'flyspell-mode)
;; (setq text-mode-hook '(lambda() (flyspell-mode t) ))
;;(setq text-mode-hook '(lambda()
;;                        (flyspell-mode t)))

;;(dolist (hook '(text-mode-hook))
;;  (add-hook hook (lambda () (flyspell-mode 1))))
;;(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
;;  (add-hook hook (lambda () (flyspell-mode -1))))

;;(setq flyspell-issue-message-flag nil)

;;(require 'auto-dictionary)
;;(add-hook 'flyspell-mode-hook (lambda () (auto-dictionary-mode 1)))

;; (require 'ispell)

(setq epg-gpg-home-directory (concat emax-mingw64 "/"))
(setq epg-gpg-program        (concat emax-mingw64 "/gpg.exe"))
(setq epg-gpgconf-program    (concat emax-mingw64 "/gpgconf.exe"))
