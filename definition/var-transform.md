# Transformation on variable
<!--- TODO all reflexion and definition --->
[Back to root](https://github.com/C2SM-RCM/claw-language-definition)

---

### Demotion/promotion of variable

For the moment, those notions are part of the loop extraction directive.

--> [Loop extraction](https://github.com/C2SM-RCM/claw-language-definition/blob/master/definition/loop-transform.md#loop-extraction)

<!---
TODO maybe remove all of this if we do not see the point to have this directive

Notion moved to the loop-extract directive. If we see advantage to have this
notion as a standalone, we can bring this back.


### Demotion
#### Directive definition
TODO think again this problematic the directive should include a notion of
loop-extraction/creation with an iteration range
include a notion of loop-fusion in it. The resulting loop-extraction/creation
can be then merge with loops on the same level

**Local directive**
```fortran
!$claw demote(variable_list) dim(dimension_from,dimension_to)
```

#### Example 1
###### Original code
```fortran
SUBROUTINE xyz(value1, value2)
  REAL, INTENT (IN) :: value2(x:y), value2(x:y)

  DO i = 0, iend
    ! some computation with value1(i) here
  END DO
END SUBROUTINE xyz

!$claw demote(value1, value2) (1d, 0d)
CALL xyz(value1, value2)
```

###### Transformed code
```fortran
!CLAW transformation (demotion of variable (value1, value2) (1d,0d))
SUBROUTINE xyz_claw(value1_claw, value2_claw)
  REAL, INTENT (IN) :: value1_claw, value2_claw
  ! some computation with value here
END SUBROUTINE

!CLAW transformation (demotion of variable (value1, value2) (1d,0d))
DO i = 0, iend
  CALL xyz_claw(value1_claw(i), value2_claw(i))
END DO
```
--->

### Scalar replacement
#### Directive definition
**Local directive**
```fortran
!$claw scalar scalar_var=value
```

#### Example 1
This example is really simple and will probably be handle perfectly by standard
compiler. This much simplicity is used for the sake of comprehension of the
directive.
###### Original code
```fortran
DO i = 1, 10
  ! a(i) can be left in a register throughout the loop
  !$claw scalar t=a(i)
  DO j = 1, 10
    a(i) = a(i) + b(j)
  END DO
END DO
```

###### Transformed code
```fortran
DO i = 1, 10
  !CLAW transformation add scalar t=a(i)
  t = a(i)
  DO j = 1, 10
    t = t + b(j)
  END DO
  !CLAW transformation update from scalar t=a(i)
  a(i) = t
END DO
```
