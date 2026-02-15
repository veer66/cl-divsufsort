(defsystem "cl-divsufsort"
  :description "Suffix array construction"
  :author "Vee Satayamas <veerpub@pm.me>"
  :license "MIT"
  :version "0.0.1"
  :depends-on (#:uiop)
  :serial t
  :components ((:file "package")
	       (:file "tandem-repeat-sort")
               (:file "cl-divsufsort"))
  :in-order-to ((test-op (test-op "cl-divsufsort/tests"))))

(defsystem "cl-divsufsort/tests"
  :depends-on ("cl-divsufsort" "fiveam")
  :components ((:module "tests"
		:components ((:file "test-package")
			     (:file "cl-divsufsort-tests")
			     (:file "int-lg-suite")
			     (:file "tandem-repeat-insertion-sort-suite")
			     (:file "tandem-repeat-fix-down-suite")
			     (:file "tandem-repeat-heap-sort-suite")
			     (:file "tandem-repeat-median3-suite"))))
  :perform (test-op (o c)
		    (symbol-call :fiveam '#:run! :cl-divsufsort-suite)))

