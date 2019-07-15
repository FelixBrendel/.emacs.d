(require 'cl-lib)
(require 'company)


(defconst slime-built-ins
  '("=" ">" ">=" "<" "<=" "+" "-" "*" "/" "**" "%"
    "assert" "define" "define-syntax" "mutate" "if"
    "quote" "quasiquote" "unquote" "unquote-splicing" "and" "or" "not" "while" "let"
    "lambda" "special-lambda" "eval" "begin" "list" "pair"
    "first" "rest" "set-type" "delete-type" "type" "info"
    "show" "addr-of" "generate-docs" "print" "read" "exit" "break" "memstat" "try"
    "load" "import" "copy" "error" "symbol->keyword" "string->symbol"
    "symbol->string" "concat-strings"))


(defun my-slime-eldoc-function ()
  (let ((symbol (symbol-name (car (read (thing-at-point 'sexp))))))
    (if (member symbol slime-built-ins)
        (sample-meta symbol)
      (concat symbol " ?"))))

(defun sample-meta (s)
  (cond
   ((string= s "=")   "(= :rest <objects>)")
   ((string= s ">")   "(> :rest <numbers>)")
   ((string= s ">=") "(>= :rest <numbers>)")
   ((string= s "<")   "(< :rest <numbers>)")
   ((string= s "<=") "(<= :rest <numbers>)")
   ((string= s "+")   "(+ :rest <numbers>)")
   ((string= s "-")   "(- :rest <numbers>)")
   ((string= s "*")   "(* :rest <numbers>)")
   ((string= s "/")   "(/ :rest <numbers>)")
   ((string= s "**") "(** <number> <exponent>)")
   ((string= s "assert") "(assert <condition>)")
   ((string= s "define") "(define <name-or-lambda-list> [doc-string] <expression-or-bodx>)")
   ((string= s "define-syntax") "(define-syntax <name-and-lambda-list> [doc-string] <bodx>)")
   ((string= s "mutate")  "(mutate <expression> <expression>)")
   ((string= s "if") "(if <test> <consequence> <alternative>)")
   (t "")))


(add-to-list 'auto-mode-alist '("\\.slime\\'" . slime-mode))

(put 'lambda 'doc-string-elt 2)
(put 'special-lambda 'doc-string-elt 2)
(put 'define 'doc-string-elt 2)
(put 'define-syntax 'doc-string-elt 2)

(define-derived-mode slime-mode prog-mode "(slime)"
  "Major mode for editing slime code."
  :group 'lisp

  (defvar project-vc-external-roots-function)

  (set-syntax-table lisp-mode-syntax-table)
  (setq-local lisp-mode-symbol-regexp "\\(?:\\sw\\|\\s_\\|\\\\.\\|?\\)+")
  (setq-local paragraph-ignore-fill-prefix t)
  (setq-local fill-paragraph-function 'lisp-fill-paragraph)
  (setq-local adaptive-fill-function #'lisp-adaptive-fill)
  ;; Adaptive fill mode gets in the way of auto-fill,
  ;; and should make no difference for explicit fill
  ;; because lisp-fill-paragraph should do the job.
  ;;  I believe that newcomment's auto-fill code properly deals with it  -stef
  ;;(set (make-local-variable 'adaptive-fill-mode) nil)
  (setq-local indent-line-function 'lisp-indent-line)
  (setq-local indent-region-function 'lisp-indent-region)
  (setq-local comment-indent-function #'lisp-comment-indent)
  ;; (setq-local outline-regexp ";;;\\(;* [^ \t\n]\\|###autoload\\)\\|(")
  (setq-local outline-level 'lisp-outline-level)
  (setq-local add-log-current-defun-function #'lisp-current-defun-name)
  (setq-local comment-start ";")
  (setq-local comment-start-skip ";+ *")
  (setq-local comment-add 1)            ;default to `;;' in comment-region
  (setq-local comment-column 40)
  (setq-local comment-use-syntax t)
  (setq-local imenu-generic-expression lisp-imenu-generic-expression)
  (setq-local multibyte-syntax-as-symbol t)

  (defconst yess
    (append
     `((,(concat "\\(define\\)\\s-*(\\(\\_<[^ )]*\\)")
        (1 font-lock-keyword-face)
        (2 font-lock-function-name-face)
        ))
     `((,(concat "(\\s-*\\_<"
                 (regexp-opt
                  slime-built-ins) "\\_>")
        (0 font-lock-keyword-face)))
     `((,(concat "[`‘]\\(\\(?:\\sw\\|\\s_\\|\\\\.\\)"
                 lisp-mode-symbol-regexp "\\)['’]")
        (1 font-lock-constant-face prepend))
       ;; Constant values.
       (,(concat "\\_<:" lisp-mode-symbol-regexp "\\_>")
        (0 font-lock-builtin-face)))

     ))

  (setq font-lock-defaults
        `((yess)
          nil nil nil nil
          (font-lock-mark-block-function . mark-defun)
          (font-lock-extra-managed-props help-echo)
          (font-lock-syntactic-face-function
           . lisp-font-lock-syntactic-face-function)))
  ;; (setq font-lock-defaults '((;; ads
  ;;                             ;; lisp-el-font-lock-keywords-1
  ;;                             ;; lisp-el-font-lock-keywords-2
  ;;                             )
  ;;                           nil nil nil nil
  ;;                           (font-lock-mark-block-function . mark-defun)
  ;;                           (font-lock-extra-managed-props help-echo)
  ;;                           (font-lock-syntactic-face-function
  ;;                            . lisp-font-lock-syntactic-face-function)))
  (setq-local prettify-symbols-alist lisp-prettify-symbols-alist)
  (setq-local electric-pair-skip-whitespace 'chomp)
  (setq-local electric-pair-open-newline-between-pairs nil)

  (add-hook 'after-load-functions #'elisp--font-lock-flush-elisp-buffers)
  (unless noninteractive
    (require 'elec-pair)
    (defvar electric-pair-text-pairs)
    (setq-local electric-pair-text-pairs
                (append '((?\` . ?\') (?‘ . ?’)) electric-pair-text-pairs))
    (setq-local electric-quote-string t))
  (setq imenu-case-fold-search nil)
  (add-function :before-until (local 'eldoc-documentation-function)
                #'elisp-eldoc-documentation-function)
  (add-hook 'xref-backend-functions #'elisp--xref-backend nil t)
  (setq-local project-vc-external-roots-function #'elisp-load-path-roots)
  (add-hook 'completion-at-point-functions #'elisp-completion-at-point nil 'local)
  (add-hook 'flymake-diagnostic-functions  #'elisp-flymake-checkdoc nil t)
  (add-hook 'flymake-diagnostic-functions  #'elisp-flymake-byte-compile nil t))


(defun company-simple-backend (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-simple-backend))
    (prefix (when (looking-back "foo\\>")
              (match-string 0)))
    (candidates (when (equal arg "foo")
                  (list "foobar" "foobaz" "foobarbaz")))
    (meta (format "This value is named %s" arg))))

(defun company-sample-backend (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-sample-backend))
    (prefix (and (eq major-mode 'slime-mode)
                 (company-grab-symbol)))
    (candidates
     (remove-if-not
      (lambda (c) (string-prefix-p arg c))
      slime-built-ins))
    (meta (sample-meta arg))))

(add-hook 'slime-mode-hook
          (lambda ()
            ;; (set (make-local-variable 'eldoc-documentation-function) 'my-slime-eldoc-function)
            (set (make-local-variable 'company-backends) '(company-sample-backend))))

(provide 'slime-mode)
