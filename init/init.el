
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; Bundles
(el-get-bundle ananthakumaran/tide)
(el-get-bundle ananthakumaran/typescript.el)

(el-get 'sync
        '(
          el-get
          color-theme-sanityinc-tomorrow
                    
          flycheck

          web-mode
          company-mode
          haskell-mode
          json-mode
          yaml-mode
          markdown-mode
          typescript.el
          tide
          tuareg-mode
          
          swiper
          ace-window
          magit
          popup-kill-ring
          diff-hl
          neotree
          multi-term
          )
        )

(require 'color-theme-sanityinc-tomorrow)
(color-theme-sanityinc-tomorrow-night)

(defun save-all ()
  (interactive)
  (save-some-buffers t))
(add-hook 'focus-out-hook 'save-all)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)

(set-default-font "Source Code Pro-14")
(global-diff-hl-mode)
(setq use-dialog-box 0)
(tool-bar-mode 0)
(show-paren-mode t)
(display-time-mode 0)
(scroll-bar-mode 0)

(global-hl-line-mode t)
(global-linum-mode 0)
(column-number-mode 1)
(delete-selection-mode t)

(setq-default cursor-type 'bar)
(blink-cursor-mode 0)

(electric-pair-mode)

(setq inhibit-splash-screen t)
(defalias 'yes-or-no-p 'y-or-n-p)

(global-flycheck-mode 1)

;; indent
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq backup-directory-alist `(("." . "~/tmp/emacssaves")))

(add-hook 'after-init-hook 'global-company-mode)
(setq neo-smart-open t)

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

(setq mac-option-modifier nil
      mac-command-modifier 'meta
      x-select-enable-clipboard t)

(global-set-key (kbd "M-p") 'mark-paragraph)
(global-set-key (kbd "M-<RET>") 'toggle-frame-fullscreen)
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "C-<return>") 'company-complete)
(global-set-key [f8] 'neotree-toggle)

(require 'popup)
(require 'pos-tip)
(require 'popup-kill-ring)
(global-set-key (kbd "M-y") 'popup-kill-ring)

;; Errors
(global-set-key [M-f1] 'flycheck-list-errors)
(global-set-key [f1] 'first-error)
(global-set-key [f2] 'next-error)
(global-set-key [S-f2] 'previous-error)
(global-set-key [S-f5]
                (lambda ()
                  (interactive)
                  (org-babel-load-file
                   (expand-file-name (concat user-emacs-directory "init/init.org")))
                  ))

;; join line to next line
(global-set-key (kbd "M-j")
                (lambda ()
                  (interactive)
                  (join-line -1)))

;; imenu
(global-set-key (kbd "M-i") 'imenu)

(setq org-confirm-babel-evaluate nil)
(setq org-src-fontify-natively t)

(setq org-src-tab-acts-natively t)
(org-babel-do-load-languages
 'org-babel-load-languages
      '((haskell . t)
        (emacs-lisp . t)
        (sh . t)
        ))

(setq org-hide-emphasis-markers t)

;; Bullets
(font-lock-add-keywords
 'org-mode
 '(("^ +\\([-*]\\) "
    (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(setq haskell-font-lock-symbols t)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-decl-scan-mode)

(setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
(add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))
(require 'merlin)

(add-hook 'tuareg-mode-hook 'merlin-mode)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'merlin-company-backend))

(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (flycheck-mode +1)
            (eldoc-mode +1)
            (company-mode-on)))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
