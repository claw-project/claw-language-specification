MODULE mo_column

CONTAINS
 SUBROUTINE compute_column ( nz , q , t , nproma )
  INTEGER , INTENT(IN) :: nz
  REAL , INTENT(INOUT) :: t ( : , : )
  REAL , INTENT(INOUT) :: q ( : , : )
  INTEGER :: k
  REAL :: c
  REAL :: d

  INTEGER , INTENT(IN) :: nproma
  INTEGER :: proma


!$acc data present(q,nproma,nz,t)
!$acc parallel private(k,proma,d,c)
!$acc loop
  DO proma = 1 , nproma , 1
   c = 5.345
!$acc loop seq
   DO k = 2 , nz , 1
    t ( proma , k ) = c * k
    d = t ( proma , k ) ** ( 2 )
    q ( proma , k ) = q ( proma , k - 1 ) + t ( proma , k ) * c
   END DO
   q ( proma , nz ) = q ( proma , nz ) * c
  END DO
!$acc end parallel
!$acc end data
 END SUBROUTINE compute_column

END MODULE mo_column

