# Transformation on loops
[Back to root](../README.md)

---
Transformation on loops are defined by the following directives
* [Loop interchange/reordering](#loop-interchangereordering)
* [Loop jamming/fusion](#loop-jammingfusion)
* [Loop extraction](#loop-extraction)
* [Loop hoisting](#loop-hoisting-draft)


---

### Loop interchange/reordering
#### Directive definition
**Local directive**

<pre>
<code>
!$claw loop-interchange [(<i>induction_var[, induction_var] ...</i>)]
</code>
</pre>

Loop reordering is a common transformation applied on loops when adding
parallelization. This transformation is mainly used to improve the data
locality.

In this case, the `loop-interchange` directive allows nested loops to be
reordered.

When two loops are nested, the directive can be used without option. In this
configuration the inner loop is swapped with the outer loop (see example 1).

If the list option is given, the loops are reordered according to the order
defined in the list (see example 2).

###### Options and details
* *induction_var*: the induction variable of the loop

###### Behavior with other directives
When the loops to be reordered are decorated with additional directives, those
directives stay in place during the code transformation. In other words, they
are not reordered together with the loops (see example 3).

###### Limitations
Currently, the `loop-interchange` directive is limited to 3 level of loops.
More level of loops can be declared but the transformation is limited to the
first 3 levels from the directive declaration.

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
!$claw loop-interchange (k,i,j)
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
! CLAW transformation (loop-interchange (k,i,j))
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
<pre>
<code>
!$claw loop-fusion [group(<i>group_id</i>)] [collapse(<i>n</i>)]
</code>
</pre>

Loop jamming or fusion is used to merge 2 or more loops together. Sometimes, the
work performed in a loop is too small to create significant impact on
performance when it is parallelized. Merging some loops together create bigger
blocks (kernels) to be parallelized.

The `loop-fusion` directive allows to merge 2 to N loops in a single one. If
no `group` option is given, all the loops decorated with the directive in the
same block will be merged together as a single group.

If the `group` option is given, the loops are merged in-order within the
given group.

The `collapse` clause is used to specify how many tightly nested loops are
associated with the `loop-fusion` construct. The argument to the `collapse`
clause must be a constant positive integer expression. If no collapse clause
is present, only the immediately following loop is associated with the
`loop-fusion` construct.

###### Options and details
* *group_id*: A string label that identify a group of loops to be merged
* *n*: A constant positive integer expression

###### Behavior with other directives
When the loops to be merged are decorated with other directives, only the
directives on the first loop of the merge group are kept in the transformed
code.

###### Limitations
All the loop within a group must share the same iteration range. If the
`collapse` clause is used, the loops must share the same iteration range at the
corresponding depth (see example 4).

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

#### Example 4 (without *collapse* option)
###### Original code
```fortran
DO k=1, iend
  !$claw loop-fusion collapse(2)
  DO i=0, iend
    DO j=0, jend
      ! nested loop #1 body here
    END FO
  END DO

  !$claw loop-fusion collapse(2)
  DO i=0, iend
    DO j=0, jend
      ! loop #2 body here
    END DO
  END DO
END DO
```

###### Transformed code
```fortran
DO k=1, iend
  ! CLAW transformation (loop-fusion collapse(2))
  DO i=0, iend
    DO j=0, jend
      ! nested loop #1 body here
      ! nested loop #2 body here
    END DO
  END DO
END DO
```

---

### Loop extraction
#### Directive definition
**Local directive**
<pre>
<code>
!$claw loop-extract range(<i>range</i>) [map(<i>var[,var]...</i>:<i>mapping[,mapping]...</i>) [map(<i>var[,var]...</i>:<i>mapping[,mapping]...</i>)] ...]</i> [fusion [group(<i>group_id</i>)] [parallel] [acc(<i>directives</i>)]]
</code>
</pre>

Loop extraction can be performed on a subroutine call. The loop corresponding
to the defined iteration range is extracted from the subroutine and is wrapped
around the subroutine call. In the transformation, a copy of the subroutine
is created with the corresponding transformation (demotion) for the parameters.


###### Options and details
* `range`: Correspond to the iteration range of the loop to be extracted.
  Notation `i = istart, iend, istep`
* `map`: Define the mapping of variable that are demoted during the loop
  extraction. As seen in the example 1, the two parameters (1 dimensional array)
  are mapped to a scalar with the induction variable _i_.
  * The *var* clause can be defined as two parts variable (e.g. `a/a1`). The
    first part is the function call part and refers to the variable as it is
    defined in the function call. The second part is the function definition
    part and refers to the name of the variable to be mapped as it defined in
    the function declaration. If a *var* is defined as a single part variable,
    the same name is used for both the function call and function definition
    part.
  * The *mapping* clause can be defined as two parts variable (e.g. `i/i1`). The
    first part is the function call part and refers to the mapping variable as
    it is defined in the function call. The second part is the function
    definition part and refers to the name of the mapping variable as it defined
    in the function declaration. If a *mapping* is defined as a single part
    mapping variable, the same name is used for both the function call and
    function definition part.
* `fusion`: Allow the extracted loop to be merged with other loops.
  * Options are identical with the `loop-fusion` directive
* `parallel`: Wrap the extracted loop in a parallel region.
* `acc`: Add the accelerator directives to the extracted loop.

If the directive `loop-extract` is used for more than one call to the same
subroutine, the extraction can generate 1 to N dedicated subroutines.

###### Behavior with other directives
If the loop was decorated with directives prior to its extraction, those
directives are extracted with the loop.

###### Limitations
<!--- TODO --->
```
TODO
```

#### Example 1 (simple)
###### Original code
```fortran
PROGRAM main
  !$claw loop-extract(i=istart,iend) map(value1,value2:i)
  CALL xyz(value1, value2)
END PROGRAM main

SUBROUTINE xyz(value1, value2)
  REAL, INTENT (IN) :: value2(x:y), value2(x:y)

  DO i = istart, iend
    ! some computation with value1(i) and value2(i) here
  END DO
END SUBROUTINE xyz
```

###### Transformed code
```fortran
PROGRAM main
  !CLAW extracted loop
  DO i = istart, iend
    CALL xyz_claw(value1(i), value2(i))
  END DO
END PROGRAM main

SUBROUTINE xyz(value1, value2)
  REAL, INTENT (IN) :: value2(x:y), value2(x:y)

  DO i = istart, iend
    ! some computation with value1(i) and value2(i) here
  END DO
END SUBROUTINE xyz

!CLAW extracted loop new subroutine
SUBROUTINE xyz_claw(value1, value2)
  REAL, INTENT (IN) :: value1, value2
  ! some computation with value1 and value2 here
END SUBROUTINE xyz_claw
```


#### Example 2 (with fusion option)
###### Original code
```fortran
PROGRAM main
  !$claw loop-extract(i=istart,iend) map(value1,value2:i) fusion group(g1)
  CALL xyz(value1, value2)

  !$claw loop-fusion group(g1)
  DO i = istart, iend
    ! some computation here
    print*,'Inside loop', i
  END DO
END PROGRAM main

SUBROUTINE xyz(value1, value2)
  REAL, INTENT (IN) :: value2(x:y), value2(x:y)

  DO i = istart, iend
    ! some computation with value1(i) and value2(i) here
  END DO
END SUBROUTINE xyz
```

###### Transformed code
```fortran
PROGRAM main
  !CLAW extracted loop
  DO i = istart, iend
    CALL xyz_claw(value1(i), value2(i))
    ! some computation here
    print*,'Inside loop', i
  END DO
END PROGRAM main

SUBROUTINE xyz(value1, value2)
  REAL, INTENT (IN) :: value2(x:y), value2(x:y)

  DO i = istart, iend
    ! some computation with value1(i) and value2(i) here
  END DO
END SUBROUTINE xyz

!CLAW extracted loop new subroutine
SUBROUTINE xyz_claw(value1, value2)
  REAL, INTENT (IN) :: value1, value2
  ! some computation with value1 and value2 here
END SUBROUTINE xyz_claw
```

#### Example 3 (advanced mapping)
###### Original code
```fortran
PROGRAM main
  !$claw loop-extract(i=istart,iend) map(value1,value2:i/j)
  CALL xyz(value1, value2)
END PROGRAM main

SUBROUTINE xyz(value1, value2, j)
  INTGER, INTENT(IN) :: j
  REAL  , INTENT(IN) :: value2(x:y), value2(x:y)

  DO i = istart, iend
    ! some computation with value1(j) and value2(j) here
  END DO
END SUBROUTINE xyz
```

###### Transformed code
```fortran
PROGRAM main
  !CLAW extracted loop
  DO i = istart, iend
    CALL xyz_claw(value1(i), value2(i))
  END DO
END PROGRAM main

SUBROUTINE xyz(value1, value2, j)
  INTGER, INTENT(IN) :: j
  REAL  , INTENT(IN) :: value2(x:y), value2(x:y)

  DO i = istart, iend
    ! some computation with value1(j) and value2(j) here
  END DO
END SUBROUTINE xyz

!CLAW extracted loop new subroutine
SUBROUTINE xyz_claw(value1, value2, j)
  INTGER, INTENT(IN) :: j
  REAL, INTENT (IN) :: value1, value2
  ! some computation with value1 and value2 here
END SUBROUTINE xyz_claw
```

---



### Loop hoisting (DRAFT)
#### Directive definition
**Local directive**
<pre>
<code>
!$claw loop-hoist(<i>induction_var[[, induction_var] ...]</i>) [interchange [(<i>induction_var[[, induction_var] ...]</i>)]]
<i>structured block</i>
!$claw end loop-hoist
</code>
</pre>

<!--- TODO insert the array demotion clause --->

The `loop-hoist` directive allows nested loops in a defined structured block to
be merged together and to hoist the beginning of those nested loop just after
the directive declaration. Loops with slightly different lower-bound indexes
are also merged with the addition of an `IF` statement.


###### Options and details
* `interchange`: Allow the group of hoisted loops to be reordered.
  * Options are identical with the `loop-interchange` directive.

###### Behavior with other directives
<!--- TODO --->

###### Limitations



#### Example 1 (simple)
###### Original code
```fortran
!$acc parallel loop gang vector collapse(2)
DO jt=1,jtend
  !$claw loop-hoist(j,i) interchange
  IF ( .TRUE. ) CYCLE
    ! outside loop statement
  END IF
  DO j=1,jend
    DO i=1,iend
      ! first nested loop body
    END DO
  END DO
  DO j=2,jend
    DO i=1,iend
      ! second nested loop body
    END DO
  END DO
  !$claw end loop-hoist
END DO
```

###### Transformed code
```fortran
!$acc parallel loop gang vector collapse(2)
DO jt=1,jtend
  DO i=1,iend
    DO j=1,jend
      IF ( .TRUE. ) CYCLE
        ! outside loop statement
      END IF
      ! first nested loop body
      IF(j>1) THEN
        ! second nested loop body
      END IF
    END DO
  END DO
END DO
```
