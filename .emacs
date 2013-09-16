;; Do not clutter CWD with backup files
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp")
(add-to-list 'load-path "/Users/andreasg/emacs/site-lisp")
(add-to-list 'load-path "/opt/local/share/emacs/site-lisp")
(add-to-list 'load-path "/Users/andreasg/elisp/color-theme")
(add-to-list 'load-path "/Users/andreasg/elisp/undo-tree")
;(mapc 'load-file (directory-files "~/.emacs.d/" t "^[^.]+\.el$"))

;;(add-to-list 'load-path "~/.emacs.d/ensime/src/main/elisp/")

;;(require 'magit)
;;(require 'csv-mode)
;;(require 'ensime)
;;(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

(setq auto-mode-alist
  (cons '("\\.php\\w?" . php-mode) auto-mode-alist))
(autoload 'php-mode "php-mode" "PHP mode." t)

(column-number-mode t)
(set-face-attribute 'default nil :font 
                    "-apple-Monaco-*-normal-normal-*-10-*-*-*-m-0-iso10646-1")

(setq ispell-program-name "ispell")

;;(Require 'undo-tree)

;;(if 0 ;;window-system
;;    (progn
;;      (require 'color-theme)
;;      (color-theme-initialize)
;;      (setq color-theme-is-global t)
;;      (color-theme-pok-wog))
;;      (color-theme-classic))
;;      )

(setq mac-command-modifier 'meta)

(add-to-list 'load-path "~/.emacs.d/")
(require 'package)
(add-to-list 'package-archives
        '("marmalade" . "http://marmalade-repo.org/packages/") t)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

 ;;; LOOKIE FEELIE
(setq visible-bell t)
(global-font-lock-mode t)
(setq transient-mark-mode t)
(iswitchb-mode 't)
(set-input-method "ucs")

;;; C++
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

;;; ORG mode
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;;; TRAMP
(setq tramp-default-method "ssh")
;(add-to-list 'tramp-remote-path "/usr/local/bin")
;(add-to-list 'tramp-default-proxies-alist
;	     '(nil "\\`root\\'" "/ssh:%h:"))
;(add-to-list 'tramp-default-proxies-alist
;	     '((regexp-quote (system-name)) nil nil))

;;; C
(setq-default c-offsets-alist '((case-label . +))
	      c-default-style '((java-mode . "java") 
				(awk-mode . "awk") 
				(c++-mode . "bsd") 
				(c-mode . "bsd") 
				(objc-mode . "bsd") 
				(other . "gnu"))
	      c-basic-offset 4
	      indent-tabs-mode nil)

(setq ns-pop-up-frames 'nil)
(setq mac-command-modifier 'meta)
;(server-start)


(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))

(require 'mouse)
(xterm-mouse-mode t)
(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'scroll-up-line)


;; Look for cabal files down a directory path
;; Example:
;; $ (find-deep-cabal "/Users/andreasg/work/gotera/src" 1)
;; ("/Users/andreasg/work/gotera/gotera.cabal")
;; $ (find-deep-cabal "/Users/andreasg/work/gotera/src" 0)
;; ()
;; $ (find-deep-cabal "/Users/andreasg/work/gotera/src/Gotera" 2)
;; ("/Users/andreasg/work/gotera/gotera.cabal")

(defun find-cabal (dir)
  (ignore-errors 
    (directory-files dir t ".cabal")))

;; Returns the first 'true' result of fun
(defun find-deep (dir lvl fun)
  (if  (>= lvl 0) 
      (let ((file (funcall fun dir)))
        (if (not file)
            (find-deep (cd.. dir) (1- lvl) fun)
          file))))

;; Returns the first 'true' result of fun
;; Can return multiple .cabal files on the same directory level
(defun find-deep-cabal (dir lvl)
  (find-deep dir lvl 'find-cabal))

(defun cd.. (dir)
  (if (equal "/" dir)
      dir
    (file-name-directory
     (if (equal "/" (substring dir -1))
         (substring dir 0 -1)
       dir))))

(defun search-cabal (dir)
  (interactive "D")
  (find-deep-cabal dir 2))

(defun cabaldev-install ()
  (interactive)
  ;; Can be a long list of cables, lazy me picks the first
  (let ((cabal (car (find-deep-cabal default-directory 3))))
    (if cabal 
        (cabal-build cabal))))

(defun cabal-build (cabal)
  (let ((cmd (format "cd %s && cabal-dev install" 
                     (file-name-directory cabal))))
    (compile cmd)))
          
;; Fix environment when using Emacs.app
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))


