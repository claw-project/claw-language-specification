MODULE mo_column
  IMPLICIT NONE
CONTAINS
  ! Compute only one column
  SUBROUTINE compute_column(nz, q, t)
    IMPLICIT NONE

    INTEGER, INTENT(IN)   :: nz   ! Size of the array field
    REAL, INTENT(INOUT)   :: t(:) ! Field declared as one column only
    REAL, INTENT(INOUT)   :: q(:) ! Field declared as one column only
    INTEGER :: k                  ! Loop index
    REAL :: c                     ! Coefficient
    REAL :: d                     ! Intermediate variable

    ! CLAW definition
    ! Define the new dimension on which the transformation parallelize the
    ! single column abstraction. In this case, the automatic promotion
    ! deduction will be activated as the data/over clauses are not present.

    !$claw define dimension proma(1:nproma) &
    !$claw sca

    c = 5.345
    DO k = 2, nz
      t(k) = c * k
      d    = t(k)**2
      q(k) = q(k - 1)  + t(k) * c
    END DO
    q(nz) = q(nz) * c
  END SUBROUTINE compute_column
END MODULE mo_column
