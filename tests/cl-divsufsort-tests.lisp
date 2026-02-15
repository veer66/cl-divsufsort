(in-package #:cl-divsufsort-tests)

(def-suite :cl-divsufsort-suite)

(def-suite* :int-lg-suite :in :cl-divsufsort-suite)

(test int-lg-test
  (loop for n in
	      (list 0 1 2 3 4 7 8 15 16 31 32 63 64 127 128
		    255 256 511 512 1023 1024
		    (1- (expt 2 32)) (expt 2 32) (1+ (expt 2 32))
		    (1- (expt 2 48)) (expt 2 48) (1+ (expt 2 48))
		    (1- (expt 2 56)) (expt 2 56) (1+ (expt 2 56))
		    most-positive-fixnum)
	do
	   (is (= (cl-divsufsort::int-lg n)
		  (if (= n 0)
		      -1
		      (1- (integer-length n)))))))

(def-suite* :tandem-repeat-insertion-sort-suite :in :cl-divsufsort-suite)

(test tandem-repeat-insertion-sort-unsorted
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))
    (cl-divsufsort::tandem-repeat-insertion-sort arr 0 10 suffix-rank)
    (is (equalp arr '(0 1 2 3 4 5 6 7 8 9)))))

(test tandem-repeat-insertion-sort-reverse
  (let ((arr (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0)))
	(suffix-rank (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort arr 0 5 suffix-rank)
    (is (equalp arr '(0 1 2 3 4)))))

(test tandem-repeat-insertion-sort-small
  (let ((arr (make-array 3 :element-type 'fixnum :initial-contents '(2 1 0)))
	(suffix-rank (make-array 3 :element-type 'fixnum :initial-contents '(2 1 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort arr 0 3 suffix-rank)
    (is (equalp arr '(0 1 2)))))

(test tandem-repeat-insertion-sort-descending-rank
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(9 8 7 6 5 4 3 2 1 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort arr 0 10 suffix-rank)
    (is (equalp arr '(0 1 2 3 4 5 6 7 8 9)))))

(test tandem-repeat-insertion-sort-equal-rank
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(0 0 0 0 0 0 0 0 0 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort arr 0 10 suffix-rank)
    (is (equalp arr '(0 1 2 3 4 5 6 7 8 9)))))

(test tandem-repeat-insertion-sort-empty
  (let ((arr (make-array 0 :element-type 'fixnum)))
    (cl-divsufsort::tandem-repeat-insertion-sort arr 0 0 (make-array 0 :element-type 'fixnum))
    (is (equalp arr '#()))))

(test tandem-repeat-insertion-sort-single
  (let ((arr (make-array 1 :element-type 'fixnum :initial-contents '(0)))
	(suffix-rank (make-array 1 :element-type 'fixnum :initial-contents '(0))))
    (cl-divsufsort::tandem-repeat-insertion-sort arr 0 1 suffix-rank)
    (is (equalp arr '(0)))))

(test tandem-repeat-insertion-sort-nonzero-first
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(0 5 2 8 1 9 3 7 4 6)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))
    (cl-divsufsort::tandem-repeat-insertion-sort arr 1 10 suffix-rank)
    (is (equalp arr '(0 1 2 3 4 5 6 7 8 9)))))

(test tandem-repeat-insertion-sort-non-last-last
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 0 0 0 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(4 1 7 3 9 5 0 0 0 0))))
    (cl-divsufsort::tandem-repeat-insertion-sort arr 0 6 suffix-rank)
    (is (equalp arr '(1 3 5 2 0 8 0 0 0 0)))))
