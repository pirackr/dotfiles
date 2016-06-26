;;; package --- summary
;;; Commentary:
;;; Code:
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)
;;
;; Standard key bindings
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; The following setting is different from the document so that you
;; can override the document org-agenda-files by setting your
;; org-agenda-files in the variable org-user-agenda-files
;;
(if (boundp 'org-user-agenda-files)
    (setq org-agenda-files org-user-agenda-files)
  (setq org-agenda-files (quote ("~/Working/personal/todo"))))

;; Custom Key Bindings
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
              (sequence "WAITING(w@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-use-fast-todo-selection t)

(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-state-tags-triggers
      (quote (("WAITING" ("WAITING" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING"))
              ("NEXT" ("WAITING"))
              ("DONE" ("WAITING")))))

(setq org-directory "~/Working/personal/todo")
(setq org-default-notes-file "~/Working/personal/todo/refile.org")


;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/Working/personal/todo/refile.org")
               "* TODO %?\n%U\n%a\n")
              ("n" "next" entry (file "~/Working/personal/todo/refile.org")
               "* NEXT %?\n%U\n%a\n")
              ("m" "Meeting" entry (file "~/Working/personal/todo/refile.org")
               "* MEETING with %? :MEETING:\n%U")
              ("p" "Phone call" entry (file "~/Working/personal/todo/refile.org")
               "* PHONE %? :PHONE:\n%U"))))

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path 'file)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)

;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

(custom-set-variables
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-deadline-warning-days 7)
 '(org-agenda-skip-scheduled-if-deadline-is-shown t)
)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
	      ("T" "Today"
	       ((agenda ""
			((org-agenda-span 'day)
			 (org-deadline-warning-days 7)
			 (org-agenda-time-grid nil)))))
              ("M" "All"
	       ((tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels t)))
		(todo "NEXT"
		      ((org-agenda-overriding-header "Next tasks")
		       (org-tags-match-list-sublevels t)))
		(todo "TODO"
		      ((org-agenda-overriding-header "Tasks")
		       (org-tags-match-list-sublevels t)))
		(todo "WAITING"
		      ((org-agenda-overriding-header "Waiting and postponed tasks")
		       (org-tags-match-list-sublevels t))))
	       nil))))
