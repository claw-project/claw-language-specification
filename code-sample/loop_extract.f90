! Simple program to test the loop-interchange directive

PROGRAM LOOP_INTERCHANGE
  CALL clawloop
  CALL clawloop_transformed
END

! Before the transformation
SUBROUTINE clawloop
  INTEGER :: i, j, k
  !$claw loop-interchange (k,i,j)
  DO i=1,4
    DO j=1,3
      DO k=1,2
        PRINT *, 'Iteration i=',i,', j=',j,', k=',k
      END DO
    END DO
  END DO
END

! After the transformation
SUBROUTINE clawloop_transformed
  INTEGER :: i, j, k
  !$claw loop-interchange (k,i,j)
  DO k=1,2
    DO i=1,4
      DO j=1,3
        PRINT *, 'Iteration i=',i,', j=',j,', k=',k
      END DO
    END DO
  END DO
END
