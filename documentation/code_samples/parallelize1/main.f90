PROGRAM model
  USE mo_column, ONLY: compute_column

  REAL, DIMENSION(20,60) :: q, t  ! Fields as declared in the whole model
  INTEGER :: nproma, nz           ! Size of array fields
  INTEGER :: p                    ! Loop index

  nproma = 20
  nz = 60

  DO p = 1, nproma
    q(p,1) = 0.0
    t(p,1) = 0.0
  END DO

#ifdef _CLAW
  CALL compute_column(nz, q, t, nproma)
#else
  DO p = 1, nproma
    CALL compute_column(nz, q(p,:), t(p,:))
  END DO
#endif

  PRINT*,SUM(q)
  PRINT*,SUM(t)
END PROGRAM model
