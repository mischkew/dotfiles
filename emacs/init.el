(setq default-directory "~/")

(setq sm/agenda-files (list
	 "~/Documents/workspace/notes/work"
	 "~/Documents/workspace/notes/private"))

(setq sm/workspace-path "~/Documents/workspace")

;; install straight with straight and only bootstrap once
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; activate use-package integration
(straight-use-package 'use-package)

;; implictly always provide the :straight t keywords to use-package so that we don't have to
;; we will only explictly set :straight nil for system packages to avoid downloading them :)
(setq straight-use-package-by-default t)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(defun kill-this-buffer ()
  (interactive)
  (kill-buffer (buffer-name)))

(global-set-key (kbd "C-x C-k") 'kill-this-buffer)

(defun smarter-move-beginning-of-line ()
"Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line."
  (interactive)
  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

(use-package server
  :ensure nil
  :config
  (unless (server-running-p) (server-start)))

(use-package hydra)

(defun copy-to-clipboard ()
  "Executes a shell command which takes the current region as stdin
  and copies it to the OS-clipboard outside of the emacs kill-ring we
  use `pbcopy`. On my system this is an alias for xlip on linux"
  (interactive)
  (shell-command-on-region (point) (mark) "pbcopy"))

(global-set-key (kbd "C-c C-r") 'copy-to-clipboard)

(setq inhibit-startup-message t) ; don't show the emacs startup screen
(scroll-bar-mode -1) ; disable visible scrollbar
(tool-bar-mode -1) ; disable the top toolbar
(tooltip-mode -1) ; disable any tooltips
(set-fringe-mode 10) ; set some margin
(menu-bar-mode -1) ; disable the top menu bar
(column-number-mode) ; display the column number in the modeline
(global-display-line-numbers-mode t) ; always enable line numbers

;; Disable line numbers for some modes
(dolist (mode '(vterm-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                compilation-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-dracula t)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package all-the-icons) ; run M-x all-the-icons-install-fonts

(use-package which-key
  :diminish which-key-mode
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.1))

(use-package ivy
  :diminish
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))


(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . ivy-switch-buffer)
         ("C-x C-f" . counsel-find-file)
         ("C-s" . swiper-isearch)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy-rich
  :diminish
  :init (ivy-rich-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(defun sm/org-hooks ()
  (org-indent-mode)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . sm/org-hooks)
  :config
  (setq org-todo-keywords
	'((sequence "TODO" "NEXT" "|" "DONE")
	  (sequence "WAIT" "PLAN" "BACKLOG" "WIP" "HOLD" "|" "COMPLETED")))
  (setq org-agenda-files sm/agenda-files)

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  ;; configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<=1&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ("w" "Workflow Status"
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "WIP"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "HOLD"
            ((org-agenda-overriding-header "On Hold")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files))))))


  :bind
  ("C-c a" . 'org-agenda)
  ("C-a" . 'smarter-move-beginning-of-line))

(defun sm/org-babel-tangle-config ()
  (when (string-equal (file-truename (file-name-directory (buffer-file-name)))
                      (file-truename (expand-file-name user-emacs-directory)))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'sm/org-babel-tangle-config)))

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(defun sm/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode)
   (let ((lsp-keymap-prefix "C-c l"))
                  (lsp-enable-which-key-integration)))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  (lsp-mode . sm/lsp-mode-setup)
  (python-mode . lsp)
  :config
  (lsp-enable-which-key-integration t)
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

;;  (use-package lsp-ivy)

(use-package dap-mode
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (tooltip-mode 1)
  (dap-ui-controls-mode 1)
  :bind
  (:map lsp-mode-map
        ("C-c l d" . dap-hydra)))

(use-package c-mode
  :straight nil
  :after lsp-mode
  :hook (c-mode . lsp))

(use-package dap-lldb
  :straight nil
  :after dap-mode
  :hook
  (c-mode . (lambda () (require 'dap-lldb)))
  :config
  (setq dap-lldb-debug-program (list "lldb-vscode")))

(use-package lsp-python-ms
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp))))
(defun sm/clang-format ()
  (clang-format-buffer "llvm"))

(defun sm/clang-format-on-save ()
  (add-hook 'before-save-hook #'sm/clang-format nil 'local))

(use-package clang-format
  :demand t
  :init
  (add-hook 'c-mode-common-hook 'sm/clang-format-on-save))


(defun sm/set-pyenv ()
   "Set pyenv based on local .python-version file"
   (let ((version-file (concat (projectile-project-root)
                              (file-name-as-directory ".python-version"))))
     (if (file-exists-p version-file)
         (pyenv-mode-set (f-read-text version-file)))))

(use-package pyenv-mode
  :after projectile
  :init
  (setq pyenv-mode-mode-line-format '(:eval
    (when (pyenv-mode-version)
     (concat " (" (pyenv-mode-version) ") "))))
  :hook (projectile-after-switch-project . sm/set-pyenv)
  :config (pyenv-mode 1))

(use-package python-black
  :demand t
:hook (python-mode . (lambda () (python-black-on-save-mode 1)))
  :after python)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package yasnippet
  :config (yas-global-mode 1))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system  'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p sm/workspace-path)
    (setq projectile-project-search-path (list sm/workspace-path)))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :bind ("C-c C-g" . magit)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge)

(use-package vterm
  :bind ("C-M-t" . vterm)
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
  (setq vterm-max-scrollback 10000))

(use-package dired
  ;; don't install this package, it is shipped with emacs
  :straight nil
  :init (global-set-key (kbd "C-x C-d") nil)
  :bind (; global commands
         ("C-x C-j" . dired-jump)
         ; only within dired-mode
         :map dired-mode-map
         ("C-u" . dired-up-directory))
  ;; dired shows files by running `ls` in the background
  ;; we pass these options to:
  ;; - list all files (al)
  ;; - print a slash at the end of each directory (p)
  ;; - show human readable filesize in K, M, G etc (h)
  ;; ideally, we also want to show directories first with
  :custom (dired-listing-switches "-alph")
  ;; enable hide details minor mode by default in dired
  ;; this hides all meta information and ony displays filennames
  :hook (dired-mode . dired-hide-details-mode))

;; dired normally launches a new buffer for each folder opened
;; this clutters the buffer list, we only want to keep a single
;; dired buffer around
(use-package dired-single)

;; show icon thumbnails next to files
(use-package all-the-icons-dired
  ;; automatically activate this minor mode when in dired-mode
  :hook (dired-mode . all-the-icons-dired-mode))
