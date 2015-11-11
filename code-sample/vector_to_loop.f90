! Simple program to test the loop-fusion directive

PROGRAM VECTOR_LOOP
  CALL claw
  CALL claw_transformed
END

! Before the transformation
SUBROUTINE claw
  INTEGER :: j
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  DO j = 0, i
  		vec1(j) = j
  END DO

  !$claw loop-vector
  vec1(0:i) = vec1(0:i) + 10;

  PRINT*,vec1
END SUBROUTINE claw

! After the transformation
SUBROUTINE claw_transformed
  INTEGER :: claw_i
  INTEGER :: j
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  DO j = 0, i
  		vec1(j) = j
  END DO

  DO claw_i=0, i
    vec1(claw_i) = vec1(claw_i) + 10;
  END DO

  PRINT*,vec1
END
