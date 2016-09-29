;;; -*- Mode: Lisp; Package: EDITOR -*-

(provide "lessmode")

(in-package "editor")

(export '(*less-mode-hook* *less-mode-map* less-mode))

;; -------------

(defvar *less-mode-hook*
      '(lambda ()
        (setq c-indent-level 4)
        (setq c-brace-offset -4)
        (setq c-continued-statement-offset 4)
        (setq c-argdecl-indent 4)
        (setq c-label-offset 0)
        (setq c-brace-imaginary-offset 0)
        (setq indent-tabs-mode t)))

(defvar *less-mode-map* nil)
(unless *less-mode-map*
  (setq *less-mode-map* (make-sparse-keymap))
  (define-key *less-mode-map* #\M-TAB 'less-completion)
  (define-key *less-mode-map* #\RET 'c-newline-and-indent)
  (define-key *less-mode-map* #\{ 'c-electric-insert)
  (define-key *less-mode-map* #\} 'c-electric-insert)
  (define-key *less-mode-map* #\TAB 'c-indent-line)
)

(defvar *less-keyword-hash-table* nil)
(defvar *less-keyword-file* "less")

(defvar *less-mode-syntax-table* nil)
(unless *less-mode-syntax-table*
  (setq *less-mode-syntax-table* (make-syntax-table))
  (do ((x #x21 (1+ x)))((>= x #x7f))
    (let ((c (code-char x)))
      (unless (alphanumericp c)
	(set-syntax-punctuation *less-mode-syntax-table* c))))
  (set-syntax-string *less-mode-syntax-table* #\")
  (set-syntax-string *less-mode-syntax-table* #\')
  (set-syntax-symbol *less-mode-syntax-table* #\_)
  (set-syntax-symbol *less-mode-syntax-table* #\-)
  (set-syntax-symbol *less-mode-syntax-table* #\@)
  (set-syntax-symbol *less-mode-syntax-table* #\!)
  (set-syntax-symbol *less-mode-syntax-table* #\#)
  (set-syntax-match *less-mode-syntax-table* #\( #\))
  (set-syntax-match *less-mode-syntax-table* #\{ #\})
  (set-syntax-match *less-mode-syntax-table* #\[ #\])
  (set-syntax-start-multi-comment *less-mode-syntax-table* "/*")
  (set-syntax-end-multi-comment *less-mode-syntax-table* "*/")
  (set-syntax-start-c++-comment *less-mode-syntax-table* #\/)
  (set-syntax-end-c++-comment *less-mode-syntax-table* #\LFD))

(defun less-mode ()
  (interactive)
  (kill-all-local-variables)
  (setq buffer-mode 'less-mode)
  (setq mode-name "less")
  (use-keymap *less-mode-map*)
  (use-syntax-table *less-mode-syntax-table*)
  ;; キーワードファイル
  (and *less-keyword-file*
       (null *less-keyword-hash-table*)
       (setq *less-keyword-hash-table*
	     (load-keyword-file *less-keyword-file* t)))
  (when *less-keyword-hash-table*
    (make-local-variable 'keyword-hash-table)
    (setq keyword-hash-table *less-keyword-hash-table*))
  (run-hooks '*less-mode-hook*))

