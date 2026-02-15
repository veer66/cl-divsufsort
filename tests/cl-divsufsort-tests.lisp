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

(def-suite* :tandem-repeat-fix-down-suite :in :cl-divsufsort-suite)

(test tandem-repeat-fix-down-root
  (let ((suffix-array (make-array 7 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6)))
	(suffix-rank (make-array 7 :element-type 'fixnum :initial-contents '(3 1 4 0 2 5 6))))
    (cl-divsufsort::tandem-repeat-fix-down suffix-rank suffix-array 0 7)
    (is (equalp suffix-array (make-array 7 :element-type 'fixnum :initial-contents '(2 1 6 3 4 5 0))))))

(test tandem-repeat-fix-down-no-swap
  (let ((suffix-array (make-array 5 :element-type 'fixnum :initial-contents '(2 0 1 3 4)))
	(suffix-rank (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4))))
    (cl-divsufsort::tandem-repeat-fix-down suffix-rank suffix-array 0 5)
    (is (equalp suffix-array (make-array 5 :element-type 'fixnum :initial-contents '(2 0 1 3 4))))))

(test tandem-repeat-fix-down-left-child
  (let ((suffix-array (make-array 5 :element-type 'fixnum :initial-contents '(0 2 1 3 4)))
	(suffix-rank (make-array 5 :element-type 'fixnum :initial-contents '(2 3 0 4 5))))
    (cl-divsufsort::tandem-repeat-fix-down suffix-rank suffix-array 0 5)
    (is (equalp suffix-array (make-array 5 :element-type 'fixnum :initial-contents '(1 2 0 3 4))))))

(test tandem-repeat-fix-down-right-child
  (let ((suffix-array (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(suffix-rank (make-array 5 :element-type 'fixnum :initial-contents '(3 2 0 4 5))))
    (cl-divsufsort::tandem-repeat-fix-down suffix-rank suffix-array 0 5)
    (is (equalp suffix-array (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4))))))

(test tandem-repeat-fix-down-leaf
  (let ((suffix-array (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
	(suffix-rank (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4))))
    (cl-divsufsort::tandem-repeat-fix-down suffix-rank suffix-array 2 5)
    (is (equalp suffix-array (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4))))))

(test tandem-repeat-fix-down-single
  (let ((suffix-array (make-array 1 :element-type 'fixnum :initial-contents '(0)))
	(suffix-rank (make-array 1 :element-type 'fixnum :initial-contents '(0))))
    (cl-divsufsort::tandem-repeat-fix-down suffix-rank suffix-array 0 1)
    (is (equalp suffix-array (make-array 1 :element-type 'fixnum :initial-contents '(0))))))

(test tandem-repeat-fix-down-heapify
  (let ((suffix-array (make-array 7 :element-type 'fixnum :initial-contents '(0 2 1 4 5 3 6)))
	(suffix-rank (make-array 7 :element-type 'fixnum :initial-contents '(2 3 0 5 6 4 1))))
    (cl-divsufsort::tandem-repeat-fix-down suffix-rank suffix-array 1 7)
    (is (equalp suffix-array (make-array 7 :element-type 'fixnum :initial-contents '(0 4 1 2 5 3 6))))))

(test tandem-repeat-fix-down-subtree
  (let ((suffix-array (make-array 7 :element-type 'fixnum :initial-contents '(0 3 1 4 2 5 6)))
	(suffix-rank (make-array 7 :element-type 'fixnum :initial-contents '(3 1 4 0 2 5 6))))
    (cl-divsufsort::tandem-repeat-fix-down suffix-rank suffix-array 0 4)
    (is (equalp suffix-array (make-array 7 :element-type 'fixnum :initial-contents '(0 3 1 4 2 5 6))))))

(def-suite* :tandem-repeat-heap-sort-suite :in :cl-divsufsort-suite)

(test tandem-repeat-heap-sort-unsorted
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))
    (cl-divsufsort::tandem-repeat-heap-sort suffix-rank arr 10)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))))

(test tandem-repeat-heap-sort-reverse
  (let ((arr (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0)))
	(suffix-rank (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0))))
    (cl-divsufsort::tandem-repeat-heap-sort suffix-rank arr 5)
    (is (equalp arr (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0))))))

(test tandem-repeat-heap-sort-small
  (let ((arr (make-array 3 :element-type 'fixnum :initial-contents '(2 1 0)))
	(suffix-rank (make-array 3 :element-type 'fixnum :initial-contents '(2 1 0))))
    (cl-divsufsort::tandem-repeat-heap-sort suffix-rank arr 3)
    (is (equalp arr (make-array 3 :element-type 'fixnum :initial-contents '(2 1 0))))))

(test tandem-repeat-heap-sort-descending-rank
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(9 8 7 6 5 4 3 2 1 0))))
    (cl-divsufsort::tandem-repeat-heap-sort suffix-rank arr 10)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(9 8 7 6 5 4 3 2 1 0))))))

(test tandem-repeat-heap-sort-equal-rank
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(0 0 0 0 0 0 0 0 0 0))))
    (cl-divsufsort::tandem-repeat-heap-sort suffix-rank arr 10)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(3 9 8 7 6 0 5 2 1 4))))))

(test tandem-repeat-heap-sort-empty
  (let ((arr (make-array 0 :element-type 'fixnum))
	(suffix-rank (make-array 0 :element-type 'fixnum)))
    (cl-divsufsort::tandem-repeat-heap-sort suffix-rank arr 0)
    (is (equalp arr (make-array 0 :element-type 'fixnum)))))

(test tandem-repeat-heap-sort-single
  (let ((arr (make-array 1 :element-type 'fixnum :initial-contents '(0)))
	(suffix-rank (make-array 1 :element-type 'fixnum :initial-contents '(0))))
    (cl-divsufsort::tandem-repeat-heap-sort suffix-rank arr 1)
    (is (equalp arr (make-array 1 :element-type 'fixnum :initial-contents '(0))))))

(test tandem-repeat-heap-sort-nonzero-first
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(0 5 2 8 1 9 3 7 4 6)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))
    (cl-divsufsort::tandem-repeat-heap-sort suffix-rank arr 10)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))))

(test tandem-repeat-heap-sort-non-last-last
  (let ((arr (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 0 0 0 0)))
	(suffix-rank (make-array 10 :element-type 'fixnum :initial-contents '(4 1 7 3 9 5 0 0 0 0))))
    (cl-divsufsort::tandem-repeat-heap-sort suffix-rank arr 6)
    (is (equalp arr (make-array 10 :element-type 'fixnum :initial-contents '(9 8 1 3 5 2 0 0 0 0))))))

(def-suite* :tandem-repeat-median3-suite :in :cl-divsufsort-suite)

(test tandem-repeat-median3-basic
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0))))
    (is (= (cl-divsufsort::tandem-repeat-median3 rank 1 4 7) 7))))

(test tandem-repeat-median3-first
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0))))
    (is (= (cl-divsufsort::tandem-repeat-median3 rank 1 7 4) 7))))

(test tandem-repeat-median3-third
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0))))
    (is (= (cl-divsufsort::tandem-repeat-median3 rank 7 1 4) 7))))

(test tandem-repeat-median3-equal
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0))))
    (is (= (cl-divsufsort::tandem-repeat-median3 rank 1 1 1) 1))))

