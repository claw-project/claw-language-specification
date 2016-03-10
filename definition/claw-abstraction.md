# CLAW abstraction
[Back to root](../README.md)

---
### K caching (_DEFINITION ON GOING_)
#### Directive definition
**Local directive**
<pre>
<code>
!$claw kcache [<i>(offset[,offset] ...)</i>]]
</code>
</pre>

<!---  Description of the directive --->
In memory-bound problem, it might be useful to cache array values used several
times during loop computation.

<!--- TODO the directive is missing an information to know which index in the
array indexes is touched by the plus/minus offset --->

###### Options and details
The `kcache` directive must be place just before an assignment of an array
indexed variable. It will cache the corresponding assigned value and update
the array index in the following loop body according to the given plus/minus
offset.

If the _offset_ value is omitted, it is set to 0 by default.

###### Behavior with other directives
This directive has no impact with other directives at the moment.

###### Limitations


#### Example 1
###### Original code
```fortran
!$claw kcache 0 -1
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
