(in-package #:cl-divsufsort-tests)

(def-suite* :tandem-repeat-insertion-sort-suite :in :cl-divsufsort-suite)

(test tandem-repeat-insertion-sort-unsorted
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))
    (cl-divsufsort::tandem-repeat-insertion-sort suffix-rank arr 0 10)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))))

(test tandem-repeat-insertion-sort-reverse
  (let ((arr (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0)))
	(suffix-rank (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort suffix-rank arr 0 5)
    (is (equalp arr (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0))))))

(test tandem-repeat-insertion-sort-small
  (let ((arr (make-array 3 :element-type 'fixnum :initial-contents '(2 1 0)))
	(suffix-rank (make-array 3 :element-type 'fixnum :initial-contents '(2 1 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort suffix-rank arr 0 3)
    (is (equalp arr (make-array 3 :element-type 'fixnum :initial-contents '(2 1 0))))))

(test tandem-repeat-insertion-sort-descending-rank
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(9 8 7 6 5 4 3 2 1 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort suffix-rank arr 0 10)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(9 8 7 6 5 4 3 2 1 0))))))

(test tandem-repeat-insertion-sort-equal-rank
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(0 0 0 0 0 0 0 0 0 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort suffix-rank arr 0 10)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(-6 -3 -9 -2 -10 -4 -8 -5 -7 0))))))

(test tandem-repeat-insertion-sort-empty
  (let ((arr (make-array 0 :element-type 'fixnum))
	(suffix-rank (make-array 0 :element-type 'fixnum)))
    (cl-divsufsort::tandem-repeat-insertion-sort suffix-rank arr 0 0)
    (is (equalp arr (make-array 0 :element-type 'fixnum)))))

(test tandem-repeat-insertion-sort-single
  (let ((arr (make-array 1 :element-type 'fixnum :initial-contents '(0)))
	(suffix-rank (make-array 1 :element-type 'fixnum :initial-contents '(0))))
    (cl-divsufsort::tandem-repeat-insertion-sort suffix-rank arr 0 1)
    (is (equalp arr (make-array 1 :element-type 'fixnum :initial-contents '(0))))))

(test tandem-repeat-insertion-sort-nonzero-first
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(0 5 2 8 1 9 3 7 4 6)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))
    (cl-divsufsort::tandem-repeat-insertion-sort suffix-rank arr 1 10)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))))

(test tandem-repeat-insertion-sort-non-last-last
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 0 0 0 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(4 1 7 3 9 5 0 0 0 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort suffix-rank arr 0 6)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(-9 9 1 3 5 2 0 0 0 0))))))
