(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" default)))
 '(package-selected-packages
   (quote
    (prettier-js python-black blacken elpy vline flycheck json-mode multiple-cursors symon org-bullets drag-stuff chess nyan-mode goto-last-change dumb-jump smartparens tabbar neotree direx auto-complete comment-dwim-2 solarized-theme yasnippet-snippets yasnippet smex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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

;; keyboard shortcut for jump to directory
(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

;; draggin stuff up and down with alt and the up and down arrows
(global-set-key (kbd "M-<up>") 'drag-stuff-up)
(global-set-key (kbd "M-<down>") 'drag-stuff-down)

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
		 (format "nodejs %s" (shell-quote-argument (buffer-name))))))


;; Adding the local bin to my path
(setq exec-path (append exec-path '("~/.local/bin")))

;; Python formatter black
(add-hook 'python-mode-hook 'blacken-mode)

;; JS code formatter
(require 'prettier-js)
(add-hook 'js-mode-hook 'prettier-js-mode)

