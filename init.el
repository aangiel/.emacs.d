;;; -*-  no-byte-compile: t; lexical-binding: t -*-

(defmacro comment (&rest _args) nil)

(load "~/.emacs.d/sanemacs.el" nil t)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode -1)
(global-display-line-numbers-mode 1)

(defvar my-packages
  '(slime dired-collapse hotfuzz))

(dolist (package my-packages)
  (unless (package-installed-p package)
    (package-install package)))

(when (eq 'darwin system-type)
  (setq ns-right-option-modifier 'none))

(setq source-directory (concat user-emacs-directory "src"))

(load-theme 'deeper-blue)
(set-face-attribute 'default nil :height 150)
(savehist-mode)

(fido-mode 1)
(fido-vertical-mode 1)

(setopt display-fill-column-indicator-column 79)
(global-display-fill-column-indicator-mode)

(setq user-mail-address "arturangiel@gmail.com")

(setq completion-styles '(hotfuzz))

(setq display-line-numbers 'relative)

(add-hook 'icomplete-minibuffer-setup-hook
          (lambda () (kill-local-variable 'completion-styles)))

(require 'slime)
(slime-setup '(slime-fancy
	       slime-quicklisp
	       slime-asdf
	       slime-mrepl
	       slime-autodoc))

(setq inferior-lisp-program
      (concat "sbcl --noinform --core "
	      (expand-file-name user-emacs-directory)
	      "sbcl.core-for-slime --dynamic-space-size 2048"))

(add-hook 'prog-mode-hook 'electric-pair-mode)

(setq slime-contribs '(slime-fancy))

;;(with-eval-after-load "~/quicklisp/log4slime-setup.el"
;;  (when (fboundp global-log4slime-mode) (global-log4slime-mode 1)))


(global-set-key (kbd "C-'") 'next-window-any-frame)

(setq-default cursor-type 'box)

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(let ((gls (executable-find "gls")))
  (setq insert-directory-program (or gls insert-directory-program))
  (setq dired-listing-switches
	(if (and (not gls)
		 (eq system-type 'darwin))
	  "-lahF -D%FT%R"
	  "-lahG --time-style=long-iso --group-directories-first")))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind (:map dired-mode-map
              ("i" . dired-subtree-toggle)))

(use-package inhibit-mouse
  :custom
  (inhibit-mouse-adjust-mouse-highlight t)
  (inhibit-mouse-adjust-show-help-function t)
  :init
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'inhibit-mouse-mode)
    (inhibit-mouse-mode 1)))

(setq dired-kill-when-opening-new-dired-buffer t)

(defun aangiel/eshell (&optional n)
  (interactive "P")
  (dotimes (i (or n 3))
    (display-buffer-in-side-window (eshell i) `((side . bottom) (slot . ,i)))))

(setq display-buffer-alist
      `(((major-mode . dired-mode)
	 display-buffer-in-side-window
	 (slot . 0)
	 (side . left))))

(aangiel/eshell)
(dired "~")
(next-window-any-frame)
(split-window-horizontally)
(scratch-buffer)

(modify-frame-parameters (car (frame-list))
			 '((top + -1440) (left + 0)))

(add-to-list 'default-frame-alist '(fullscreen . fullboth))

(defun aangiel/asciidoc-compile ()
  (interactive)
  (message (buffer-file-name))
  (save-buffer)
  (shell-command
   (concat "asciidoctor-pdf -r asciidoctor-diagram " (buffer-file-name))
   nil))
