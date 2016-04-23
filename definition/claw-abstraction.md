# CLAW abstraction
[Back to root](../README.md)

---
### K caching (_DEFINITION ON GOING_)
#### Directive definition
**Local directive**
<pre>
<code>
!$claw kcache [<i>(offset[,offset] ...)</i>]] [[init] | [data(<i>(var[,var] ...)</i>)]] [private]
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

If the _offset_ value is omitted, there are inferred from the dimension of the
variable to be cached and set to 0.

* `offset`:
* `init`:
* `data`:
* `private`: it declares that a copy of each item on the list will be created
for each parallel gang on the accelerator. The list is the one specified on
the `data` clause or inferred with assignment cache.

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

---

### On the fly computation (array access to function call) (_DEFINITION ON GOING_)
**Local directive**
<pre>
<code>
!$claw call <i>array_name</i>=<i>function_call(args)</i>
</code>
</pre>

Sometimes, replacing access to pre-computed arrays with computation on the fly
can increase the performance. It can reduce the memory access for memory-bound
kernel and exploit some unused resource to perform the computation on the fly.


###### Behavior with other directives
This directive has no impact with other directives at the moment.

###### Limitations


#### Example 1
###### Original code
```fortran
DO i = 1,80,1
  DO j = 1,60,1
    !$claw call ztu6=compute_ztu6(j1,j3)

    var1 = x * y - ztu6(j1, j3)
    ! more computation done here

    var5 = y + ztu6(j1, j3)
  END DO
END DO
```

###### Transformed code
```fortran
DO i = 1,80,1
  DO j = 1,60,1
    var1 = x * y - compute_ztu6(j1,j3)
    ! more computation done here

    var5 = y + compute_ztu6(j1,j3)
  END DO
END DO
```
