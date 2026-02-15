(in-package #:cl-divsufsort-tests)

(def-suite* :tandem-repeat-pivot-suite :in :cl-divsufsort-suite)

(test tandem-repeat-pivot-small
  (let ((rank (make-array 10 :element-type 'fixnum :initial-contents '(5 2 8 1 9 3 7 4 6 0)))
        (arr (make-array 10 :element-type 'fixnum :initial-contents '(0 1 2 3 4 5 6 7 8 9))))
    (let ((p (cl-divsufsort::tandem-repeat-pivot rank arr 0 10)))
      (is (= (aref arr p) 5)))))

(test tandem-repeat-pivot-medium
  (let ((rank (make-array 20 :element-type 'fixnum :initial-contents 
                          '(10 5 15 3 18 7 12 1 19 9 14 4 17 6 11 2 16 8 13 0)))
        (arr (make-array 20 :element-type 'fixnum :initial-contents 
                         '(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19))))
    (let ((p (cl-divsufsort::tandem-repeat-pivot rank arr 0 20)))
      (is (<= 0 p 19)))))

(test tandem-repeat-pivot-large
  (let ((rank (make-array 100 :element-type 'fixnum :initial-contents 
                          (loop for i from 0 below 100 collect (mod i 10))))
        (arr (make-array 100 :element-type 'fixnum :initial-contents 
                         (loop for i from 0 below 100 collect i))))
    (let ((p (cl-divsufsort::tandem-repeat-pivot rank arr 0 100)))
      (is (<= 0 p 99)))))
