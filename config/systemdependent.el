(setq user-full-name    "Felix Brendel"
      user-mail-address "felix@brendel.engineering")

(if (string= system-type "windows-nt")
    (setq build-script-name "build.bat")
  (setq build-script-name "build.sh"))

(setq doc-view-ghostscript-program "gswin64c.exe")

(add-to-list 'exec-path "D:/Daten/Coding/Go/Library/bin/")

(setq org-reveal-root "file:///d:/Programme/revealjs/reveal.js-3.6.0/")
(setq company-clang-executable "c:/Languages/LLVM/bin/clang.exe")
(setq org-agenda-files '("~/org"))
