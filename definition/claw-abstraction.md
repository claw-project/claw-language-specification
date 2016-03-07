# CLAW abstraction
[Back to root](../README.md)

---
### K caching (_DEFINITION ON GOING_)
#### Directive definition
**Local directive**
```fortran
!$claw kcache [plus|minus] [<i><value></i>]  
```
<!---  Description of the directive --->
In memory-bound problem, it might be useful to cache some information used
during loop computation.

###### Options and details

###### Behavior with other directives
This directive has no impact with other directives at the moment.

###### Limitations


#### Example 1
###### Original code
```fortran
!$claw kcache minus 1
ztu6(j1,ki3sc) = x * y * z
DO j3 = ki3sc+1, ki3ec
  var1 = x * y - ztu6(j1, j3-1)

  ztu6(j1,j3) = x * y * z + var1
END DO
```

###### Transformed code
```fortran
! CLAW kcache
ztu6_km1 = x * y * z
ztu6(j1,ki3sc) = ztu6_km1
DO j3 = ki3sc+1, ki3ec
  var1 = x * y - ztu6_km1

  ztu6_km1 = x * y * z + var1
  ztu6(j1,j3) = x * y * z + var1
END DO
```
