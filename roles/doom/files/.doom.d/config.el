;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Mirco De Zorzi"
      user-mail-address "mircodezorzi@protonmail.com")

(setq scroll-conservatively 101
      gc-cons-threshold 100000000)

(setq doom-font (font-spec :family "Fira Code" :size 20)
      doom-big-font (font-spec :family "Fira Code" :size 30)
      doom-mixed-pitch-font (font-spec :family "Overpass" :size 30))

(set-face-attribute 'line-number-current-line nil :inherit '(fixed-pitch))
(set-face-attribute 'line-number nil :inherit '(fixed-pitch))

(setq doom-theme 'doom-tomorrow-night)

(display-time-mode 1)                        ; enable time in the mode-line
(unless (equal "Battery status not avalible" ; enable battery in the mode-line
               (battery))
  (display-battery-mode 1))

(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case."
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(setq display-line-numbers-type 'relative)

(after! highlight-indent-guides
  (setq highlight-indent-guides-method 'bitmap)
  (highlight-indent-guides-auto-set-faces))

(setq +pretty-code-symbols '(:lambda "λ"))

(setq evil-split-window-below t
      evil-vsplit-window-right t)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(evil-mode t)

(setq key-chord-two-keys-delay 0.025)
(key-chord-define evil-insert-state-map "eu" 'evil-normal-state)
(key-chord-mode 1)

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (add-hook 'evil-normal-state-entry-hook #'company-abort))

(map!
  :after company
  :map company-mode-map
  :nvm (kbd "C-SPC") #'company-complete-selection)

(map!
  :leader
  :after company
  :map company-mode-map
  :nvm (kbd "C-H") #'lsp-ui-doc-show)

(setq lsp-ui-doc-position              'at-point
      lsp-ui-doc-header                nil
      lsp-ui-doc-border                "violet"
      lsp-ui-doc-include-signature     t
      lsp-ui-flycheck-enable           t)

(setq yas-snippet-dirs '("~/.doom.d/snippets"))

(map!
  :leader
  :nvm (kbd "c c") #'evilnc-comment-or-uncomment-lines
  :nvm (kbd "c p") #'evilnc-comment-or-uncomment-paragraphs)

(after! evil-snipe
  (evil-snipe-mode -1))

(after! latex
  (setq TeX-save-query nil
        TeX-command-extra-options "-shell-escape"))

(after! latex
  (setq +latex-viewers '(pdf-tools zathura)))

(setq ispell-dictionary "en-custom")

(setq org-directory "~/org/")

(after! org
  (appendq! +pretty-code-symbols
            `(:src_block     "»"
              :src_block_end "«"
              :results       "⟹"
              :checkbox      "☐"
              :pending       "◼"
              :checkedbox    "☑"
              :priority_a      ,(propertize "⚑" 'face 'all-the-icons-red)
              :priority_b      ,(propertize "⚑" 'face 'all-the-icons-orange)
              :priority_c      ,(propertize "⚑" 'face 'all-the-icons-yellow))))

(after! org
  (set-pretty-symbols! 'org-mode
    :merge t
    :src_block     "#+BEGIN_SRC"
    :src_block_end "#+END_SRC"
    :results       "#+RESULTS:"
    :checkbox      "[ ]"
    :pending       "[-]"
    :checkedbox    "[X]"
    :priority_a    "[#A]"
    :priority_b    "[#B]"
    :priority_c    "[#C]"))

(plist-put +pretty-code-symbols :name "foobar")

(after! org
  (defun scimax-org-renumber-environment (orig-func &rest args)
    "A function to inject numbers in LaTeX fragment previews."
    (let ((results '())
          (counter -1)
          (numberp))
      (setq results (loop for (begin .  env) in
                          (org-element-map (org-element-parse-buffer) 'latex-environment
                            (lambda (env)
                              (cons
                               (org-element-property :begin env)
                               (org-element-property :value env))))
                          collect
                          (cond
                           ((and (string-match "\\\\begin{equation}" env)
                                 (not (string-match "\\\\tag{" env)))
                            (incf counter)
                            (cons begin counter))
                           ((string-match "\\\\begin{align}" env)
                            (prog2
                                (incf counter)
                                (cons begin counter)
                              (with-temp-buffer
                                (insert env)
                                (goto-char (point-min))
                                ;; \\ is used for a new line. Each one leads to a number
                                (incf counter (count-matches "\\\\$"))
                                ;; unless there are nonumbers.
                                (goto-char (point-min))
                                (decf counter (count-matches "\\nonumber")))))
                           (t
                            (cons begin nil)))))

      (when (setq numberp (cdr (assoc (point) results)))
        (setf (car args)
              (concat
               (format "\\setcounter{equation}{%s}\n" numberp)
               (car args)))))

    (apply orig-func args))


  (defun scimax-toggle-latex-equation-numbering ()
    "Toggle whether LaTeX fragments are numbered."
    (interactive)
    (if (not (get 'scimax-org-renumber-environment 'enabled))
        (progn
          (advice-add 'org-create-formula-image :around #'scimax-org-renumber-environment)
          (put 'scimax-org-renumber-environment 'enabled t)
          (message "Latex numbering enabled"))
      (advice-remove 'org-create-formula-image #'scimax-org-renumber-environment)
      (put 'scimax-org-renumber-environment 'enabled nil)
      (message "Latex numbering disabled.")))

  (advice-add 'org-create-formula-image :around #'scimax-org-renumber-environment)
  (put 'scimax-org-renumber-environment 'enabled t))

(map!
  :after calendar
  :map calendar-mode-map
  :nvm (kbd "d") #'calendar-backward-day
  :nvm (kbd "h") #'calendar-forward-week
  :nvm (kbd "t") #'calendar-backward-week
  :nvm (kbd "n") #'calendar-forward-day)

(map!
  :after treemacs
  :map treemacs-mode-map
  :nvm (kbd "h") #'treemacs-next-line
  :nvm (kbd "t") #'treemacs-previous-line)

(map!
  :after notmuch
  :map notmuch-search-mode-map
  :nvm "d" #'evil-backward-char
  :nvm "t" #'evil-previous-line
  :nvm "C-t" #'evil-window-up)

(map!
  :after evil-org
  :map evil-org-mode-map
  :nvm "d" #'evil-backward-char
  :nvm (kbd "M-t") #'org-metaup
  :nvm (kbd "M-h") #'org-metadown)

(map!
  :nvm "d" #'evil-backward-char
  :nvm "n" #'evil-forward-char
  :nvm "h" #'evil-next-line
  :nvm "t" #'evil-previous-line

  :nvm "D" #'evil-beginning-of-line
  :nvm "N" #'evil-end-of-line
  :nvm "H" (kbd "5h")
  :nvm "T" (kbd "5t"))

(map!
  :nvm "j" #'evil-delete
  :nvm "k" #'evil-find-char-to

  :nvm "l" #'evil-search-next
  :nvm "L" #'evil-search-previous)

(map!
  :nvm "C-d" #'evil-window-left
  :nvm "C-h" #'evil-window-down
  :nvm "C-t" #'evil-window-up
  :nvm "C-n" #'evil-window-right)

(map!
  :nvm "M-+" #'doom/increase-font-size
  :nvm "M--" #'doom/decrease-font-size
 
  :nvm "C-k" #'evil-insert-digraph

  :nvm "s" #'evil-ex)

(defun org-wrap-source ()
  (interactive)
  (let ((lang (read-string "Language: "))
        (start (min (point) (mark)))
        (end (max (point) (mark))))
    (goto-char end)
    (unless (bolp)
      (newline))
    (insert "#+END_SRC\n")
    (goto-char start)
    (unless (bolp)
      (newline))
    (insert (format "#+BEGIN_SRC %s\n" lang))))

(map!
  :v (kbd "C-C C-W") #'org-wrap-source)
