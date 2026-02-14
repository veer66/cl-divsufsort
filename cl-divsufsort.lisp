(in-package cl-divsufsort)

(defconstant +lg-table+
  (make-array 256 :initial-contents
	      '(-1 0 1 1 2 2 2 2 3 3 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4
		5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5
		6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
		6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6
		7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
		7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
		7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7
		7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7)))

(defmacro int-lg-lookup (value shift)
  `(+ ,shift (aref +lg-table+ (logand (ash ,value (- ,shift)) #xff))))

(defmacro high-int-lg (value shift)
  `(if (= (ash ,value (- ,shift)) 0)
       (int-lg-lookup ,value ,shift)
       (int-lg-lookup ,value (- ,shift 8))))

(defmacro low-int-lg (value shift)
  `(if (= (logand ,value (ash #xff ,shift)) 0)
       (int-lg-lookup ,value ,shift)
       (int-lg-lookup ,value (- 8 ,shift))))

(defun int-lg (value)
  (declare (type fixnum value)
	   (optimize (speed 3) (safety 0) (debug 0) (space 0)))
  (if (= (ash value -32) 0)
      (if (= (ash value (- 48)) 0)
	  (high-int-lg value 56)
	  (high-int-lg value 48))
      (if (= (logand value #xffff0000) 0)
	  (low-int-lg value 24)
	  (low-int-lg value 8))))

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

(disassemble 'tandem-repeat-insertion-sort)
