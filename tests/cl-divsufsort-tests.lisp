(in-package #:cl-divsufsort-tests)

(def-suite :int-lg-suite)

(in-suite :int-lg-suite)

(test test-kaka
  (loop for n in '(1 7)
	do
	   (is (= (cl-divsufsort:int-lg n)
		  (ceiling (log n))))))
