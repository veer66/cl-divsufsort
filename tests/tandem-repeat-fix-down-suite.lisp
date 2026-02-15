(in-package #:cl-divsufsort-tests)

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
