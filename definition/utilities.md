# Utilities directive
[Back to root](https://github.com/C2SM-RCM/claw-language-definition)

---

### Remove
#### Directive definition
**Local directive**
```fortran
!$claw remove
<i>structured block</i>
!$claw end remove
```
<!---  Description of the directive --->

###### Options and details
If the directive is directly followed by a structured block (`IF` or `DO`), the
end directive is not mandatory (see `Example 1`). In any other cases, the end
directive is mandatory.

###### Behavior with other directives
None

###### Limitations
None

#### Example 1
###### Original code
```fortran
DO k=1, iend
  DO i=1, iend
    ! loop #1 body here
  END DO

  $claw remove
  IF (k > 1)
    PRINT*, k
  END IF

  DO i=1, iend
    ! loop #2 body here
  END DO
END DO
```

###### Transformed code
```fortran
DO k=1, iend
  DO i=1, iend
    ! loop #1 body here
  END DO

  DO i=1, iend
    ! loop #2 body here
  END DO
END DO
```


#### Example 2
###### Original code
```fortran
DO k=1, iend
  DO i=1, iend
    ! loop #1 body here
  END DO

  $claw remove
  PRINT*, k
  PRINT*, k+1
  $claw end remove

  DO i=1, iend
    ! loop #2 body here
  END DO
END DO
```

###### Transformed code
```fortran
DO k=1, iend
  DO i=1, iend
    ! loop #1 body here
  END DO

  DO i=1, iend
    ! loop #2 body here
  END DO
END DO
```
