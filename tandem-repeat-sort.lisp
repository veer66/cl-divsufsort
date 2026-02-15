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

(defun tandem-repeat-insertion-sort (suffix-rank suffix-array start end)
  (declare (type fixnum start end)
	   (type (simple-array fixnum *) suffix-rank suffix-array)
	   (optimize (speed 3) (safety 0) (debug 0) (space 0)))
  (loop for i fixnum from (1+ start) below end
	do
	(let ((arr-value-i (aref suffix-array i))
	      (j (1- i))
	      (r 0))
	  (loop do (setq r (- (aref suffix-rank arr-value-i)
			      (aref suffix-rank (aref suffix-array j))))
		while (< r 0)
		do (loop do (setf (aref suffix-array (1+ j)) (aref suffix-array j))
			 while (and (>= (decf j) start)
				    (< (aref suffix-array j) 0)))
		when (< j start)
		  do (return))
	  (when (= r 0)
	    (setf (aref suffix-array j) (lognot (aref suffix-array j))))
	  (setf (aref suffix-array (1+ j)) arr-value-i)))
  suffix-array)

(defun tandem-repeat-fix-down (suffix-rank suffix-array i size)
  (declare (type fixnum i size)
	   (type (simple-array fixnum *) suffix-rank suffix-array)
	   (optimize (speed 3) (safety 0) (debug 0) (space 0)))
  (let ((v (aref suffix-array i))
	(c (aref suffix-rank (aref suffix-array i))))
    (loop for j = (the fixnum (1+ (* 2 i)))
	  while (< j size)
	  do (let* ((k j)
		    (d (aref suffix-rank (aref suffix-array k)))
		    (k2 (1+ j))
		    (e (and (< k2 size) (aref suffix-rank (aref suffix-array k2)))))
	       (when (and e (> e d))
		 (setf k k2)
		 (setf d e))
	       (when (> c d) (return))
	       (setf (aref suffix-array i) (aref suffix-array k))
	       (setf i k)))
    (setf (aref suffix-array i) v)))

(defun tandem-repeat-heap-sort (suffix-rank suffix-array size)
  (declare (type fixnum size)
	   (type (simple-array fixnum *) suffix-rank suffix-array)
	   (optimize (speed 3) (safety 0) (debug 0) (space 0)))
  (when (< size 2) (return-from tandem-repeat-heap-sort suffix-array))
  (let ((m size)
	(temp))
    (when (zerop (mod size 2))
      (decf m)
      (when (< (aref suffix-rank (aref suffix-array (floor m 2)))
	       (aref suffix-rank (aref suffix-array m)))
	(setf temp (aref suffix-array m))
	(setf (aref suffix-array m) (aref suffix-array (floor m 2)))
	(setf (aref suffix-array (floor m 2)) temp)))
    (loop for i from (1- (floor m 2)) downto 0
	  do (tandem-repeat-fix-down suffix-rank suffix-array i m))
    (when (zerop (mod size 2))
      (setf temp (aref suffix-array 0))
      (setf (aref suffix-array 0) (aref suffix-array m))
      (setf (aref suffix-array m) temp)
      (tandem-repeat-fix-down suffix-rank suffix-array 0 m))
    (loop for i from (1- m) downto 1
	  do (setf temp (aref suffix-array 0))
	     (setf (aref suffix-array 0) (aref suffix-array i))
	     (tandem-repeat-fix-down suffix-rank suffix-array 0 i)
	     (setf (aref suffix-array i) temp)))
  suffix-array)

(defun tandem-repeat-median3 (suffix-rank v1 v2 v3)
  (declare (type (simple-array fixnum *) suffix-rank)
	   (type fixnum v1 v2 v3)
	   (optimize (speed 3) (safety 0) (debug 0) (space 0)))
  (let ((r1 (aref suffix-rank v1))
	(r2 (aref suffix-rank v2))
	(r3 (aref suffix-rank v3)))
    (when (> r1 r2)
      (rotatef v1 v2)
      (rotatef r1 r2))
    (when (> r2 r3)
      (if (> r1 r3)
	  (return-from tandem-repeat-median3 v1)
	  (return-from tandem-repeat-median3 v3)))
    v2))

