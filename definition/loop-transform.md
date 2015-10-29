# Transformation on loops
[Back to root](https://github.com/clementval/claw-definition)
### Loop interchange/reordering
#### Directive defintion
<!--- TODO define a notion of dependency --->
<!--- TODO maybe define a definition of depth instead of a new ordering --->
```fortran
!$claw loop-interchange [new-order(loop-index1,loop-index2,loop-index3,...)]
```

The loop-interchange directive allows loops to be reordered.

#### Example 1
###### Original code
```fortran
!$claw loop-interchange
DO i=1, iend
    DO k=1, kend
      ! loop body here
    ENDDO
  ENDDO
ENDDO
```

###### Transformed code
```fortran
! CLAW transformation (loop-interchange i < -- > k)
DO k=1, kend
  DO i=1, iend
    ! loop body here
  ENDDO
ENDDO
```
#### Example 2
###### Original code
```fortran
!$claw loop-interchange new-order(k,i,j)
DO i=1, iend     ! loop at depth 0
  DO j=1, jend   ! loop at depth 1
    DO k=1, kend ! loop at depth 2
      ! loop body here
    ENDDO
  ENDDO
ENDDO
```

###### Transformed code
```fortran
! CLAW transformation (loop-interchange new-order(k,i,j))
DO k=1, kend       ! loop at depth 2
  DO i=1, iend     ! loop at depth 0
    DO j=1, jend   ! loop at depth 1
      ! loop body here
    ENDDO
  ENDDO
ENDDO
```



### Loop jamming/fusion
#### Directive defintion
```fortran
!$claw loop-fusion [group(*group_id*:*pos*)]
```

The loop-fuson directive allows to fusion 2 to N loops in a single one. If no
group option is given, all the loops decorated with the directive in the same
block will be fusioned together as a single group.

If the *group* option is given, the loops are fusioned within the given group
according to their position.

All the loop within a group must share the same range.

#### Example 1 (without *group* option)
###### Original code
```fortran
DO k=1, iend
  !$claw loop-fusion
  DO i=1, iend
    ! loop #1 body here
  ENDDO

  !$claw loop-fusion
  DO i=1, iend
    ! loop #2 body here
  ENDDO
ENDDO
```

###### Transformed code
```fortran
DO k=1, iend
  ! CLAW transformation (loop-fusion same block group)
  DO i=1, iend
    ! loop #1 body here
    ! loop #2 body here
  ENDDO
ENDDO
```


#### Example 2 (with *group* option)
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
