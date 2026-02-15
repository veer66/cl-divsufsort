(in-package #:cl-divsufsort-tests)

(def-suite* :tandem-repeat-copy-suite :in :cl-divsufsort-suite)

(test tandem-repeat-copy-no-match
  (let ((rank (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(sa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(isa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(first 0)
	(a 2)
	(b 3)
	(last 5)
	(depth 1))
    (cl-divsufsort::tandem-repeat-copy rank sa isa first a b last depth)
    (is (equalp sa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4))))))

(test tandem-repeat-copy-empty-range
  (let ((rank (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(sa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(isa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(first 0)
	(a 0)
	(b 5)
	(last 5)
	(depth 1))
    (cl-divsufsort::tandem-repeat-copy rank sa isa first a b last depth)
    (is (equalp sa (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4))))))
