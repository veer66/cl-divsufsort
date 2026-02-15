(in-package #:cl-divsufsort-tests)

(def-suite* :tandem-repeat-budget-suite :in :cl-divsufsort-suite)

(test tandem-repeat-budget-init
  (let ((budget (cl-divsufsort::make-tandem-repeat-budget 10 100)))
    (cl-divsufsort::tandem-repeat-budget-init budget 10 100)
    (is (= (cl-divsufsort::tandem-repeat-budget-chance budget) 10))
    (is (= (cl-divsufsort::tandem-repeat-budget-remain budget) 100))
    (is (= (cl-divsufsort::tandem-repeat-budget-incval budget) 100))
    (is (= (cl-divsufsort::tandem-repeat-budget-count budget) 0))))

(test tandem-repeat-budget-check-success
  (let ((budget (cl-divsufsort::make-tandem-repeat-budget 10 100)))
    (cl-divsufsort::tandem-repeat-budget-init budget 10 100)
    (is (cl-divsufsort::tandem-repeat-budget-check budget 50))
    (is (= (cl-divsufsort::tandem-repeat-budget-remain budget) 50))
    (is (cl-divsufsort::tandem-repeat-budget-check budget 30))
    (is (= (cl-divsufsort::tandem-repeat-budget-remain budget) 20))))

(test tandem-repeat-budget-check-deplete-remain
  (let ((budget (cl-divsufsort::make-tandem-repeat-budget 10 50)))
    (cl-divsufsort::tandem-repeat-budget-init budget 10 50)
    (is (cl-divsufsort::tandem-repeat-budget-check budget 50))
    (is (= (cl-divsufsort::tandem-repeat-budget-remain budget) 0))
    (is (cl-divsufsort::tandem-repeat-budget-check budget 20))
    (is (= (cl-divsufsort::tandem-repeat-budget-remain budget) 30))
    (is (cl-divsufsort::tandem-repeat-budget-check budget 30))
    (is (= (cl-divsufsort::tandem-repeat-budget-remain budget) 0))))

(test tandem-repeat-budget-check-deplete-chance
  (let ((budget (cl-divsufsort::make-tandem-repeat-budget 2 50)))
    (cl-divsufsort::tandem-repeat-budget-init budget 2 50)
    (is (cl-divsufsort::tandem-repeat-budget-check budget 60))
    (is (= (cl-divsufsort::tandem-repeat-budget-remain budget) 40))
    (is (= (cl-divsufsort::tandem-repeat-budget-chance budget) 1))
    (is (cl-divsufsort::tandem-repeat-budget-check budget 60))
    (is (= (cl-divsufsort::tandem-repeat-budget-remain budget) 30))
    (is (= (cl-divsufsort::tandem-repeat-budget-chance budget) 0))
    (is (null (cl-divsufsort::tandem-repeat-budget-check budget 40)))
    (is (= (cl-divsufsort::tandem-repeat-budget-count budget) 40))))

(test tandem-repeat-budget-large-size-deplete-chance
  (let ((budget (cl-divsufsort::make-tandem-repeat-budget 1 100)))
    (cl-divsufsort::tandem-repeat-budget-init budget 1 100)
    (is (cl-divsufsort::tandem-repeat-budget-check budget 150))
    (is (= (cl-divsufsort::tandem-repeat-budget-remain budget) 50))
    (is (= (cl-divsufsort::tandem-repeat-budget-chance budget) 0))
    (is (null (cl-divsufsort::tandem-repeat-budget-check budget 200)))
    (is (= (cl-divsufsort::tandem-repeat-budget-count budget) 200))))
