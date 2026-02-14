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

(defmacro int-lg-lookup (value shift)
  `(+ ,shift (aref *lg-table* (logand (ash ,value (- ,shift)) #xff))))

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
  (cond ((= value 0) -1)
	((> (logand value #xff00000000000000) 0) (+ 56 (aref *lg-table* (logand (ash value -56) #xff))))
	((> (logand value #xff000000000000) 0) (+ 48 (aref *lg-table* (logand (ash value -48) #xff))))
	((> (logand value #xff0000000000) 0) (+ 40 (aref *lg-table* (logand (ash value -40) #xff))))
	((> (logand value #xff00000000) 0) (+ 32 (aref *lg-table* (logand (ash value -32) #xff))))
	((> (logand value #xff000000) 0) (+ 24 (aref *lg-table* (logand (ash value -24) #xff))))
	((> (logand value #xff0000) 0) (+ 16 (aref *lg-table* (logand (ash value -16) #xff))))
	((> (logand value #xff00) 0) (+ 8 (aref *lg-table* (logand (ash value -8) #xff))))
	(t (+ 0 (aref *lg-table* (logand (ash value 0) #xff))))))

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
