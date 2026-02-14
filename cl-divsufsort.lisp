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

(defmacro define-int-lg-function (name)
  `(defun ,name (value)
     (declare (type fixnum value)
	      (optimize (speed 3) (safety 0) (debug 0) (space 0)))
     (cond ((and (int-lg-check value 56) t) (int-lg-byte value 56))
	   ((and (int-lg-check value 48) t) (int-lg-byte value 48))
	   ((and (int-lg-check value 40) t) (int-lg-byte value 40))
	   ((and (int-lg-check value 32) t) (int-lg-byte value 32))
	   ((and (int-lg-check value 24) t) (int-lg-byte value 24))
	   ((and (int-lg-check value 16) t) (int-lg-byte value 16))
	   ((and (int-lg-check value 8) t) (int-lg-byte value 8))
	   (t (int-lg-byte value 0)))))

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
