# CLAW language definition

This file contains the 1st iteration for the directive language of the CLAW
project

## Transformation on variable

#### Demotion
###### Directive defintion
###### Original code
###### Transformed code







## Transformation on loops

#### Loop interchange
###### Directive defintion
```fortran
!$claw loop-interchange
```

###### Original code
```fortran
!$claw loop-interchange
DO i=1, iend
  DO k=1, kend
    ! loop body here
  ENDDO
ENDDO
```

###### Transformed code
```fortran
! CLAW transformation (loop-interchange i <--> k)
DO i=1, iend
  ! CLAW transformation (loop-interchange i <--> k)
  DO k=1, kend
    ! loop body here
  ENDDO
ENDDO
```



#### Loop fusion
###### Directive defintion
```fortran
!$claw loop-fusion [group(*group_id*:*pos*)]
```

###### Original code
```fortran

DO k=1, iend
  !$claw loop-fusion group(g1:1)
  DO i=1, iend
    ! loop #1 body here
  ENDDO

  !$claw loop-fusion group(g1:2)
  DO i=1, iend
    ! loop #2 body here
  ENDDO

  !$claw loop-fusion group(g2:1)
  DO i=1, jend
    ! loop #3 body here
  ENDDO

  !$claw loop-fusion group(g2:1)
  DO i=1, jend
    ! loop #4 body here
  ENDDO
ENDDO
```

###### Transformed code
```fortran

DO k=1, iend
  ! CLAW transformation (loop-fusion group g1)
  DO i=1, iend
    ! loop #1 body here
    ! loop #2 body here
  ENDDO

  ! CLAW tranformation (loop-fusion group g2)
  DO i=1, jend
    ! loop #3 body here
    ! loop #4 body here
  ENDDO
ENDDO
```
