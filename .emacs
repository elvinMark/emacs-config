(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("fe1c13d75398b1c8fd7fdd1241a55c286b86c3e4ce513c4292d01383de152cb7" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "57d7e8b7b7e0a22dc07357f0c30d18b33ffcbb7bcd9013ab2c9f70748cfa4838" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" default)))
 '(display-battery-mode t)
 '(package-selected-packages
   (quote
    (tide typescript-mode dracula-theme speed-type prettify-greek minimap all-the-icons centaur-tabs web-beautify 2048-game latex-preview-pane auctex powerline origami look-mode markdown-preview-mode markdown-mode magit use-package jsonnet-mode google-this jedi color-theme-modern color-theme clang-format lorem-ipsum web-mode prettier prettier-js python-black blacken elpy vline flycheck json-mode multiple-cursors symon org-bullets drag-stuff chess nyan-mode goto-last-change dumb-jump smartparens tabbar neotree direx auto-complete comment-dwim-2 solarized-theme yasnippet-snippets yasnippet smex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Installed necessary packages if needed
(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))

;; Setting different themes for GUI and terminal emacs
(if (display-graphic-p) (load-theme 'solarized-dark) (load-theme 'desert))

;; Setting the directory for generated temporary files
(setq backup-directory-alist '(("."."~/.saves")))

;; Setting autocomplete mode for all files (all modes)
(global-auto-complete-mode t)

;; Avoiding the startup message
(setq inhibit-startup-message t)

;; Erasing the tool bar (-1 value)
(tool-bar-mode -1)

;; Deactivating scrollbar mode (-1 value)
(scroll-bar-mode -1)

;; Deactivating menubar mode (-1 value)
(menu-bar-mode -1)

;; Start  with a maximized window
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; activate highlighting current line
(global-hl-line-mode)

;; highlight the correspondant bracket
(show-paren-mode 1)

;; Display time and date
(setq display-time-day-and-date 1)
(display-time-mode 1)

;; Display battery status
(display-battery-mode 1)

;; keyboard shortcut for jump to directory
(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

;; draggin stuff up and down with alt and the up and down arrows
(global-set-key (kbd "M-<up>") 'drag-stuff-up)
(global-set-key (kbd "M-<down>") 'drag-stuff-down)

;; Buffer list
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; initialize smex
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

;; initialize org bullets and adding the hook to org mode
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; activating nyan-mode
(nyan-mode 1)

;; commenting and uncommenting lines
(global-set-key (kbd "M-;") 'comment-dwim-2)

;; initializ symon mode (cpu status bar)
(require 'symon)
(symon-mode)

;; initialize smart parens (automatic close of brackets)
(smartparens-global-mode)

;; enabling snippets with yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; setting the default shell binary for ansi-term
(setq explicit-shell-file-name "/bin/zsh")

;; line numbers on the side, unless it is a shell terminal
(require 'display-line-numbers)
(defcustom display-line-numbers-exempt-modes 
  '(ansi-term-mode term-mode shell-mode eshell-mode vterm-mode)
  "modes on which to disable display numbers mode"
  :group 'display-line-numbers
  :type 'list
  :version "green")
(defun display-line-numbers--turn-on ()
  (unless (or (minibufferp)
	      (member major-mode display-line-numbers-exempt-modes))
    (display-line-numbers-mode)))
(global-display-line-numbers-mode)

;; Assign F5 to compile current buffer code
(global-set-key (kbd "<f5>") 'compile)
;; Adding a hook to different modes so proceeds with proper compilation line
(add-hook 'python-mode-hook
	  (lambda ()
	    (set (make-local-variable 'compile-command)
		 (format "python3 %s" (shell-quote-argument (buffer-name))))))

(add-hook 'c-mode-hook
	  (lambda ()
	    (set (make-local-variable 'compile-command)
		 (format "gcc %s -o a.out && ./a.out" (shell-quote-argument (buffer-name))))))

(add-hook 'c++-mode-hook
	  (lambda ()
	    (set (make-local-variable 'compile-command)
		 (format "g++ %s -o a.out && ./a.out" (shell-quote-argument (buffer-name))))))

(add-hook 'latex-mode-hook
	  (lambda ()
	    (set (make-local-variable 'compile-command)
		 (format "pdflatex --jobname=output %s && evince output.pdf" (shell-quote-argument (buffer-name))))))

(add-hook 'js-mode-hook
	  (lambda ()
	    (set (make-local-variable 'compile-command)
		 (format "node %s" (shell-quote-argument (buffer-name))))))


;; Adding the local bin to my path
(setq exec-path (append exec-path '("~/.local/bin")))

;; Python formatter black
(add-hook 'python-mode-hook 'blacken-mode)
(add-hook 'python-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c i") 'blacken-buffer)))

;; Adding C/C++ and Java formater using clang-format
(setq clang-format-fallback-style "llvm")
;; Hook when saving
(add-hook 'c-mode-hook
	  (lambda ()
	    (add-hook 'before-save-hook 'clang-format-buffer nil 'local)))
(add-hook 'c++-mode-hook
	  (lambda ()
	    (add-hook 'before-save-hook 'clang-format-buffer nil 'local)))
(add-hook 'java-mode-hook
	  (lambda ()
	    (add-hook 'before-save-hook 'clang-format-buffer nil 'local)))

;; Hook with key binding
(add-hook 'c-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c i") 'clang-format-buffer)))
(add-hook 'c++-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c i") 'clang-format-buffer)))
(add-hook 'java-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c i") 'clang-format-buffer)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Experimental as it runs slow on low performance machines
;; JS code formatter
(require 'prettier-js)
;; (add-hook 'js-mode-hook 'prettier-js-mode)
;; (add-hook 'web-mode-hook 'prettier-js-mode)

;; Using js-beautify instead of prettier-js to make it a little bit faster
(require 'web-beautify)
(add-hook 'js-mode-hook
	  (lambda ()
	    (add-hook 'before-save-hook 'web-beautify-js nil 'local)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Lorem Ipsum tool to generate rubbish text
(require 'lorem-ipsum)
(lorem-ipsum-use-default-bindings)

;; Configuring indentation for java (from 4 -> 2)
(add-hook 'java-mode-hook (lambda ()
			    (setq c-basic-offset 2)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Experimenta as it runs quite slowly
;; Jedi for autocomplete in python
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Disable prettier js mode for JSON mode
(add-hook 'json-mode-hook (lambda () (prettier-js-mode -1)))

;; keybinding to pretify JSON
(add-hook 'json-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c i") 'json-pretty-print-buffer)))

;; Google this command
(google-this-mode 1)

;; Adding magit
(use-package magit
  :ensure t
  :bind ((("C-c g" . magit-file-dispatch))))


;; Adding origami fold to different programming languages modes
(defun loading-origami-to-modes ()
  (origami-mode)
  (local-set-key (if (display-graphic-p) (kbd "C-<tab>") (kbd "C-c h")) 'origami-toggle-node))

(dolist (hook '(python-mode-hook c-mode-hook c++-mode-hook js-mode-hook java-mode-hook))
  (add-hook hook 'loading-origami-to-modes))

;; Activating powerline mode just in GUI mode
(if (display-graphic-p) (powerline-default-theme) (powerline-vim-theme))

;; Configuring tabs using centaur-tabs
;; run all-icons-install-fonts first to install necessary icons
(require 'all-the-icons)
(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward)
  :init
  (setq centaur-tabs-style "bar"
	centaur-tabs-set-icons t
	centaur-tabs-set-bar 'under
	x-underline-at-descent-line t
	centaur-tabs-enable-key-bindings t))

;; start side bar directory tree
(neotree)
(setq neo-theme 'icons)

;; side Minimap (sublime-like)
(require 'minimap)
(setq minimap-window-location 'right)
(global-set-key (kbd "C-c m") 'minimap-mode)


;; prettify symbols (greek symbols) for Python/C/C++/JS
(require 'prettify-greek)
(dolist (hook '(python-mode-hook c-mode-hook c++-mode-hook js-mode-hook))
  (add-hook hook
	    (lambda ()
	      (setq prettify-symbols-alist prettify-greek-lower)
	      (prettify-symbols-mode t))))


;; Adding multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-.") 'mc/mark-next-like-this)
(global-set-key (kbd "C-,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-,") 'mc/mark-all-like-this)

;; Configuring flycheck
(setq flycheck-check-syntax-automatically '(mode-enabled save))

;; Configuring typescript mode
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (eldoc-mode 1)
  (flycheck-mode 1)
  (tide-hl-identifier-mode 1))

(add-hook 'typescript-mode-hook
	  (lambda ()
	    (add-hook 'before-save-hook 'tide-format-before-save)))
(add-hook 'typescript-mode-hook #'setup-tide-mode)
(setq tide-format-options '(:insertSpaceAfterFunctionKeywordForAnonymousFunctions t :placeOpenBraceOnNewLineForFunctions nil))
