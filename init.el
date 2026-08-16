(defmacro comment (&rest args) nil)

(when (eq 'darwin system-type)
  (setq ns-alternate-modifier 'alt)
  (setq ns-command-modifier 'meta)
  (setq ns-control-modifier 'control)
  (setq ns-option-modifier 'alt)
  (setq ns-right-alternate-modifier 'alt)
  (setq ns-right-command-modifier 'meta)
  (setq ns-right-control-modifier 'control)
  (setq ns-right-option-modifier 'none))

(when (eq 'berkeley-unix system-type))

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
(setq inferior-lisp-program (concat "sbcl --noinform --core "
				    (expand-file-name user-emacs-directory)
				    "sbcl.core-for-slime --dynamic-space-size 2048"))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)

(setq slime-contribs '(slime-fancy))

(load "~/quicklisp/log4slime-setup.el")
(global-log4slime-mode 1)

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

(defun dired-default-directory-on-left ()
  "Display `default-directory' in side window on left, hiding details."
  (interactive)
  (let ((buffer (dired-noselect default-directory)))
    (with-current-buffer buffer (dired-hide-details-mode t))
    (display-buffer-in-side-window
     buffer `((side . left) (slot . 0)
              (window-width . fit-window-to-buffer)
              (preserve-size . (t . nil)) ,parameters))))


