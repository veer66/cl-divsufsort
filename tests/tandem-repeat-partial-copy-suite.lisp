(in-package #:cl-divsufsort-tests)

(def-suite* :tandem-repeat-partial-copy-suite :in :cl-divsufsort-suite)

(test tandem-repeat-partial-copy-empty
  (let ((sa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(isa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(first 0)
	(a 2)
	(b 3)
	(last 5)
	(depth 1))
    (cl-divsufsort::tandem-repeat-partial-copy sa isa first a b last depth)
    (is (equalp sa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4))))
    (is (equalp isa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4))))))
