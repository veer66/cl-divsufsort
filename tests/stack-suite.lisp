(in-package #:cl-divsufsort-tests)

(def-suite* :stack-suite :in :cl-divsufsort-suite)

(test stack-push-pop
  (let ((stack (cl-divsufsort::make-stack)))
    (cl-divsufsort::stack-push stack 1 2 3 4)
    (multiple-value-bind (a b c d) (cl-divsufsort::stack-pop stack)
      (is (= a 1))
      (is (= b 2))
      (is (= c 3))
      (is (= d 4)))))

(test stack-push-pop-with-e
  (let ((stack (cl-divsufsort::make-stack)))
    (cl-divsufsort::stack-push stack 1 2 3 4 5)
    (multiple-value-bind (a b c d e) (cl-divsufsort::stack-pop stack)
      (is (= a 1))
      (is (= b 2))
      (is (= c 3))
      (is (= d 4))
      (is (= e 5)))))

(test stack-multiple-push-pop
  (let ((stack (cl-divsufsort::make-stack)))
    (cl-divsufsort::stack-push stack 1 2 3 4)
    (cl-divsufsort::stack-push stack 5 6 7 8)
    (cl-divsufsort::stack-push stack 9 10 11 12)
    (multiple-value-bind (a b c d) (cl-divsufsort::stack-pop stack)
      (is (= a 9))
      (is (= b 10))
      (is (= c 11))
      (is (= d 12)))
    (multiple-value-bind (a b c d) (cl-divsufsort::stack-pop stack)
      (is (= a 5))
      (is (= b 6))
      (is (= c 7))
      (is (= d 8)))
    (multiple-value-bind (a b c d) (cl-divsufsort::stack-pop stack)
      (is (= a 1))
      (is (= b 2))
      (is (= c 3))
      (is (= d 4)))))

(test stack-empty-p
  (let ((stack (cl-divsufsort::make-stack)))
    (is (cl-divsufsort::stack-empty-p stack))
    (cl-divsufsort::stack-push stack 1 2 3 4)
    (is (not (cl-divsufsort::stack-empty-p stack)))
    (cl-divsufsort::stack-pop stack)
    (is (cl-divsufsort::stack-empty-p stack))))

(test stack-size-limit
  (let ((stack (cl-divsufsort::make-stack)))
    (dotimes (i +stack-size+)
      (cl-divsufsort::stack-push stack i (1+ i) (+ i 2) (+ i 3)))
    (is (cl-divsufsort::stack-empty-p stack))))
