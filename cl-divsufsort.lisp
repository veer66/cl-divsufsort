(in-package cl-divsufsort)

(defvar *lg-table*
  (make-array 256 :initial-contents
	      '(-1 0 1 1 2 2 2 2 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
		5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
		6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
		6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
		7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
		7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
		7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
		7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7)))

(defmacro int-lg-byte (value shift)
  `(+ ,shift (aref *lg-table* (logand (ash ,value (- ,shift)) #xff))))

(defmacro int-lg-check (value shift)
  `(< 0 (logand ,value (ash #xff ,shift))))

(defmacro int-lg-cond (value)
  (append (list 'cond)
	  (loop for shift in '(56 48 40 32 24 16 8)
		collect
		(list (list 'int-lg-check value shift)
		      (list 'int-lg-byte value shift)))
	  (list (list 't (list 'int-lg-byte value 0)))))

(defmacro define-int-lg-function (name)
  `(defun ,name (value)
     (declare (type fixnum value)
	     (optimize (speed 3) (safety 0) (debug 0) (space 0)))
     (int-lg-cond value)))

(define-int-lg-function int-lg)

(defun tandem-repeat-insertion-sort (arr first last suffix-rank)
  (declare (type fixnum first last)
	   (type (simple-array fixnum *) suffix-rank arr)
	   (optimize (speed 3) (safety 0) (debug 0) (space 0)))
  (loop for i fixnum from (1+ first) below last
	do
	(let ((arr-value-i (aref arr i))
	      (j (1- i))
	      (r 0))
	  (loop do (setq r (- (aref suffix-rank arr-value-i)
			      (aref suffix-rank (aref arr j))))
		while (< r 0)
		do (loop do (setf (aref arr (1+ j)) (aref arr j))
			 while (and (>= (decf j) first)
				    (< (aref arr j) 0)))
		when (< j first)
		  do (return))
	  (when (= r 0)
	    (setf (aref arr j) (lognot (aref arr j))))
	  (setf (aref arr (1+ j)) arr-value-i)))
  arr)

(defun tandem-repeat-fix-down (isa-arr sa-arr i size)
  (declare (type fixnum i size)
	   (type (simple-array fixnum *) isa-arr sa-arr)
	   (optimize (speed 3) (safety 0) (debug 0) (space 0)))
  (let ((v (aref sa-arr i))
	(c (aref isa-arr (aref sa-arr i))))
    (loop for j = (the fixnum (1+ (* 2 i)))
	  while (< j size)
	  do (let* ((k j)
		    (d (aref isa-arr (aref sa-arr k)))
		    (k2 (1+ j))
		    (e (and (< k2 size) (aref isa-arr (aref sa-arr k2)))))
	       (when (and e (> e d))
		 (setf k k2)
		 (setf d e))
	       (when (> c d) (return))
	       (setf (aref sa-arr i) (aref sa-arr k))
	       (setf i k)))
    (setf (aref sa-arr i) v)))
