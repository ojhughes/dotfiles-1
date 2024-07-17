;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ollie Hughes"
      user-mail-address "olli.hughes@gmail.com")

(setq doom-font (font-spec :family "Hack Nerd Font" :size 18 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Avenir Next" :weight 'medium' :size 18))
;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "/Users/ohughes/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org")
(setq org-agenda-files '("/Users/ohughes/org/work.org" "/Users/ohughes/org/home.org"))
(setq projectile-project-search-path '(("~/workspace" . 1) ("~/workspace/scratch" . 1) ("/Users/ohughes/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org" . 1)))
(auto-save-visited-mode +1)
(setq org-plantuml-jar-path "/usr/local/Cellar/plantuml/1.2022.4/libexec/plantuml.jar")
(setq org-plantuml-executable-path "/usr/local/bin/plantuml")
(setq org-plantuml-exec-mode 'executable)
(after! org
  (add-to-list 'org-capture-templates
               `("w", "Work Note" entry (file "work.org"),
                 (string-join '("* %?")))))

(load (expand-file-name "~/.roswell/helper.el"))
(setq inferior-lisp-program "ros -Q run")
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(define-key key-translation-map (kbd "M-3") (kbd "#"))
(setenv "PATH" (concat (getenv "PATH") ":/Users/ohughes/.ghcup/bin"))
(setq exec-path (append exec-path '("/Users/ohughes/.ghcup/bin")))
(setenv "PATH" (concat (getenv "PATH") ":/Users/ohughes/.cabal/bin"))
(setq exec-path (append exec-path '("/Users/ohughes/.cabal/bin")))
(setenv "PATH" (concat (getenv "PATH") ":/Users/ohughes/go/bin"))
(setq exec-path (append exec-path '("/Users/ohughes/go/bin")))
;; (setenv "GOROOT" "/opt/homebrew/opt/go@1.19/libexec")
(setq auth-sources '("~/.authinfo"))


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
