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

  ! Root call to the parallelized subroutine will be transformed as well. Arrays
  ! q and t will be passed entierly and the do statement will be removed.
  
  !$claw sca forward
  DO p = 1, nproma
    CALL compute_column(nz, q(p,:), t(p,:))
  END DO

  PRINT*,SUM(q)
  PRINT*,SUM(t)
END PROGRAM model
