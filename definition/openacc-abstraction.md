# OpenACC abstraction
[Back to root](https://github.com/C2SM-RCM/claw-definition)
### All present
#### Directive definition
```fortran
!$claw data all-present
```

This directive allows to generate OpenACC present directives for the parameters
of a subroutine.

#### Example 1
###### OpenACC code
```fortran
SUBROUTINE claw(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)
  REAL, INTENT (IN) :: a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p
  !$acc data present(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)
  ! Body of the subroutine
END SUBROUTINE claw
```

###### Original code
```fortran
!$claw data all-present
SUBROUTINE claw(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)
  REAL, INTENT (IN) :: a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p
  ! Body of the subroutine
END SUBROUTINE claw
```

###### Transformed code
```fortran
SUBROUTINE claw(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)
  REAL, INTENT (IN) :: a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p
  ! CLAW transformation data all present
  !$acc data present(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)
  ! Body of the subroutine
END SUBROUTINE claw
```
