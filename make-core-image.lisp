#!/usr/bin/env -S sbcl --dynamic-space-size 2048 --script

(mapc 'require '(sb-bsd-sockets sb-posix sb-introspect sb-cltl2 asdf uiop))

(when (member :darwin *features*)
  (setf (uiop:getenv "CPATH") #P"/opt/homebrew/include:$CPATH"))

(when (member :freebsd *features*)
  (sb-alien:load-shared-object #P"/usr/local/lib/libgit2.so"))

(load #P"~/quicklisp/setup.lisp")

(mapc 'ql:quickload
      '(:ACCESS
	:ALEXANDRIA
	:BORDEAUX-THREADS
	:CFFI
	:CL-CSV
	:CL-GIT
	:CL-YAML
	:CLACK
	:CLINGON
	:COM.INUOE.JZON
	:CXML
	:DEXADOR
	:FIVEAM
	:FSET
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

(when (member :darwin *features*)
  (mapc 'ql:quickload
	'(:CL-GLFW3
	  :CL-GLFW3-EXAMPLES
	  :CL-OPENGL
	  :GLFW)))

(log4cl.log4slime:install :force t)

(save-lisp-and-die #P"~/.emacs.d/sbcl.core-for-slime")

