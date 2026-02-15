(in-package #:cl-divsufsort-tests)

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
