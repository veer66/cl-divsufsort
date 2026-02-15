(in-package #:cl-divsufsort-tests)

(def-suite* :tandem-repeat-median5-suite :in :cl-divsufsort-suite)

(test tandem-repeat-median5-basic
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0))))
    (is (= (cl-divsufsort::tandem-repeat-median5 rank 1 4 7 2 5) 7))))

(test tandem-repeat-median5-unsorted
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0))))
    (is (= (cl-divsufsort::tandem-repeat-median5 rank 3 8 1 5 9) 1))))

(test tandem-repeat-median5-sorted
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))
    (is (= (cl-divsufsort::tandem-repeat-median5 rank 1 2 3 4 5) 3))))

(test tandem-repeat-median5-reverse
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(9 8 7 6 5 4 3 2 1 0))))
    (is (= (cl-divsufsort::tandem-repeat-median5 rank 1 2 3 4 5) 3))))

(test tandem-repeat-median5-equal
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0))))
    (is (= (cl-divsufsort::tandem-repeat-median5 rank 3 3 3 3 3) 3))))

