(in-package #:cl-divsufsort-tests)

(def-suite :int-lg-suite)

(in-suite :int-lg-suite)

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
		      (floor (log n 2)))))))
