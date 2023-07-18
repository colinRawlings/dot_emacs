(require 'package)
(add-to-list
 'package-archives '("melpa" . "https://melpa.org/packages/")
 t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(setq inhibit-splash-screen t) ; hide welcome screen


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-ask-about-save nil)
 '(compilation-read-command nil)
 '(compilation-scroll-output 'first-error)
 '(compile-command
   "cd /media/rawlings/ldev/ldev/Simphony-build/ && cmake --build . -j")
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes '(wombat))
 '(dap-python-debugger 'debugpy)
 '(dap-python-executable
   "/media/rawlings/ldev/ldev/Simphony-build/_bin/Python/.venv/bin/python3")
 '(imenu-max-item-length 600)
 '(imenu-max-items 100)
 '(lsp-clangd-binary-path "/usr/bin/clangd-12")
 '(lsp-clients-clangd-args
   '("--compile-commands-dir=/media/rawlings/ldev/ldev/Simphony-build/" "--header-insertion-decorators=0"))
 '(lsp-treemacs-detailed-outline nil)
 '(magit-diff-hide-trailing-cr-characters t)
 '(mouse-wheel-scroll-amount '(5 ((shift) . hscroll) ((meta)) ((control) . text-scale)))
 '(package-selected-packages
   '(cmake-mode dockerfile-mode yaml-mode treemacs-projectile lsp-ivy elisp-autofmt run-command yascroll git-gutter ivy tree-sitter-langs tree-sitter ag ripgrep buffer-move centaur-tabs drag-stuff multi-term tab-bar-buffers rainbow-delimiters dap-mode which-key flycheck projectile helm-lsp yasnippet lsp-treemacs treemacs-magit treemacs-icons-dired treemacs magit company lsp-pyright use-package lsp-mode))
 '(run-command-recipes '(declare-run-command-recipes))
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face :foreground "magenta"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face :foreground "brightblue"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face :foreground "brightyellow"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face :foreground "brightgreen"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face :foreground "color-202")))))

(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

(use-package
 lsp-pyright
 :ensure t
 :hook
 (python-mode
  .
  (lambda ()
    (require 'lsp-pyright)
    (lsp)))) ; or lsp-deferred


(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'recentf-mode)

(use-package
 treemacs-icons-dired
 :hook (dired-mode . treemacs-icons-dired-enable-once)
 :ensure t)

(use-package treemacs-magit :after (treemacs magit) :ensure t)

(use-package
 centaur-tabs
 :demand
 :config (centaur-tabs-mode t)
 :bind
 ("C-<prior>" . centaur-tabs-backward)
 ("C-<next>" . centaur-tabs-forward))

(add-hook 'after-init-hook 'ivy-mode)

(add-hook 'after-init-hook 'which-key-mode)
(add-hook 'after-init-hook (lambda () (yascroll-bar-mode 1)))

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'yas-minor-mode-on)
(add-hook 'c++-mode-hook (lambda ()
			   (yas-minor-mode-on)

			   (define-key yas-minor-mode-map [(tab)] nil)
			   (define-key yas-minor-mode-map (kbd "TAB") nil)

			   ))

(setq
 gc-cons-threshold (* 100 1024 1024)
 read-process-output-max (* 1024 1024)
 treemacs-space-between-root-nodes nil
 company-idle-delay 0.0
 company-minimum-prefix-length 1
 lsp-idle-delay 0.1) ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools))

(with-eval-after-load 'lsp-mode
  (define-key lsp-mode-map (kbd "<mouse-3>") nil))

(add-hook 'treemacs-mode-hook (lambda () (treemacs-follow-mode -1)))

;; ide start

(add-hook 'after-init-hook 'projectile-mode)
(add-hook 'after-init-hook 'treemacs)
(add-hook 'after-init-hook (lambda () (global-superword-mode 1)))


(drag-stuff-global-mode 1)
(electric-pair-mode 1)
(drag-stuff-define-keys)
(global-auto-revert-mode 1) ;; to play nice with pre-commit-on-save

(add-hook 'python-mode-hook 'rainbow-delimiters-mode-enable)
(add-hook 'python-mode-hook (lambda () (global-git-gutter+-mode 1)))

(add-hook 'c++-mode-hook 'rainbow-delimiters-mode-enable)
(add-hook 'c++-mode-hook (lambda () (global-git-gutter+-mode 1)))

(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode-enable)
(add-hook 'emacs-lisp-mode-hook 'elisp-autofmt-mode)
(add-hook 'js-mode-hook 'rainbow-delimiters-mode-enable)

;; -- line numbers
(require 'display-line-numbers)

(defcustom display-line-numbers-exempt-modes
  '(vterm-mode
    eshell-mode shell-mode term-mode ansi-term-mode treemacs-mode)
  "Major modes on which to disable line numbers."
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "Turn on line numbers except for certain major modes.
Exempt major modes are defined in `display-line-numbers-exempt-modes'."
  (unless (or (minibufferp)
              (member major-mode display-line-numbers-exempt-modes))
    (display-line-numbers-mode)))

(global-display-line-numbers-mode)

;; fun with terminals

(defun new-terminal ()
  (interactive)
  (require 'multi-term)
  (command-execute 'multi-term)
  (setq-default truncate-lines nil)
  (if (not (boundp 'term-number))
      (defvar term-number 1
        "term index in the current emacs session"))
  (rename-buffer (concat "Term " (int-to-string term-number)))
  (setq term-number (+ 1 term-number)))

(defun run-precommit ()
  "Run the pre-commit script."
  (shell-command-to-string
   (format
    "python3 /media/rawlings/ldev/ldev/run_precommit.py --workspace-folder /media/rawlings/ldev/ldev --file %s"
    buffer-file-name)))

(add-hook 'after-save-hook #'run-precommit)

(unless (display-graphic-p)
  (xterm-mouse-mode 1))

(if (display-graphic-p)
  (tooltip-mode 0))

;; cut/copy line

(defun quick-copy-line ()
  "Copy the whole line that point is on and move to the beginning of the next line.
    Consecutive calls to this command append each line to the
    kill-ring."
  (interactive)
  (let ((beg (line-beginning-position 1))
        (end (line-beginning-position 2)))
    (if (eq last-command 'quick-copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-new (buffer-substring beg end))))
  (beginning-of-line 2))

(defun quick-cut-line ()
  "Cut the whole line that point is on.  Consecutive calls to this command append each line to the kill-ring."
  (interactive)
  (let ((beg (line-beginning-position 1))
	(end (line-beginning-position 2)))
    (if (eq last-command 'quick-cut-line)
	(kill-append (buffer-substring beg end) (< end beg))
      (kill-new (buffer-substring beg end)))
    (delete-region beg end))
  (beginning-of-line 1)
  (setq this-command 'quick-cut-line))

;; Tasks

(defun save-and-run-command ()
  (interactive)
  (projectile-save-project-buffers)
  (require 'multi-term)
  (run-command))

(defun declare-run-command-recipes ()
  (let ((buffer-file buffer-file-name)
        (word (thing-at-point 'word 'no-properties)))
    (list
     (let ((pytest-command
            (concat
             buffer-file
             (if word
                 "::")
             word
             (if (not word)
                 " -vv --forked -n5")
             " -s --log-cli-level=INFO")))
       (list
        :command-name (concat "pytest " pytest-command)
        :command-line (concat "clear && pytest " pytest-command)))
     (list
      :command-name "pyright: s4l-core"
      :command-line "clear && cd /media/rawlings/ldev/ldev/osparc-s4l/s4l-core/ && make tests-pyright")
     (list
      :command-name (concat "python: " buffer-file)
      :command-line (concat "clear && python " buffer-file))
     (list
      :command-name "configure simphony"
      :command-line "clear && cmake -S /media/rawlings/ldev/ldev/Simphony/Simphony --preset ninja")
     (list
      :command-name "build simphony"
      :command-line "clear && cd /media/rawlings/ldev/ldev/Simphony-build && cmake --build . -j")
     (list
      :command-name "start frontend"
      :command-line "clear && cd /media/rawlings/ldev/ldev/osparc-s4l/rt-web && npm start")
     (list
      :command-name "(re)start backend (full)"
      :command-line "clear && cd /media/rawlings/ldev/ldev/osparc-s4l/s4l-core && make kill ; s4l-core")
     (list
      :command-name "restart main-app"
      :command-line "clear && curl localhost:8081/restart_app")
     (list
      :command-name "start sym-server"
      :command-line "clear &&  cd /media/rawlings/ldev/ldev/osparc-s4l/sym-server && make up-dev")
     (list
      :command-name "s4l-core unit: "
      :command-line "clear && cd /media/rawlings/ldev/ldev/osparc-s4l/s4l-core/ && make tests-unit"))))



;; keys

(global-set-key [f12] 'lsp-find-definition)
(global-set-key (kbd "S-<f6>") 'lsp-rename)

(global-set-key (kbd "C-p") 'projectile-find-file-in-known-projects)
(global-set-key (kbd "C-S-b") 'compile)
(global-set-key (kbd "M-f") 'projectile-ripgrep)
(global-set-key (kbd "C-t") 'new-terminal)
(global-set-key (kbd "M-o") 'ff-find-other-file-other-window)
(global-set-key (kbd "C-/") 'comment-line)
(global-set-key (kbd "C-_") 'comment-line)
(global-set-key (kbd "C-b") 'dap-breakpoint-toggle)
(global-set-key (kbd "C-]") 'treemacs-find-file)
(global-set-key (kbd "C-j") 'ace-window)
(global-set-key (kbd "M-t") 'save-and-run-command)
(global-set-key (kbd "C-r") 'query-replace)
(global-set-key
 (kbd "<left-margin> <mouse-3>")
 'git-gutter+-show-hunk-inline-at-point)
(global-set-key
 (kbd "<left-margin> C-<mouse-3>") 'git-gutter+-revert-hunk)
(global-set-key (kbd "C-l") 'goto-line)

(global-set-key (kbd "M-c") 'quick-copy-line)
(global-set-key (kbd "C-w") 'quick-cut-line)

;; Debug

(use-package
 dap-mode
 :after lsp-mode
 :commands dap-debug
 :hook ((python-mode . dap-ui-mode) (python-mode . dap-mode))
 :config
 (eval-when-compile
   (require 'cl))
 (require 'dap-python) (require 'dap-lldb))

;; Nice highlighting

;; Tree-sitter highlight
;; Base framework, syntax highlighting.
(use-package
 tree-sitter
 :diminish (tree-sitter-mode)
 :hook
 ((after-init . global-tree-sitter-mode)
  (tree-sitter-after-on . tree-sitter-hl-mode)))

;; Language bundle.
(use-package tree-sitter-langs :demand t :after tree-sitter)


(add-hook
 'dap-ui-mode-hook
 (lambda ()

   (unless (display-graphic-p)
     (set-face-background 'dap-ui-marker-face "color-166") ; An orange background for the line to execute
     (set-face-attribute 'dap-ui-marker-face nil :inherit nil) ; Do not inherit other styles
     (set-face-background 'dap-ui-pending-breakpoint-face "blue") ; Blue background for breakpoints line
     (set-face-attribute 'dap-ui-verified-breakpoint-face nil
                         :inherit 'dap-ui-pending-breakpoint-face))))

(global-unset-key (kbd "C-y"))
(global-set-key (kbd "C-y") 'dap-ui-repl)

(global-set-key (kbd "C-<f5>") 'dap-debug-last)
(global-set-key (kbd "C-<f9>") 'dap-continue)
(global-set-key (kbd "C-<f10>") 'dap-next)
(global-set-key (kbd "C-<f11>") 'dap-step-in)
(global-set-key (kbd "C-S-<f11>") 'dap-step-out)
