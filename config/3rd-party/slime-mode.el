;;;###autoload
(add-to-list 'auto-mode-alist '("\\.slime\\'" . slime-mode))

(put 'define 'doc-string-elt 2)
(put 'define-syntax 'doc-string-elt 3)

;;;###autoload
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
     `((,(concat "\\_<"
                 (regexp-opt
                  '("=" ">" ">=" "<" "<=" "+" "-" "*" "/" "**"
                    "assert" "define" "define-syntax" "mutate" "if"
                    "quote" "quasiquote" "and" "or" "not" "while" "let"
                    "lambda" "special-lambda" "eval" "prog" "list" "pair"
                    "first" "rest" "set-type" "delete-type" "type" "info"
                    "show" "print" "read" "exit" "break" "memstat" "try"
                    "load" "copy" "error" "symbol->keyword" "string->symbol"
                    "symbol->string" "concat-strings"
                    )) "\\_>")
        (0 font-lock-keyword-face)))
     `((,(concat "\\(define\\)\\s-*(\\(\\_<[^ )]*\\)")
        (1 font-lock-keyword-face)
        (2 font-lock-function-name-face)
        ))
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

(provide 'slime-mode)
