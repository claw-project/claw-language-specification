# Transformation on loops
[Back to root](https://github.com/C2SM-RCM/claw-definition)

---

### Loop interchange/reordering
#### Directive definition
<!--- TODO maybe find a way to abstract this concept for the specific climate
case
--->
**Local directive**
```fortran
!$claw loop-interchange [new-order(loop-index-1,loop-index-2,loop-index-3)]
```

Loop reordering is a common transformation applied on loops when adding
parallelization. This transformation is mainly used to improve the data
locality.

For this case, the **loop-interchange** directive allows nested loops to be
reordered.

When two loops are nested, the directive can be used without option. In this
configuration the inner loop is swapped with the outer loop (see example 1).

If the *new-order* option is given, the loops are reordered with the given new
order (see example 2).

###### Variable
* *loop-index-i*: the iteration variable of the loop

###### Behavior with other directives
When the loops to be interchange are decorated with other directives, those
directives stay in place in the code transformation. In other words, they are
not interchange together with the loops (see example 3).

###### Limitations
Currently, the loop-interchange directive is limited to 3 level of loops. More
level of loops can be declared but the transformation is limited to the first 3
level from the directive declaration.

#### Example 1
###### Original code
```fortran
!$claw loop-interchange
DO i=1, iend
  DO k=1, kend
    ! loop body here
  END DO
END DO
```

###### Transformed code
```fortran
! CLAW transformation (loop-interchange i < -- > k)
DO k=1, kend
  DO i=1, iend
    ! loop body here
  END DO
END DO
```

#### Example 2
###### Original code
```fortran
!$claw loop-interchange new-order(k,i,j)
DO i=1, iend     ! loop at depth 0
  DO j=1, jend   ! loop at depth 1
    DO k=1, kend ! loop at depth 2
      ! loop body here
    END DO
  END DO
END DO
```

###### Transformed code
```fortran
! CLAW transformation (loop-interchange new-order(k,i,j))
DO k=1, kend       ! loop at depth 2
  DO i=1, iend     ! loop at depth 0
    DO j=1, jend   ! loop at depth 1
      ! loop body here
    END DO
  END DO
END DO
```

#### Example 3 (behavior with OpenACC or other directives)
###### Original code
```fortran
!$acc parallel
!$acc loop gang
!$claw loop-interchange
DO i=1, iend
  !$acc loop vector
  DO k=1, kend
    ! loop body here
  END DO
END DO
!$acc end parallel
```

###### Transformed code
```fortran
! CLAW transformation (loop-interchange i < -- > k)
!$acc parallel
!$acc loop gang
DO k=1, kend
  !$acc loop vector
  DO i=1, iend
    ! loop body here
  END DO
END DO
!$acc end parallel
```

---


### Loop jamming/fusion
#### Directive definition
**Local directive**
```fortran
!$claw loop-fusion [group(*group_id*)]
```

Loop jamming or fusion is used to merge 2 or more loops. Sometime, the work
performed in a loop is too small to create significant impact on performance
when it is parallelized. Merging some loops together create bigger block
to be parallelized.

The **loop-fusion** directive allows to merge 2 to N loops in a single one. If
no group option is given, all the loops decorated with the directive in the same
block will be merged together as a single group.

All the loop within a group must share the same range.

If the *group* option is given, the loops are merged in-order within the
given group.

###### Variable

* *group_id*: A string label that identify a group of loops to be merged

###### Behavior with other directives

When the loops to be merged are decorated with other directives, only the
directives on the first loop of the merge group are kept in the transformed
code.


#### Example 1 (without *group* option)
###### Original code
```fortran
DO k=1, iend
  !$claw loop-fusion
  DO i=1, iend
    ! loop #1 body here
  END DO

  !$claw loop-fusion
  DO i=1, iend
    ! loop #2 body here
  END DO
END DO
```

###### Transformed code
```fortran
DO k=1, iend
  ! CLAW transformation (loop-fusion same block group)
  DO i=1, iend
    ! loop #1 body here
    ! loop #2 body here
  END DO
END DO
```


#### Example 2 (with *group* option)
###### Original code
```fortran
DO k=1, iend
  !$claw loop-fusion group(g1)
  DO i=1, iend
    ! loop #1 body here
  END DO

  !$claw loop-fusion group(g1)
  DO i=1, iend
    ! loop #2 body here
  END DO

  !$claw loop-fusion group(g2)
  DO i=1, jend
    ! loop #3 body here
  END DO

  !$claw loop-fusion group(g2)
  DO i=1, jend
    ! loop #4 body here
  END DO
END DO
```

###### Transformed code
```fortran
DO k=1, iend
  ! CLAW transformation (loop-fusion group g1)
  DO i=1, iend
    ! loop #1 body here
    ! loop #2 body here
  END DO

  ! CLAW tranformation (loop-fusion group g2)
  DO i=1, jend
    ! loop #3 body here
    ! loop #4 body here
  END DO
END DO
```

#### Example 3 (behavior with OpenACC or other directives)
###### Original code
```fortran
!$acc parallel
!$acc loop gang
DO k=1, iend
  !$acc loop seq
  !$claw loop-fusion
  DO i=1, iend
    ! loop #1 body here
  END DO

  !$acc loop vector
  !$claw loop-fusion
  DO i=1, iend
    ! loop #2 body here
  END DO
END DO
!$acc end parallel
```

###### Transformed code
```fortran
!$acc parallel
!$acc loop gang
DO k=1, iend
  ! CLAW transformation (loop-fusion same block group)
  !$acc loop seq
  DO i=1, iend
    ! loop #1 body here
    ! loop #2 body here
  END DO
END DO
!$acc end parallel
```


### Vector notation to loop
#### Directive definition
**Local directive**
```fortran
!$claw to-loop [acc]
```

###### Options
* *acc*: add the acc loop directive to the generated loop

###### Behavior with other directives
Directives declared before the **to-loop** directive will be kept in the
generated code.

###### Limitations
TODO

#### Example 1 (simple)
###### Original code
```fortran
SUBROUTINE vector_add
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  !$claw to-loop
  vec1(0:i) = vec1(0:i) + 10;
END SUBROUTINE vector_add
```

###### Transformed code
```fortran
SUBROUTINE vector_add
  INTEGER :: claw_i
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  !CLAW transformation vec1(0:i) to Loop
  DO claw_i=0, i
    vec1(claw_i) = vec1(claw_i) + 10;
  END DO
END SUBROUTINE vector_add
```

#### Example 2 (with acc option)
###### Original code
```fortran
SUBROUTINE vector_add
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  !$acc parallel
  !$claw to-loop acc
  vec1(0:i) = vec1(0:i) + 10;

  !$claw to-loop acc
  vec1(0:i) = vec1(0:i) + 1;
  !$acc end parallel
END SUBROUTINE vector_add
```

###### Transformed code
```fortran
SUBROUTINE vector_add
  INTEGER :: claw_i
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  !$acc parallel

  !CLAW transformation vec1(0:i) to Loop
  !$acc loop
  DO claw_i=0, i
    vec1(claw_i) = vec1(claw_i) + 10;
  END DO

  !CLAW transformation vec1(0:i) to Loop
  !$acc loop
  DO claw_i=0, i
    vec1(claw_i) = vec1(claw_i) + 1;
  END DO

  !$acc end parallel
END SUBROUTINE vector_add
```
