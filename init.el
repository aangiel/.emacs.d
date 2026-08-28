;;; -*- lexical-binding: t -*-

(defmacro comment (&rest args) nil)

(when (eq 'darwin system-type)
  (setq ns-alternate-modifier 'meta)
  (setq ns-command-modifier 'meta)
  (setq ns-control-modifier 'control)
  (setq ns-option-modifier 'meta)
  (setq ns-right-alternate-modifier 'none)
  (setq ns-right-command-modifier 'super)
  (setq ns-right-control-modifier 'control)
  (setq ns-right-option-modifier 'none))

(when (eq 'berkeley-unix system-type))

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(load-theme 'deeper-blue)
(set-face-attribute 'default nil :height 150)
(global-display-line-numbers-mode)
(savehist-mode)

(setopt display-fill-column-indicator-column 100)
(global-display-fill-column-indicator-mode)

(setq user-mail-address "arturangiel@gmail.com")

(setq global-auto-revert-mode 1)

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(defvar my-packages '(slime rainbow-delimiters magit cider lsp-mode company helm))

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

(with-eval-after-load "~/quicklisp/log4slime-setup.el"
  (global-log4slime-mode 1))

(defvar parameters
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
    ,parameters)
   ("\\*Tags List\\*"
    display-buffer-in-side-window
    (side . right)
    (slot . 0)
    (window-width . fit-window-to-buffer)
    (preserve-size . (t . nil))
    ,parameters)
   ("\\*\\(?:help\\|grep\\|Completions\\)\\*"
    display-buffer-in-side-window
    (side . bottom)
    (slot . -1)
    (preserve-size . (nil . t))
    ,parameters)
   ("\\*\\(?:eshell\\|compilation\\)\\*"
    display-buffer-in-side-window
    (mode . eshell)
    (side . bottom)
    (slot . 1)
    (preserve-size . (nil . t))
    ,parameters)))

(defun dired-default-directory-on-left (dir)
  "Display `default-directory' in side window on left, hiding details."
  (interactive "DDefault directory: ")
  (let ((buffer (dired-noselect (or dir default-directory))))
    (with-current-buffer buffer (dired-hide-details-mode t))
    (display-buffer-in-side-window
     buffer `((side . left) (slot . 0)
              (window-width . fit-window-to-buffer)
              (preserve-size . (t . nil)) ,parameters))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cider cl-libify company dired-subtree helm jdecomp lsp-mode magit
	   paredit rainbow-delimiters slime)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'helm)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-c C-f") 'helm-find-files)
(global-set-key (kbd "s-;") 'previous-window-any-frame)

(defun disable-mouse ()
  (interactive)
  (dolist (k '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]  
               [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
               [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]
               [mouse-4] [down-mouse-4] [drag-mouse-4] [double-mouse-4] [triple-mouse-4]
               [mouse-5] [down-mouse-5] [drag-mouse-5] [double-mouse-5] [triple-mouse-5]))
    (global-unset-key k)))

