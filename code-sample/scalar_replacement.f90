! Simple program using the scalar directive

PROGRAM SCALAR_REPLACEMENT
  CALL claw
  CALL claw_transformed
END

SUBROUTINE claw
  INTEGER :: i, j
  INTEGER :: a(10), b(10)
  a = 0;

  DO i=1,10
    b(i) = i;
  END DO

  DO i=1,10
    !$claw scalar t=a(i)
    DO j=1,10
      a(i) = a(i) + b(j)
    END DO
  END DO

  PRINT*,a
END


SUBROUTINE claw_transformed
  INTEGER :: i, j
  INTEGER :: t
  INTEGER :: a(10), b(10)
  a = 0;

  DO i=1,10
    b(i) = i;
  END DO

  DO i=1,10
    !CLAW transformation add scalar t=a(i)
    t = a(i)
    DO j=1,10
      t = t + b(j)
    END DO
    !CLAW transformation update from scalar t=a(i) after loop
    a(i) = t
  END DO

  PRINT*,a
END
