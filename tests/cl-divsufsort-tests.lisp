(in-package #:cl-divsufsort-tests)

(test int-lg-lookup
  (is (= (cl-divsufsort::int-lg-lookup 0 0) -1))
  (is (= (cl-divsufsort::int-lg-lookup 1 0) 0))
  (is (= (cl-divsufsort::int-lg-lookup 2 0) 1))
  (is (= (cl-divsufsort::int-lg-lookup 3 0) 1))
  (is (= (cl-divsufsort::int-lg-lookup 4 0) 2))
  (is (= (cl-divsufsort::int-lg-lookup 7 0) 2))
  (is (= (cl-divsufsort::int-lg-lookup 8 0) 3))
  (is (= (cl-divsufsort::int-lg-lookup 15 0) 3))
  (is (= (cl-divsufsort::int-lg-lookup 16 0) 4))
  (is (= (cl-divsufsort::int-lg-lookup 255 0) 7))
  (is (= (cl-divsufsort::int-lg-lookup 256 0) -1)))

(test int-lg-small-values
  (dotimes (i 1000)
    (let* ((expected (if (= i 0) -1 (1- (integer-length i))))
           (result (cl-divsufsort:int-lg i)))
      (is (= result expected)))))

(test int-lg-boundaries
  (let ((boundaries '(1 2 3 4 7 8 15 16 31 32 63 64 127 128 255 256 511 512
                     1023 1024 2047 2048 4095 4096 8191 8192 16383 16384
                     32767 32768 65535 65536 131071 131072 262143 262144
                     524287 524288 1048575 1048576 2097151 2097152 4194303
                     4194304 8388607 8388608 16777215 16777216 33554431
                     33554432 67108863 67108864 134217727 134217728
                     268435455 268435456 536870911 536870912 1073741823
                     1073741824 2147483647)))
    (dolist (val boundaries)
      (let* ((expected (if (= val 0) -1 (1- (integer-length val))))
             (result (cl-divsufsort:int-lg val)))
        (is (= result expected))))))

(test int-lg-large-values
  (let ((values '(1099511627775 2199023255551 4398046511103 8796093022207
                  17592186044415 35184372088831 70368744177663 140737488355327
                  281474976710655 562949953421311 1125899906842623
                  2251799813685247 4503599627370495 9007199254740991
                  18014398509481983 36028797018963967 72057594037927935
                  144115188075855871 288230376151711743 576460752303423487
                  1152921504606846975 2305843009213693951 4611686018427387903
                  2305843009213693951)))
    (dolist (val values)
       (let* ((expected (if (= val 0) -1 (1- (integer-length val))))
             (result (cl-divsufsort:int-lg val)))
        (is (= result expected))))))

