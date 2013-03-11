
(setq viper-case-fold-search t) ; don't touch or else...

(setq-default viper-auto-indent t)

(setq viper-change-notification-threshold 0
      viper-expert-level 5
      viper-inhibit-startup-message t
      viper-vi-style-in-minibuffer nil
      viper-want-ctl-h-help t)

(setq-default viper-ex-style-editing nil)
(setq-default viper-ex-style-motion nil)
(setq-default viper-delete-backwards-in-replace t)

;; `.mad-to-list' is defined in yet another file like this:
(defun .mad-to-list (lvar els &optional append cmpfun)
  "Add elements contained in the list ELS to LVAR.
In short, multi- `add-to-list', which also see for explanation of
the optional arguments.
Returns the new value of LVAR."
  (dolist (el els (symbol-value lvar)) (add-to-list lvar el append cmpfun)))

(.mad-to-list 'viper-emacs-state-mode-list '(desktop-menu-mode etags-select-mode))

(define-key viper-vi-basic-map "\C-c/" nil)    ; viper-toggle-search-style
(define-key viper-vi-basic-map "\C-\\" nil)    ; viper-alternate-Meta-key
(define-key viper-insert-basic-map "\C-\\" nil)
(define-key viper-vi-basic-map "\C-^" nil)     ; (viper-ex "e#")
(define-key viper-insert-basic-map "\C-d" nil) ; viper-backward-indent
(define-key viper-insert-basic-map "\C-t" nil) ; viper-forward-indent
(define-key viper-insert-basic-map "\C-w" nil) ; viper-delete-backward-word
(define-key viper-insert-basic-map "\C-p" nil) 
(define-key viper-insert-basic-map "\C-n" nil)  
(define-key viper-insert-basic-map (kbd "<delete>") nil)

;; see `viper-adjust-keys-for'; mind boggles...
(defadvice viper-adjust-keys-for (after fuck-viper activate)
  (define-key viper-insert-basic-map "\C-m" nil) ; viper-autoindent
  (define-key viper-insert-basic-map "\C-j" nil)
  (define-key viper-insert-basic-map (kbd "<backspace>") nil) ; viper-del-backward-char-in-insert
  (define-key viper-insert-basic-map "" nil))

(define-key viper-vi-global-user-map " " 'viper-scroll-screen)
(define-key viper-vi-global-user-map (kbd "<backspace>") 'viper-scroll-screen-back)
(define-key viper-vi-global-user-map (kbd "DEL") 'viper-scroll-screen-back)

;; `copy-from-above-command' is defined in misc.el and comes with Emacs;
;; `copy-from-below-command' is just an adjustment of the above, left as an
;; exercise for the reader
;; (define-key viper-insert-global-user-map (kbd "C-y") (lambda (&optional arg) (interactive "p")
;; (copy-from-above-command arg)))
;; (define-key viper-insert-global-user-map (kbd "C-e") (lambda (&optional arg) (interactive "p")
;; (copy-from-below-command arg)))
