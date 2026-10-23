;;; -*-  no-byte-compile: t; lexical-binding: t -*-

(defmacro comment (&rest _args) nil)

(load "~/.emacs.d/sanemacs.el" nil t)

(use-package load-env-vars)
(load-env-vars "~/.env")

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
(set-face-attribute 'default nil :height 150 :family "Fira Code")
(savehist-mode)

(fido-mode 1)
(fido-vertical-mode 1)
(add-hook 'after-init-hook 'global-company-mode)

(global-set-key (kbd "<tab>") #'company-indent-or-complete-common)

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

(setq dired-listing-switches "-lahF -D%FT%R")
(setq insert-directory-program "ls")

(comment
 (let ((gls (executable-find "gls")))
   (setq insert-directory-program (or gls insert-directory-program))
   (setq dired-listing-switches
	 (if (and (not gls)
		  (eq system-type 'darwin))
	     "-lahF -D%FT%R"
	   "-lahG --time-style=long-iso --group-directories-first"))))

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

(use-package gptel)
(setq gptel-api-key (getenv "OPENAI_API_KEY"))
(gptel-make-openai "llama-cpp"	;Any name
	   :stream t			;Stream responses
	   :protocol "http"
	   :host "localhost:8080"	;Llama.cpp server location
	   :models '(test))

(gptel-make-openai "lm-studio"	;Any name
	   :stream t			;Stream responses
	   :protocol "http"
	   :host "localhost:1234"	;Llama.cpp server location
	   :models '(lm-studio))

(add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
(add-hook 'gptel-post-response-functions 'gptel-end-of-response)
(gptel-make-gemini "Gemini" :key (getenv "GEMINI_API_KEY") :stream t)

(gptel-make-openai "OpenRouter"               ;Any name you want
  :host "openrouter.ai"
  :endpoint "/api/v1/chat/completions"
  :stream t
  :key (getenv "OPENROUTER_API_KEY")                   ;can be a function that returns the key
  :models '(openrouter/free
	    openrouter/pareto-code
	    deepseek/deepseek-v4.1-flash))

(gptel-make-xai "xAI"                   ; Any name you want
  :stream t
  :key (getenv "GROK_API_KEY"))

(gptel-make-anthropic "Claude"          ;Any name you want
  :stream t                             ;Streaming responses
  :key (getenv "ANTHROPIC_API_KEY"))

(setq sh-shell-file "/bin/dash")

(use-package copilot
  :ensure t
  :init (setq copilot-indent-offset-warning-disable t)
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . copilot-accept-completion)
              ("TAB" . copilot-accept-completion)
              ("C-<tab>" . copilot-accept-completion-by-word)
              ("C-TAB" . copilot-accept-completion-by-word)
              ("C-n" . copilot-next-completion)
              ("C-p" . copilot-previous-completion)))

(add-hook 'eww-after-render-hook #'eww-readable)

(defun aangiel/freebsd-man (topic)
  "Search FreeBSD man pages for TOPIC and display the result in eww.
TOPIC may be \"name\" or \"name section\"."
  (interactive "sFreeBSD man page [section]: ")
  (let ((base-url
	 "https://man.freebsd.org/cgi/man.cgi?query=%s&sektion=%s&format=html")
	(name (string-trim topic))
        (section "0"))
    (when (string-match "\\([\\._A-Za-z]+\\)\s+\\([0-9]\\)"  name)
      (setq section (match-string 2 name)
	    name    (match-string 1 name)))
    (eww (format base-url (url-hexify-string name) section))))
