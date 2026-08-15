#!/usr/bin/env -S sbcl --dynamic-space-size 2048 --script

(mapc 'require '(sb-bsd-sockets sb-posix sb-introspect sb-cltl2 asdf uiop))

(setf (uiop:getenv "CPATH") "/opt/homebrew/include:$CPATH")

(load #P"~/quicklisp/setup.lisp")

(mapc 'ql:quickload
      '(:ACCESS
	:ALEXANDRIA
	:BORDEAUX-THREADS
	:CFFI
	:CL-CSV
	:CL-GIT
	:CL-GLFW3
	:CL-GLFW3-EXAMPLES
	:CL-OPENGL
	:CL-YAML
	:CLACK
	:CLINGON
	:COM.INUOE.JZON
	:CXML
	:DEXADOR
	:FIVEAM
	:FSET
	:GLFW
	:HUNCHENTOOT
	:IRONCLAD
	:KEBAB
	:LOCAL-TIME
	:LOG4CL
	:LOG4CL.LOG4SLIME
	:LPARALLEL
	:LTK
	:PARENSCRIPT
	:POSTMODERN
	:SERAPEUM
	:SLITE
	:STR
	:SYCAMORE
	:TRANSDUCERS
	:TRIVIA
	:TRIVIAL-DOWNLOAD
	:TUITION
	:ZIP))

(log4cl.log4slime:install :force t)

(save-lisp-and-die #P"~/.emacs.d/sbcl.core-for-slime")

