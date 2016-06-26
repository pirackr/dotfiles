(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(menu-bar-mode nil)
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Liberation Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal)))))

(setq tab-width 2)
(setq whitespace-line-column 120)
(setq js-indent-level 2)
(setq js2-basic-offset 2)
(setq-default tab-width 2)
(setq indent-tabs-mode nil)
(setq tab-width 4)
(setq coffee-tab-width 2)
(setq-default indent-tabs-mode nil)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-code-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-content-types-alist
      '(("jsx" . "\\.js[x]?\\'")))
(add-to-list 'auto-mode-alist '("\\.react.js\\'" . web-mode))
