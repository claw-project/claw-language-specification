## Transformation on variable
<!--- TODO all reflexion and definition --->
#### Demotion
##### Directive defintion
```fortran
!$claw demote(variable_list) dim(dimension_from,dimension_to)
```

##### Example 1
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
