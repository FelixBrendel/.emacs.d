(require 'lawndart)
(add-to-list 'auto-mode-alist '("\\.dart\\'" . lawndart-mode))

(setq flutter--running-p nil)

(defun flutter-format-buffer ()
  (interactive)
  ;; (save-buffer)
  (shell-command (concat "flutter " "format " (buffer-file-name)))
  (revert-buffer t t t))
;; (start-process "flutter formater" "*flutter formater*" "flutter" "format" (buffer-file-name)))

(defun flutter-analyze-project ()
  (interactive)
  (save-buffer)
  (start-process-shell-command "flutter analyze" "*flutter analyze*" "flutter" "analyze" default-directory))

(defun flutter--send-command-to-eshell (command)
  (if (not flutter--running-p)
      (error "flutter run is not running")
    (select-frame-by-name "flutter-run")
    (end-of-buffer)
    (erase-buffer)
    (insert command)
    (comint-send-input)
    (end-of-buffer)
    (other-frame 1)))

(defun flutter-hot-reload ()
  (interactive)
  (save-buffer)
  (flutter--send-command-to-eshell "r"))

(defun flutter-hard-reload ()
  (interactive)
  (save-buffer)
  (flutter--send-command-to-eshell "R"))

(defun flutter-run-start ()
  (interactive)
  (when flutter--running-p
    (error "flutter run is already running"))
  (let ((root-path (locate-dominating-file (expand-file-name default-directory) ".packages")))
    (unless root-path
      (error "not in a flutter project"))
    (make-frame '((name . "flutter-run")))
    (select-frame-by-name "flutter-run")
    (shell)
    (rename-buffer "*shell - flutter run*")
    (delete-other-windows)
    (compilation-shell-minor-mode 1)
    (insert (concat "cd " root-path ""))
    (comint-send-input)
    (insert "flutter run")
    (comint-send-input)
    (end-of-buffer)
    (other-frame 1)
    (setq flutter--running-p t)))

(defun flutter-run-kill ()
  (interactive)
  (unless flutter--running-p
    (error "flutter run is not running"))
  (select-frame-by-name "flutter-run")
  (let ((kill-buffer-query-functions
         (delq 'process-kill-buffer-query-function kill-buffer-query-functions)))
    (kill-buffer "*shell - flutter run*"))
  (delete-frame)
  (setq flutter--running-p nil))

(defun flutter-after-save-hook ()
  ;; (when (eq major-mode 'dart-mode)
    ;; (when flutter--running-p
      ;; (flutter-hot-reload))
    ;; (flutter-format-buffer)
  ;; )
)

(defun flutter-run-emulator ()
  (interactive)
  (start-process "flutter emulator" "*flutter emulator*" "flutter" "emulators" "--launch" "flutter_emulator"))

(add-hook 'after-save-hook 'flutter-after-save-hook)

(require 'compile)

(add-to-list 'compilation-error-regexp-alist 'dart)
(add-to-list 'compilation-error-regexp-alist-alist
             '(dart "file:///\\([^:]*:[^:]*\\):\\([1-9]+\\):\\([1-9]+\\)" 1 2 3))

(add-to-list 'compilation-error-regexp-alist 'flutter)
(add-to-list 'compilation-error-regexp-alist-alist
             '(flutter "\\([^ ]+\\):\\([0-9]+\\):\\([0-9]+\\):" 1 2 3))

(add-to-list 'compilation-error-regexp-alist 'dart-package)
(add-to-list 'compilation-error-regexp-alist-alist
             '(dart-package "(package:\\([^:]*\\):\\([0-9]*\\):\\([0-9]*\\))"
                            (1 "packages/%s") 2 3))


(defhydra hydra-dart (:color pink :hint nil)
  "
^flutter^          ^cosmetics^          ^enulator
^^^^^^^^^^--------------------------------------------------------
_s_: run          _a_: analyze project  _e_ start emulator
_k_: kill         _f_: format buffer    ^ ^
_r_: reload       ^ ^                   ^ ^
_R_: reload hard  ^ ^                   ^ ^
"
  ("s" flutter-run-start       :color blue)
  ("k" flutter-run-kill        :color blue)
  ("r" flutter-hot-reload      :color blue)
  ("R" flutter-hard-reload     :color blue)
  ("a" flutter-analyze-project :color blue)
  ("f" flutter-format-buffer   :color blue)
  ("e" flutter-run-emulator    :color blue)
  ("q" nil "quit" :color blue))
