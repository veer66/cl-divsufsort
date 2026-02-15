(in-package #:cl-divsufsort-tests)

(def-suite* :tandem-repeat-partition-suite :in :cl-divsufsort-suite)

(test tandem-repeat-partition-basic
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(1 1 1 2 2 2 3 3 3 0)))
	(arr (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9)))
	(pa (make-array 1 :element-type 'fixnum))
	(pb (make-array 1 :element-type 'fixnum)))
    (multiple-value-bind (a b) (cl-divsufsort::tandem-repeat-partition rank arr 0 5 10 pa pb 2)
      (is (= a (aref pa 0)))
      (is (= b (aref pb 0)))
      (is (= a 4))
      (is (= b 7)))))

(test tandem-repeat-partition-all-equal
  (let ((rank (make-array 6 :element-type 'fixnum :initial-contents '(2 2 2 2 2 2)))
	(arr (make-array 6 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5)))
	(pa (make-array 1 :element-type 'fixnum))
	(pb (make-array 1 :element-type 'fixnum)))
    (multiple-value-bind (a b) (cl-divsufsort::tandem-repeat-partition rank arr 0 3 6 pa pb 2)
      (is (= a (aref pa 0)))
      (is (= b (aref pb 0)))
      (is (= a 0))
      (is (= b 6)))))

(test tandem-repeat-partition-nil-output
  (let ((rank (make-array 6 :element-type 'fixnum :initial-contents '(1 1 2 2 3 3)))
	(arr (make-array 6 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5)))
	(pa (make-array 1 :element-type 'fixnum))
	(pb (make-array 1 :element-type 'fixnum)))
    (multiple-value-bind (a b) (cl-divsufsort::tandem-repeat-partition rank arr 0 2 6 pa pb 2)
      (is (= a (aref pa 0)))
      (is (= b (aref pb 0)))
      (is (= a 2))
      (is (= b 4)))))

(test tandem-repeat-partition-no-pa-pb
  (let ((rank (make-array 6 :element-type 'fixnum :initial-contents '(1 1 2 2 3 3)))
	(arr (make-array 6 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5))))
    (multiple-value-bind (a b) (cl-divsufsort::tandem-repeat-partition rank arr 0 2 6 nil nil 2)
      (is (= a 2))
      (is (= b 4)))))
