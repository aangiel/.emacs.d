;;; -*-  no-byte-compile: t; lexical-binding: t -*-

(load "~/.emacs.d/sanemacs.el" nil t)

(defmacro comment (&rest _args) nil)

(when (eq 'darwin system-type)
  (setq ns-alternate-modifier 'meta)
  (setq ns-command-modifier 'meta)
  (setq ns-control-modifier 'super)
  (setq ns-option-modifier 'meta)
  (setq ns-right-alternate-modifier 'none)
  (setq ns-right-command-modifier 'super)
  (setq ns-right-control-modifier 'control)
  (setq ns-right-option-modifier 'none))

(setq source-directory (concat user-emacs-directory "src"))

(add-to-list 'default-frame-alist '(fullscreen . fullboth))
(load-theme 'deeper-blue)
(set-face-attribute 'default nil :height 150)
;;(global-display-line-numbers-mode)
(savehist-mode)

(fido-mode 1)

(setopt display-fill-column-indicator-column 100)
(global-display-fill-column-indicator-mode)

(setq user-mail-address "arturangiel@gmail.com")

(setq completion-styles '(hotfuzz))

(add-hook 'icomplete-minibuffer-setup-hook
          (lambda () (kill-local-variable 'completion-styles)))

;;(setq global-auto-revert-mode 1)

;;(require 'package)

;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(defvar my-packages
  '(slime rainbow-delimiters magit cider lsp-mode company  dired-collapse))

(dolist (package my-packages)
  (unless (package-installed-p package)
    (package-install package)))

(require 'slime)
(slime-setup '(slime-fancy slime-quicklisp slime-asdf slime-mrepl slime-autodoc))
(setq inferior-lisp-program (concat "sbcl --noinform --core "
				    (expand-file-name user-emacs-directory)
				    "sbcl.core-for-slime --dynamic-space-size 2048"))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)

(setq slime-contribs '(slime-fancy))

;;(with-eval-after-load "~/quicklisp/log4slime-setup.el"
;;  (when (fboundp global-log4slime-mode) (global-log4slime-mode 1)))

(defvar aa-parameters
  '(window-parameters . ((no-other-window . t)
                         (no-delete-other-windows . t))))

(setq fit-window-to-buffer-horizontally t)
(setq window-resize-pixelwise t)

(setq
 display-buffer-alist
 `(("\\*Buffer List\\*"
    display-buffer-in-side-window
    (side . bottom)
    (slot . 0)
    (window-height . fit-window-to-buffer)
    (preserve-size . (nil . t))
    ,aa-parameters)
   ("\\*Tags List\\*"
    display-buffer-in-side-window
    (side . right)
    (slot . 0)
    (window-width . fit-window-to-buffer)
    (preserve-size . (t . nil))
    ,aa-parameters)
   ("\\*\\(?:help\\|grep\\|Completions\\)\\*"
    display-buffer-in-side-window
    (side . bottom)
    (slot . -1)
    (preserve-size . (nil . t))
    ,aa-parameters)
   ("\\*\\(?:eshell\\|compilation\\)\\*"
    display-buffer-in-side-window
    (mode . eshell)
    (side . bottom)
    (slot . 1)
    (preserve-size . (nil . t))
    ,aa-parameters)))

(defun dired-default-directory-on-left (dir)
  "Display `default-directory' in side window on left, hiding details."
  (interactive "DDefault directory: ")
  (let ((buffer (dired-noselect (or dir default-directory))))
    (with-current-buffer buffer (dired-hide-details-mode t))
    (display-buffer-in-side-window
     buffer `((side . left) (slot . 0)
              (window-width . fit-window-to-buffer)
              (preserve-size . (t . nil)) ,aa-parameters))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(clojure-mode paredit rainbow-delimiters undo-tree)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(global-set-key (kbd "C-;") 'previous-window-any-frame)
(global-set-key (kbd "C-'") 'next-window-any-frame)


(setq-default cursor-type 'box)

(setq dired-listing-switches "-lahF -D%FT%R")

(use-package dired-subtree
  :ensure t
  :after dired
  :bind (:map dired-mode-map
              ("i" . dired-subtree-toggle)))

;;(global-dired-collapse-mode 1)

;;(add-to-list 'helm-commands-using-frame 'helm-M-x)

(use-package inhibit-mouse
  :custom
  ;; Disable highlighting of clickable text such as URLs and hyperlinks when
  ;; hovered by the mouse pointer.
  (inhibit-mouse-adjust-mouse-highlight t)

  ;; Disables the use of tooltips (show-help-function) during mouse events.
  (inhibit-mouse-adjust-show-help-function t)

  :init
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'inhibit-mouse-mode)
    (inhibit-mouse-mode 1)))

(fido-mode 1)
