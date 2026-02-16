(in-package #:cl-divsufsort-tests)

(def-suite* :tandem-repeat-intro-sort-suite :in :cl-divsufsort-suite)

(test tandem-repeat-intro-sort-stub
  "Stub test to verify the function exists and can be called"
  (let ((rank (make-array 5 :element-type 'fixnum :initial-contents '(0 1 2 3 4)))
        (arr (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0)))
        (isa (make-array 5 :element-type 'fixnum :initial-contents '(4 3 2 1 0)))
        (budget (cl-divsufsort::make-tandem-repeat-budget 10 10)))
    (is (equalp arr (cl-divsufsort::tandem-repeat-sort rank arr isa 0 5 budget)))))

(test tandem-repeat-intro-sort-empty
  "Test empty array"
  (let ((rank (make-array 0 :element-type 'fixnum))
        (arr (make-array 0 :element-type 'fixnum))
        (isa (make-array 0 :element-type 'fixnum))
        (budget (cl-divsufsort::make-tandem-repeat-budget 10 10)))
    (cl-divsufsort::tandem-repeat-sort rank arr isa 0 0 budget)
    (is (equalp arr (make-array 0 :element-type 'fixnum)))))

(test tandem-repeat-intro-sort-single
  "Test single element"
  (let ((rank (make-array 1 :element-type 'fixnum :initial-contents '(0)))
        (arr (make-array 1 :element-type 'fixnum :initial-contents '(0)))
        (isa (make-array 1 :element-type 'fixnum :initial-contents '(0)))
        (budget (cl-divsufsort::make-tandem-repeat-budget 10 10)))
    (cl-divsufsort::tandem-repeat-sort rank arr isa 0 1 budget)
    (is (equalp arr (make-array 1 :element-type 'fixnum :initial-contents '(0))))))
