   ;;; -*- lexical-binding: t -*-

(defun tangle-init ()
  "If the current buffer is 'init.org' the code-blocks are
   tangled, and the tangled file is compiled."
  (when (equal (buffer-file-name)
               (expand-file-name (concat user-emacs-directory "init.org")))
    ;; Avoid running hooks when tangling.
    (let ((prog-mode-hook nil))
      (org-babel-tangle)
      (byte-compile-file (concat user-emacs-directory "init.el")))))

(add-hook 'after-save-hook 'tangle-init)

(defun org-mode-export-links ()
  "Export links document to HTML automatically when 'links.org' is changed"
  (when (equal (buffer-file-name) "/Users/rakhim/org/links.org")
    (progn
      (org-html-export-to-html)
      (message "HTML exported"))))

(add-hook 'after-save-hook 'org-mode-export-links)

;; (set-frame-font "Inconsolata LGC 12")
(set-frame-font "IBM Plex Mono 12")
(load-theme 'tsdh-light)
(setq initial-frame-alist '((width . 202) (height . 47)))
(tool-bar-mode -1)

(setq show-paren-delay 0)
(show-paren-mode 1)

(global-visual-line-mode 1)

(global-display-line-numbers-mode 1)

(column-number-mode 1)

(setq-default frame-title-format "%b (%f)")

(setq-default indent-tabs-mode nil)

(setq auto-save-default nil)
(setq make-backup-files nil)

(fset 'yes-or-no-p 'y-or-n-p)

(setq
 inhibit-startup-message t
 inhibit-startup-screen t
 echo-keystrokes 0.1
 initial-scratch-message nil
 initial-major-mode 'org-mode
 sentence-end-double-space nil
 confirm-kill-emacs 'y-or-n-p)

(visual-line-mode 1)
(scroll-bar-mode -1)
(delete-selection-mode 1)
(global-unset-key (kbd "s-p"))
(global-hl-line-mode 1)

(setq scroll-margin 10
      scroll-step 1
      next-line-add-newlines nil
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(setq mouse-wheel-follow-mouse 't)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package try
  :ensure t)

(use-package nyan-mode
  :ensure t
  :commands nyan-mode
  :config
  (nyan-mode))

;; (require 'exec-path-from-shell)
(use-package exec-path-from-shell
  :ensure t
  ;; :commands exec-path-from-shell-initialize
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; (require 'expand-region)
(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "s-9") 'er/expand-region)
  (global-set-key (kbd "s-(") 'er/contract-region)
  )

;; (require 'helm)
(use-package helm
  :ensure t
  :config
  (require 'helm-config)
  (helm-mode 1)
  (helm-autoresize-mode 1)
  (setq helm-follow-mode-persistent t)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (setq helm-M-x-fuzzy-match t)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "s-b") 'helm-mini)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "s-f") 'helm-occur))

;; (require 'projectile)
(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (projectile-mode +1)
  )

;; (require 'helm-projectile)
(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

;; (require 'helm-ag)
(use-package helm-ag
  :ensure t
  :config
  (global-set-key (kbd "s-F") 'helm-projectile-ag))

;; (require 'simpleclip)
(use-package simpleclip
  :ensure t
  :commands
  (simpleclip-mode)
  :config
  (simpleclip-mode 1))

;; (require 'magit)
(use-package magit
  :ensure t
  :config
  (global-set-key (kbd "s-m") 'magit-status))

;; (require 'git-gutter)
(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode +1)
  (custom-set-variables
   '(git-gutter:modified-sign " ") ;; two space
   '(git-gutter:added-sign "+")    ;; multiple character is OK
   '(git-gutter:deleted-sign "-"))

  (set-face-background 'git-gutter:modified "purple") ;; background color
  (set-face-foreground 'git-gutter:added "green")
  (set-face-foreground 'git-gutter:deleted "red")
  )

;; (require 'beacon)
;; (use-package beacon
;;   :ensure t
;;   :config
;;   (beacon-mode 1))

;; (require 'which-key)
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.6))

(setq ispell-program-name "aspell")

;; (require 'company)
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)

  (setq
   company-echo-truncate-lines nil
   company-dabbrev-downcase nil
   company-selection-wrap-around t
   company-transformers '(company-sort-by-occurrence
                          company-sort-by-backend-importance))

  (global-set-key (kbd "H-c") 'company-complete-common))

(use-package helm-company
  :ensure t)

;; (require 'flycheck)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enable)))

;; (require 'terraform-mode)
(use-package terraform-mode
  :ensure t)

;; (require 'alchemist)
(use-package alchemist
  :ensure t)

;; (require 'elixir-mode)
(use-package elixir-mode
  :ensure t
)

;; (require 'xah-math-input)
(use-package xah-math-input
  :ensure t
  :config
  (global-xah-math-input-mode 0) ; turn on globally
)

(use-package yaml-mode
  :ensure t)

;; (require 'tide)
(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save))
  :config
  (setq typescript-indent-level
        (or (plist-get (tide-tsfmt-options) ':indentSize) 2)))

;; (require 'eglot)
;; (use-package eglot
;;   :ensure t
;;   ;; :hook (
;;   ;;        (typescript-mode . eglot-ensure)
;;   ;;        )
;;   :config
;;   (add-to-list 'eglot-server-programs '(typescript-mode . ("typescript-language-server --stdio")))
;;   (add-hook 'typescript-mode-hook 'eglot-ensure)
;; )

;; (require 'format-all)
(use-package format-all
  :ensure t
  :config
  (global-set-key (kbd "H-f") 'format-all-buffer)
  )

;; (dolist (mode
;;       '(
;;         ;; abbrev-mode                  ; E.g. sopl -> System.out.println
;;         ;; column-number-mode           ; Show column number in mode line
;;         ;; delete-selection-mode        ; Replace selected text
;;         ;; dirtrack-mode                ; directory tracking in *shell*
;;         ;; drag-stuff-global-mode       ; Drag stuff around
;;         ;; global-company-mode          ; Auto-completion everywhere
;;         ;; global-git-gutter-mode       ; Show changes latest commit
;;         global-prettify-symbols-mode ; Greek letters should look greek
;;         ;; projectile-global-mode       ; Manage and navigate projects
;;         recentf-mode                 ; Recently opened files
;;         show-paren-mode              ; Highlight matching parentheses
;;         which-key-mode))             ; Available keybindings in popup
;;   (funcall mode 1))
(recentf-mode 1)  ; Recently opened files

(global-auto-revert-mode 1) ;; auto revert mode

(add-hook 'dired-mode-hook 'auto-revert-mode) ;; auto refresh dired when file changes

(defun xah-select-line ()
  "Select current line. If region is active, extend selection downward by line.
     URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
     Version 2017-11-01"
  (interactive)
  (if (region-active-p)
      (progn
        (forward-line 1)
        (end-of-line))
    (progn
      (end-of-line)
      (set-mark (line-beginning-position)))))

(defun xah-select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
    Delimiters here includes the following chars: \"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）
    This command select between any bracket chars, not the inner text of a bracket. For example, if text is

     (a(b)c▮)

     the selected char is “c”, not “a(b)c”.

    URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
    Version 2016-12-18"
  (interactive)
  (let (
        ($skipChars
         (if (boundp 'xah-brackets)
             (concat "^\"" xah-brackets)
           "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）"))
        $pos
        )
    (skip-chars-backward $skipChars)
    (setq $pos (point))
    (skip-chars-forward $skipChars)
    (set-mark $pos)))

(defun xah-select-block ()
  "Select the current/next block of text between blank lines.
    If region is active, extend selection downward by block.

    URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
    Version 2017-11-01"
  (interactive)
  (if (region-active-p)
      (re-search-forward "\n[ \t]*\n" nil "move")
    (progn
      (skip-chars-forward " \n\t")
      (when (re-search-backward "\n[ \t]*\n" nil "move")
        (re-search-forward "\n[ \t]*\n"))
      (push-mark (point) t t)
      (re-search-forward "\n[ \t]*\n" nil "move"))))

(global-set-key (kbd "s-6") 'xah-select-block)
(global-set-key (kbd "s-7") 'xah-select-line)
(global-set-key (kbd "s-8") 'xah-select-text-in-quote)

(defun xah-beginning-of-line-or-block ()
  "Move cursor to beginning of line or previous paragraph.

   • When called first time, move cursor to beginning of char in current line. (if already, move to beginning of line.)
   • When called again, move cursor backward by jumping over any sequence of whitespaces containing 2 blank lines.

   URL `http://ergoemacs.org/emacs/emacs_keybinding_design_beginning-of-line-or-block.html'
   Version 2017-05-13"
  (interactive)
  (let (($p (point)))
    (if (or (equal (point) (line-beginning-position))
            (equal last-command this-command ))
        (if (re-search-backward "\n[\t\n ]*\n+" nil "NOERROR")
            (progn
              (skip-chars-backward "\n\t ")
              (forward-char ))
          (goto-char (point-min)))
      (progn
        (back-to-indentation)
        (when (eq $p (point))
          (beginning-of-line))))))

(defun xah-end-of-line-or-block ()
  "Move cursor to end of line or next paragraph.

• When called first time, move cursor to end of line.
• When called again, move cursor forward by jumping over any sequence of whitespaces containing 2 blank lines.

URL `http://ergoemacs.org/emacs/emacs_keybinding_design_beginning-of-line-or-block.html'
Version 2017-05-30"
  (interactive)
  (if (or (equal (point) (line-end-position))
          (equal last-command this-command ))
      (progn
        (re-search-forward "\n[\t\n ]*\n+" nil "NOERROR" ))
    (end-of-line)))

(global-set-key (kbd "C-a") 'xah-beginning-of-line-or-block)
(global-set-key (kbd "C-e") 'xah-end-of-line-or-block)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

(setq auto-window-vscroll nil)

(setq ns-function-modifier 'hyper)
(global-set-key (kbd "H-g") (kbd "C-g"))

(global-set-key (kbd "s-<backspace>") 'kill-whole-line)

;; (global-set-key (kbd "s-<right>") (kbd "C-e"))
(global-set-key (kbd "s-<right>") 'xah-end-of-line-or-block)
(global-set-key (kbd "s-<left>") 'xah-beginning-of-line-or-block)
(global-set-key (kbd "s-<up>") (kbd "M-v"))
(global-set-key (kbd "s-<down>") (kbd "C-v"))

(global-set-key (kbd "H-.") (kbd "C-M-f"))
(global-set-key (kbd "H-,") (kbd "C-M-b"))

(global-set-key (kbd "s-o") (kbd "C-x o"))
(global-set-key (kbd "s-1") (kbd "C-x 1"))
(global-set-key (kbd "s-2") (kbd "C-x 2"))
(global-set-key (kbd "s-3") (kbd "C-x 3"))
(global-set-key (kbd "s-3") (kbd "C-x 3"))
(global-set-key (kbd "s-0") (kbd "C-x 0"))
(global-set-key (kbd "s-w") (kbd "C-x 0"))
(global-set-key (kbd "s-t") (kbd "C-x 3"))

(defun smart-open-line ()
  "Insert an empty line after the current line. Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun smart-open-line-above ()
  "Insert an empty line above the current line. Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

;; (global-set-key (kbd "s-<return>") 'smart-open-line)
;; (global-set-key (kbd "s-S-<return>") 'smart-open-line-above)
;; (global-unset-key (kbd "s-<return>"))
;; (global-unset-key (kbd "s-S-<return>"))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline t)

(electric-pair-mode 1)
(setq electric-pair-pairs '(
                            (?\" . ?\")
                            (?\{ . ?\})
                            ) )

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines) ; When you have an active region that spans multiple lines, the following will add a cursor to each line
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  )

(setq org-directory "~/Dropbox/org/")

(setq org-agenda-files '("~/Dropbox/org/"))

(setq org-support-shift-select t)

(eval-after-load 'org
  '(progn
     (add-to-list 'org-structure-template-alist
                  '("el" "#+BEGIN_SRC emacs-lisp \n?\n#+END_SRC")
                  '("ts" "#+BEGIN_SRC typescript \n?\n#+END_SRC"))
     (define-key org-mode-map (kbd "C-'") nil)
     (global-set-key "\C-ca" 'org-agenda)
     (global-set-key "\C-c l" 'org-agenda)
     ))

;; (org-indent-mode 1)

(setq org-edit-src-content-indentation 0)
(setq org-src-tab-acts-natively t)
(setq org-src-preserve-indentation t)

(setq org-src-fontify-natively t)

(custom-set-variables
 '(org-export-backends (quote (ascii html icalendar latex md odt))))

(find-file "~/Dropbox/org/main.org")

(setq org-log-into-drawer t)

(global-set-key (kbd "\e\em") (lambda () (interactive) (find-file "~/Dropbox/org/main.org")))
(global-set-key (kbd "\e\ec") (lambda () (interactive) (find-file "~/.emacs.d/init.org")))
(global-set-key (kbd "\e\el") (lambda () (interactive) (find-file "~/Dropbox/org/links.org")))

(setq org-cycle-separator-lines 1)

;; (require 'org-bullets)
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
