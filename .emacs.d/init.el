(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'package)
;; (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
;; 			 ("melpa" . "http://elpa.emacs-china.org/melpa/")))
(add-to-list 'package-archives '("melpa" ."http://melpa.org/packages/"))

;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(bazel helm gnu-elpa-keyring-update lsp-ui helm-lsp lsp-mode yaml-mode dockerfile-mode ivy irony-eldoc flycheck-irony company-irony company google-c-style exec-path-from-shell clang-format irony cmake-mode zenburn-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Set startup window size
(when (or window-system (daemonp))
  (setq default-frame-alist '(
                              (width . 150)
                              (height . 800)
			      ))
  )

;; Remove undeeded ui components
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(if (display-graphic-p)
    (progn
      (toggle-scroll-bar -1)))
(tool-bar-mode -1)

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

;; shortcut for replace-string
(global-set-key (kbd "C-c r") 'replace-string)

;; shortcut for comment-line
;; originally "C-c C-;" is mapped to comment-line, but we want to avoid using
;; C-; since this key combination can't be sent on most terminal emulators
(global-set-key (kbd "C-c v") 'comment-line)

;; shortcut for compile
(global-set-key (kbd "C-c c") 'compile)

;; Set up clang-format
(require 'clang-format)
(global-set-key (kbd "C-c i") 'clang-format-region)
(global-set-key (kbd "C-c u") 'clang-format-buffer)

;; Ivy Mode
(ivy-mode 1)

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

;; C-mode - Google C Style
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;; C-mode -lsp
(add-hook 'c-mode-common-hook 'lsp)

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

;; Company mode
(add-hook 'after-init-hook 'global-company-mode)

;; Flycheck mode
(add-hook 'after-init-hook #'global-flycheck-mode)

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

;; CMake-mode
(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
                ("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))
(setq cmake-tab-width 4)

;; Dockerfile mode
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))

;; Store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq require-final-newline nil)

;; llvm-mode
(require 'llvm-mode)

;; tablegen-mode
(require 'tablegen-mode)

;; MLIR-mode
(require 'mlir-mode)

;; bazel-mode
;; (require 'bazel-build-mode)
;; (require 'bazel-workspace-mode)
(setq auto-mode-alist
      (append '(("\.BUILD$"  . bazel-build-mode)
		("^BUILD$" . bazel-build-mode)
		("^WORKSPACE$" . bazel-workspace-mode))
	      auto-mode-alist))
