(add-to-list 'load-path "~/.emacs.d/lisp")

;; Load Customize config file
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; Auto-install missing packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t) ;; Ensure auto-install missing pacakges

(use-package zenburn-theme
  :config (load-theme 'zenburn t))

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)))

(use-package ivy
  :config (ivy-mode 1))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (c-mode-common . lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l"))

(use-package lsp-ui :commands lsp-ui-mode)

(use-package helm-lsp :commands helm-lsp-telemetry)

(use-package company
  :config (global-company-mode))

(use-package flycheck
  :config (global-flycheck-mode))

(use-package irony
  :hook ((c++-mode . irony-mode)
         (c-mode . irony-mode)))

(use-package google-c-style
  :ensure t
  :hook (c-mode-common . (lambda ()
                           (google-set-c-style)
                           (google-make-newline-indent))))

(use-package clang-format
  :ensure t
  :bind (:map c-mode-common-map
              ("C-c i" . clang-format-region)
              ("C-c u" . clang-format-buffer)))

(use-package magit)

(use-package bazel
  :mode (("\\.BUILD\\'" . bazel-build-mode)
         ("BUILD\\'" . bazel-build-mode)
         ("WORKSPACE\\'" . bazel-workspace-mode)))

(use-package cmake-mode
  :mode (("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode))
  :init
  (setq cmake-tab-width 4))

(use-package yaml-mode)

(use-package dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

(use-package gnu-elpa-keyring-update)

(use-package antlr-mode
  :mode ("\\.g4\\'" . antlr-mode))

;; llvm-mode
(require 'llvm-mode)

;; tablegen-mode
(require 'tablegen-mode)

;; MLIR-mode
(require 'mlir-mode)

;; Set startup window size
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (let (monitor-workarea)
  (progn
    ;; use 120 char wide window for largeish displays
    ;; and smaller 80 column windows for smaller displays
    ;; pick whatever numbers make sense for you
    (if (> (x-display-pixel-width) 1280)
        (add-to-list 'default-frame-alist (cons 'width 120))
        (add-to-list 'default-frame-alist (cons 'width 80)))
    ;; iterate over the monitor list to find which monitor
    ;; is used by the current frame and get its workarea
    (dolist (monitor (display-monitor-attributes-list) monitor-workarea)
      (if (cdr (assoc 'frames monitor))
	  (setq monitor-workarea (assoc 'workarea monitor))))
    ;; for the height, subtract a couple hundred pixels
    ;; from the screen height (for panels, menubars and
    ;; whatnot), then divide by the height of a char to
    ;; get the height we want
    (add-to-list 'default-frame-alist
		 (cons 'height (/ (- (nth 4 monitor-workarea) 400)
				  (frame-char-height))))
    (add-to-list 'default-frame-alist (cons 'top (+ (nth 2 monitor-workarea) 200)))
    (add-to-list 'default-frame-alist (cons 'left (+ (nth 1 monitor-workarea) 200))))))

;; There is no window-system during deamon startup, so add set-frame-size-according-to-resolution
;; to the after-make-frame-functions hook so it will be triggered when invoking "emacsclient -c".
;; Bug: The hook won't be triggered when creating the initial frame. (The official document
;; says that init.el gets evaluated AFTER inital frame creation, but because in deamon mode init.el
;; should have been evaluated during deamon startup, it still doesn't explain why the first frame
;; created by "emacsclient -c" fails to invoke this hook.)
(add-hook 'after-make-frame-functions
	  (lambda (frame)
	    (select-frame frame)
	    (set-frame-size-according-to-resolution)))

;; In GUI non-deamon Emacs, call this directly during init
(if window-system (set-frame-size-according-to-resolution))

;; Remove undeeded ui components
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(if (display-graphic-p)
    (progn
      (toggle-scroll-bar -1)))
(tool-bar-mode -1)

; Reduce the number of times the bell rings
; Turn off the bell for the listed functions.
(setq ring-bell-function
      (lambda ()
        (unless (memq this-command
                      '(isearch-abort
                        abort-recursive-edit
                        exit-minibuffer
                        keyboard-quit
                        previous-line
                        next-line
                        scroll-down
                        scroll-up
                        cua-scroll-down
                        cua-scroll-up))
          (ding))))

;; Use Command key as Meta on macos
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'none)

;; Match exec-path to shell path
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(when (daemonp)
  (exec-path-from-shell-initialize))

;; shortcut for using ctrl + scroll to zoom in/out
(global-set-key [C-mouse-4] 'text-scale-increase)
(global-set-key [C-mouse-5] 'text-scale-decrease)

;; shortcut for replace-string
(global-set-key (kbd "C-c r") 'replace-string)

;; shortcut for comment-line
;; originally "C-c C-;" is mapped to comment-line, but we want to avoid using
;; C-; since this key combination can't be sent on most terminal emulators
(global-set-key (kbd "C-c v") 'comment-line)

;; shortcut for compile
(global-set-key (kbd "C-c c") 'compile)

;; Org Mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-list-description-max-indent 5)
(setq org-adapt-indentation nil)
;; Inline image and disable hard-coded image size
(setq org-startup-with-inline-images t)
(setq org-image-actual-width nil)

;; C-mode - customized options
(defun my-c-mode-common-hook ()
  (c-set-offset 'substatement-open 0)
  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2
  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq indent-tabs-mode nil)  ; use spaces only if nil
  (setq-default display-fill-column-indicator-column 80)
  (display-fill-column-indicator-mode) ;; display a line at column 80
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; ;; C-mode - Irony
;; (add-hook 'c-mode-common-hook 'irony-mode)
;; (add-hook 'c-mode-common-hook 'irony-cdb-autosetup-compile-options)

;; ;; C-mode - Company Irony
;; (eval-after-load 'company
;;   '(add-to-list 'company-backends 'company-irony))

;; ;; C-mode - Flycheck Irony
;; (eval-after-load 'flycheck
;;   '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;; ;; C-mode - Eldoc Irony
;; (add-hook 'irony-mode-hook #'irony-eldoc)

;; C-mode - Recognize cuda src files
(add-to-list 'auto-mode-alist '("\.cu$" . c++-mode))

;; Theme
(load-theme 'zenburn t)

;; Display line numbers
(global-display-line-numbers-mode) ;; set this due to .cu not recognized as code
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Display column numbers
(setq column-number-mode t)

;; Highlight current line
(global-hl-line-mode)
;; (set-face-background hl-line-face "color-238")
(set-face-background hl-line-face "gray28")

;; Set face height to 120
(set-face-attribute 'default nil :height 120)

;; Store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq require-final-newline nil)
