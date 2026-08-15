(defmacro comment (&rest args) nil)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(load-theme 'tsdh-dark)
(set-face-attribute 'default nil :height 150)
(global-display-line-numbers-mode)
(savehist-mode)

(setopt display-fill-column-indicator-column 100)
(global-display-fill-column-indicator-mode)

(setq user-mail-address "arturangiel@gmail.com")

(setq global-auto-revert-mode 1)

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(defvar my-packages '(slime rainbow-delimiters magit cider lsp-mode company))

(dolist (package my-packages)
  (unless (package-installed-p package)
    (package-install package)))

(require 'slime)
(slime-setup '(slime-fancy slime-quicklisp slime-asdf slime-mrepl slime-autodoc))
(setq inferior-lisp-program "sbcl --noinform --core ~/.emacs.d/sbcl.core-for-slime --dynamic-space-size 2048")

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; (add-to-list 'load-path "~/common-lisp/slime-star")
;; (load-file "~/quicklisp/dists/quicklisp/software/slite-20250622-git/slite.el")

(setq slime-contribs '(slime-fancy
		       ;;slime-star
		       ))

(load "~/quicklisp/log4slime-setup.el")
(global-log4slime-mode 1)

(use-package lsp-mode
  :ensure t
  :hook ((clojure-mode . lsp)
         (clojurec-mode . lsp)
         (clojurescript-mode . lsp)
	 (clojuresdart-mode . lsp))
  :config
  ;; add paths to your local installation of project mgmt tools, like lein
  (setenv "PATH" (concat
                   "/usr/local/bin" path-separator
                   (getenv "PATH")))
  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode
	       clojuredart-mode))
     (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))
  ;;(setq lsp-clojure-server-command '("/path/to/clojure-lsp"))
  ) ;; Optional: In case `clojure-lsp` is not in your $PATH

;;(customize-set-variable 'jdecomp-decompiler-paths
;;                        '((cfr . "~/Downloads/cfr-0.152.jar")
;;                          (fernflower . "~/idea-IC-162.1628.40/plugins/java-decompiler/lib/java-decompiler.jar")
;;                          (procyon . "~/procyon-decompiler-0.5.30.jar")))
;;(jdecomp-mode 1)
;;
;;(require 'package)
;;(setq package-archives
;;	  '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
;;		("MELPA"        . "https://melpa.org/packages/")
;;		("ORG"          . "https://orgmode.org/elpa/")
;;		("MELPA Stable" . "https://stable.melpa.org/packages/")
;;		("nongnu"       . "https://elpa.nongnu.org/nongnu/"))
;;	  package-archive-priorities
;;	  '(("GNU ELPA"     . 20)
;;		("MELPA"        . 15)
;;		("ORG"          . 10)
;;		("MELPA Stable" . 5)
;;		("nongnu"       . 0)))
;;
;;(package-initialize)
;;
;;(unless package-archive-contents
;;  (package-refresh-contents))
;;
;;(unless (package-installed-p 'use-package)
;;  (package-install 'use-package))
;;
;;(require 'use-package)
;;
;;(use-package magit slime rainbow-delimiters paredit)
;;(custom-set-variables
;; ;; custom-set-variables was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(package-selected-packages '(company dired-subtree jdecomp lsp-mode magit slime rainbow-delimiters paredit)))
;;(custom-set-faces
;; ;; custom-set-faces was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; )
;;
;;(setq inferior-lisp-program "/opt/homebrew/bin/sbcl")
;;
;;(define-key dired-mode-map "i" 'dired-subtree-insert)
;;(define-key dired-mode-map ";" 'dired-subtree-remove)
;;
;;(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;;(add-hook 'lisp-mode-hook #'paredit-mode)
;;
;;(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;; '(package-selected-packages nil))
;;(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;;
;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(package-selected-packages
;;   '(cider cl-libify company dired-subtree jdecomp lsp-mode magit paredit
;;	   rainbow-delimiters slime)))
;; (custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ns-alternate-modifier 'super)
 '(ns-command-modifier 'meta)
 '(package-selected-packages
   '(cider cl-libify company dired-subtree jdecomp lsp-mode magit paredit
	   rainbow-delimiters slime)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
