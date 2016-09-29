# less-mode for xyzzy

Add this code to ~/.xyzzy

	(load-library "less-mode")
	(pushnew '("\\.less$" . less-mode) *auto-mode-alist*)
