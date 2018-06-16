(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; keep the installed packages in .emacs.d
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
(package-initialize)

;; update the package metadata is the local cache is missing
(unless package-archive-contents
  (package-refresh-contents))

(setq user-full-name "Pirackr"
      user-mail-address "pirackr@gmail.com")

;; Always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(defconst pirackr-savefile-dir (expand-file-name "savefile" user-emacs-directory))

;; create the savefile dir if it doesn't exist
(unless (file-exists-p pirackr-savefile-dir)
  (make-directory pirackr-savefile-dir))

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-verbose t)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(menu-bar-mode -1)

;; highlight the current line
(global-hl-line-mode +1)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; delete the selection with a keypress
(delete-selection-mode t)

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; Turn off the scrollbar
(toggle-scroll-bar -1)

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; extend the help commands
(define-key 'help-command (kbd "C-f") #'find-function)
(define-key 'help-command (kbd "C-k") #'find-function-on-key)
(define-key 'help-command (kbd "C-v") #'find-variable)
(define-key 'help-command (kbd "C-l") #'find-library)

(define-key 'help-command (kbd "C-i") #'info-display-manual)

;; misc useful keybindings
(global-set-key (kbd "s-<") #'beginning-of-buffer)
(global-set-key (kbd "s->") #'end-of-buffer)
(global-set-key (kbd "s-q") #'fill-paragraph)
(global-set-key (kbd "s-x") #'execute-extended-command)

(use-package ielm
  :config
  (add-hook 'ielm-mode-hook #'eldoc-mode)
  (add-hook 'ielm-mode-hook #'rainbow-delimiters-mode))

;; avy is a GNU Emacs package for jumping to visible text using a char-based decision tree.
(use-package avy
  :ensure t
  :bind (("C-'" . avy-goto-word-or-subword-1)
         ("C-:" . avy-goto-char))
  :config
  (setq avy-background t))

(use-package ag
  :ensure t)

;; “/u/mernst/tmp/Makefile" and "/usr/projects/zaphod/Makefile” would be named “Makefile|tmp” and “Makefile|zaphod”
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/")
  ;; rename after killing uniquified
  (setq uniquify-after-kill-buffer-p t)
  ;; don't muck with special buffers
  (setq uniquify-ignore-buffers-re "^\\*"))

;; saveplace remembers your location in a file when saving files
(require 'saveplace)
(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "saveplace" pirackr-savefile-dir))
  ;; activate it for all buffers
  (setq-default save-place t))

;; A very simple alternative to more involved SessionManagement solutions.
(use-package savehist
  :config
  (setq savehist-additional-variables
        ;; search entries
        '(search-ring regexp-search-ring)
        ;; save every minute
        savehist-autosave-interval 60
        ;; keep the home clean
        savehist-file (expand-file-name "savehist" pirackr-savefile-dir))
  (savehist-mode +1))

;; Recentf is a minor mode that builds a list of recently opened files.
(use-package recentf
  :config
  (setq recentf-save-file (expand-file-name "recentf" pirackr-savefile-dir)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode +1))

;; use shift + arrow keys to switch between visible buffers
(use-package windmove
  :config
  (windmove-default-keybindings))

(use-package dired
  :config
  ;; dired - reuse current buffer by pressing 'a'
  (put 'dired-find-alternate-file 'disabled nil) ;

  ;; always delete and copy recursively
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)

  ;; if there is a dired buffer displayed in the next window, use its
  ;; current subdir, instead of the current subdir of this dired buffer
  (setq dired-dwim-target t)

  ;; enable some really cool extensions like C-x C-j(dired-jump)
  (require 'dired-x))

;; anzu.el is an Emacs port of anzu.vim. anzu.el provides a minor mode which displays current match and total matches information in the mode-line in various search modes.
(use-package anzu
  :ensure t
  :bind (("M-%" . anzu-query-replace)
         ("C-M-%" . anzu-query-replace-regexp))
  :config
  (global-anzu-mode))

;; Easier to kill or to mark
(use-package easy-kill
  :ensure t
  :config
  (global-set-key [remap kill-ring-save] 'easy-kill))

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package move-text
  :ensure t
  :bind
  (([(meta shift up)] . move-text-up)
   ([(meta shift down)] . move-text-down)))

;; Match parens and highlight
(use-package rainbow-delimiters
  :ensure t)

;; Colorize color names in buffers
(use-package rainbow-mode
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-mode))

(use-package whitespace
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook))
    (add-hook hook #'whitespace-mode))
  (add-hook 'before-save-hook #'whitespace-cleanup)
  :config
  (setq whitespace-line-column 120) ;; limit line length
  (setq whitespace-style '(face tabs empty trailing lines-tail)))

(use-package ido
  :ensure t
  :config
  (setq ido-enable-prefix nil
        ido-enable-flex-matching t
        ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-max-prospects 10
        ido-save-directory-list-file (expand-file-name "ido.hist" pirackr-savefile-dir)
        ido-default-file-method 'selected-window
        ido-auto-merge-work-directories-length -1)
  (ido-mode +1))

(use-package ido-completing-read+
  :ensure t
  :config
  (ido-ubiquitous-mode +1))

(use-package flx-ido
  :ensure t
  :config
  (flx-ido-mode +1)
  ;; disable ido faces to see flx highlights
  (setq ido-use-faces nil))

;;A smart M-x enhancement for Emacs.
(use-package smex
  :ensure t
  :bind ("M-x" . smex))

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode +1))

(use-package flyspell
  :config
  (when (eq system-type 'windows-nt)
    (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/"))
  (setq ispell-program-name "aspell" ; use aspell instead of ispell
        ispell-extra-args '("--sug-mode=ultra"))
  (add-hook 'text-mode-hook #'flyspell-mode)
  (add-hook 'prog-mode-hook #'flyspell-prog-mode))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; Diff highlight
(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode +1)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;; Save Emacs buffers when they lose focus
(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))

;; Emacs package that displays available keybindings in popup
(use-package which-key
  :ensure t
  :config
  (which-key-mode +1))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode +1))

(use-package fzf
  :ensure t
  :config
  (global-set-key (kbd "C-c t") 'fzf-git-files)
  )

(use-package markdown-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package pipenv
  :hook (python-mode . pipenv-mode)
  :init
  (setq
   pipenv-projectile-after-switch-function
   #'pipenv-projectile-after-switch-extended))

(use-package importmagic
  :ensure t
  :config
  (add-hook 'python-mode-hook 'importmagic-mode))

(use-package latex-preview-pane
  :ensure t
  :config)

(use-package import-js
  :ensure t)

(use-package haskell-mode
  :ensure t)

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode)
  )


(use-package docker-compose-mode
  :ensure t)

(use-package base16-theme
  :ensure t
  :config
  (load-theme 'base16-ocean t))

(use-package dockerfile-mode
  :ensure t)

(use-package rspec-mode
  :ensure t
  :config
  (setq rspec-use-docker-when-possible 1)
  (setq rspec-docker-container "dev")
  (setq rspec-docker-cwd "")
  (add-hook 'after-init-hook 'inf-ruby-switch-setup)
)

(use-package typescript-mode
  :ensure t)


(use-package terraform-mode
  :ensure t)


(use-package company-terraform
  :ensure t)

(use-package restclient
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.http\\'" . restclient-mode))
)

(use-package company-restclient
  :ensure t
  :config
  (add-to-list 'company-backends 'company-restclient)
)

(use-package rjsx-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
)

(use-package prettier-js
  :ensure t
  :config
  (add-hook 'js2-mode-hook 'prettier-js-mode)
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (add-hook 'rjsx-mode-hook 'prettier-js-mode)
  )

(use-package add-node-modules-path
  :ensure t
  :config
  (add-hook 'js-mode-hook 'add-node-modules-path)
  (add-hook 'js2-mode-hook 'add-node-modules-path)
  (add-hook 'web-mode-hook 'add-node-modules-path)
  (add-hook 'rjsx-mode-hook 'add-node-modules-path)
  )

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(use-package tide
  :ensure t
  :config
  (setq company-tooltip-align-annotations t)
  (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode)
)

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  ;; config later
)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
              (sequence "WAITING(w@/!)" "PHONE" "MEETING"))))

(setq org-directory "~/Dropbox/org/")
(setq org-default-notes-file (concat org-directory "refile.org"))
(setq org-agenda-files (list "~/Dropbox/org"))
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

(define-key global-map "\C-cc" 'org-capture)
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-agenda-custom-commands
 '(("D" "Daily Action List"
      (
           (agenda "" ((org-agenda-ndays 1)
                       (org-agenda-sorting-strategy
                        (quote ((agenda time-up priority-down tag-up) )))
                       (org-deadline-warning-days 0)
                       ))))))

(global-set-key (kbd "<f12>") 'org-agenda)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "78c1c89192e172436dbf892bd90562bc89e2cc3811b5f9506226e735a953a9c6" "2a998a3b66a0a6068bcb8b53cd3b519d230dd1527b07232e54c8b9d84061d48d" "cdfc5c44f19211cfff5994221078d7d5549eeb9feda4f595a2fd8ca40467776c" default)))
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (add-node-modules-path restclient rjsx-mode fzf matlab-mode json-mode mode-icons neotree spaceline-all-the-icons dockerfile-mode salt-mode org-notebook latex-preview-pane auctex nginx-mode elixir-mode cask-mode buttercup rainbow-mode ztree zop-to-char zenburn-theme yasnippet yaml-mode which-key use-package super-save smex rainbow-delimiters pt projectile paredit noflet multiple-cursors move-text markdown-mode magit inflections inf-ruby inf-clojure imenu-anywhere ido-ubiquitous hydra flycheck flx-ido expand-region exec-path-from-shell evil erlang elisp-slime-nav edn easy-kill crux company cider avy anzu aggressive-indent ag)))
 '(safe-local-variable-values
   (quote
    ((checkdoc-package-keywords-flag)
     (eval when
           (require
            (quote rainbow-mode)
            nil t)
           (rainbow-mode 1))
     (bug-reference-bug-regexp . "#\\(?2:[[:digit:]]+\\)"))))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Liberation Mono" :foundry "1ASC" :slant normal :weight normal :height 113 :width normal)))))

;;; init.el ends here
