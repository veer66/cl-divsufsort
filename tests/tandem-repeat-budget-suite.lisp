(in-package #:cl-divsufsort-tests)

(def-suite* :tandem-repeat-budget-suite :in :cl-divsufsort-suite)

(test tandem-repeat-budget-init
  (let ((budget (cl-divsufsort::make-trbudget 10 100)))
    (cl-divsufsort::trbudget-init budget 10 100)
    (is (= (cl-divsufsort::trbudget-chance budget) 10))
    (is (= (cl-divsufsort::trbudget-remain budget) 100))
    (is (= (cl-divsufsort::trbudget-incval budget) 100))
    (is (= (cl-divsufsort::trbudget-count budget) 0))))

(test tandem-repeat-budget-check-success
  (let ((budget (cl-divsufsort::make-trbudget 10 100)))
    (cl-divsufsort::trbudget-init budget 10 100)
    (is (cl-divsufsort::trbudget-check budget 50))
    (is (= (cl-divsufsort::trbudget-remain budget) 50))
    (is (cl-divsufsort::trbudget-check budget 30))
    (is (= (cl-divsufsort::trbudget-remain budget) 20))))

(test tandem-repeat-budget-check-deplete-remain
  (let ((budget (cl-divsufsort::make-trbudget 10 50)))
    (cl-divsufsort::trbudget-init budget 10 50)
    (is (cl-divsufsort::trbudget-check budget 50))
    (is (= (cl-divsufsort::trbudget-remain budget) 0))
    (is (cl-divsufsort::trbudget-check budget 20))
    (is (= (cl-divsufsort::trbudget-remain budget) 30))
    (is (cl-divsufsort::trbudget-check budget 30))
    (is (= (cl-divsufsort::trbudget-remain budget) 0))))

(test tandem-repeat-budget-check-deplete-chance
  (let ((budget (cl-divsufsort::make-trbudget 2 50)))
    (cl-divsufsort::trbudget-init budget 2 50)
    (is (cl-divsufsort::trbudget-check budget 60))
    (is (= (cl-divsufsort::trbudget-remain budget) 40))
    (is (= (cl-divsufsort::trbudget-chance budget) 1))
    (is (cl-divsufsort::trbudget-check budget 60))
    (is (= (cl-divsufsort::trbudget-remain budget) 30))
    (is (= (cl-divsufsort::trbudget-chance budget) 0))
    (is (null (cl-divsufsort::trbudget-check budget 40)))
    (is (= (cl-divsufsort::trbudget-count budget) 40))))

(test tandem-repeat-budget-large-size-deplete-chance
  (let ((budget (cl-divsufsort::make-trbudget 1 100)))
    (cl-divsufsort::trbudget-init budget 1 100)
    (is (cl-divsufsort::trbudget-check budget 150))
    (is (= (cl-divsufsort::trbudget-remain budget) 50))
    (is (= (cl-divsufsort::trbudget-chance budget) 0))
    (is (null (cl-divsufsort::trbudget-check budget 200)))
    (is (= (cl-divsufsort::trbudget-count budget) 200))))
