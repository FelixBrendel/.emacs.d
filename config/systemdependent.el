(setq user-full-name    "Felix Brendel"
      user-mail-address "felixbrendel@airmail.cc")


(cond ((string= system-type "windows-nt")
       ;; if windows
       (when (boundp 'w32-pipe-read-delay)
         (setq w32-pipe-read-delay 0))
       (setq inhibit-compacting-font-caches t)
       (setq build-script-name "build.bat")
       (setq doc-view-ghostscript-program "gswin64c.exe")
       (setq org-reveal-root "file:///d:/Programme/revealjs/reveal.js-3.6.0/")
       (setq company-clang-executable "c:/Languages/LLVM/bin/clang.exe")
       (add-to-list 'exec-path "D:/Daten/Coding/Go/Library/bin/"))
      (t
       ;; if linux
       (setq build-script-name "build.sh")))

(setq org-agenda-files '("~/org"))
