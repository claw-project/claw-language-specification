# OpenACC abstraction
[Back to root](../README.md)
---

OpenACC abstractions/helpers are defined by the followings directives:
* [Array notation to do statement](#array-notation-to-do-statement)

---


### Array notation to do statement
#### Directive definition
**Local directive**
<pre>
<code>
!$claw array-transform [induction(<i>name</i>)] [fusion [group(<i>group_id</i>)]] [parallel] [acc(<i>[clause [[,] clause]...]</i>)]
<i>array notation assignment(s)</i>
[!$claw end remove]
</code>
</pre>

Computations using the array notation are not suitable to be parallelized with
language like OpenACC. The `array-transform` directive allows to transform those
notation with the corresponding loops which are more suitable for
parallelization.

The goal of this directive is to pass from an array notation assignment like
this:

```Fortran
A(1:n) = A(1+m:n+m) + B(1:n) * C(n+1:n+n)
```

To a do loop statement like this:

```Fortran
DO i=1,n
  A(i) = A(i+m) + B(i) * C(n+i)
END DO
```

If the directive is used as a block directive, the assignments are wrapped in
a single do statement if their induction range match.

```Fortran
A(1:n) = A(1+m:n+m) + B(1:n) * C(n+1:n+n)
B(1:n) = B(1:n) * 0.5
```

To

```Fortran
DO i=1,n
  A(i) = A(i+m) + B(i) * C(n+i)
  B(i) = B(i) * 0.5
END DO
```


###### Options and details
* `induction`: Allow to name the induction variable.
* `fusion`: Allow the extracted loop to be merged with other loops.
  * Options are identical with the `loop-fusion` directive
* `parallel`: Wrap the extracted loop in a parallel region.
* `acc`: Define accelerator clauses that will be applied to the generated loops.


###### Behavior with other directives
Directives declared before the `array-transform` directive will be kept in the
generated code.

###### Limitations
<!--- TODO --->
```
TODO
How to convert when several vector are involved --> nested loops.
```

#### Example 1 (simple)
###### Original code
```fortran
SUBROUTINE vector_add
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  !$claw array-transform
  vec1(0:i) = vec1(0:i) + 10;
END SUBROUTINE vector_add
```

###### Transformed code
```fortran
SUBROUTINE vector_add
  INTEGER :: claw_i
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  ! CLAW transformation array notation to do loop
  DO claw_i = 0, i
    vec1(claw_i) = vec1(claw_i) + 10;
  END DO
END SUBROUTINE vector_add
```

#### Example 2 (with induction and acc option)
###### Original code
```fortran
SUBROUTINE vector_add
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  !$acc parallel
  !$claw array-transform induction(myinduc) acc(loop)
  vec1(0:i) = vec1(0:i) + 10;

  !$claw array-transform acc(loop)
  vec1(0:i) = vec1(0:i) + 1;
  !$acc end parallel
END SUBROUTINE vector_add
```

###### Transformed code
```fortran
SUBROUTINE vector_add
  INTEGER :: claw_i
  INTEGER :: myinduc
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1

  !$acc parallel

  ! CLAW transformation array notation vec1(0:i) to do loop
  !$acc loop
  DO myinduc = 0, i
    vec1(myinduc) = vec1(myinduc) + 10;
  END DO

  ! CLAW transformation array notation vec1(0:i) to do loop
  !$acc loop
  DO claw_i = 0, i
    vec1(claw_i) = vec1(claw_i) + 1;
  END DO

  !$acc end parallel
END SUBROUTINE vector_add
```

#### Example 3 (with fusion option)
###### Original code
```fortran
SUBROUTINE vector_add
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1
  INTEGER, DIMENSION(0:9) :: vec2

  !$claw array-transform fusion
  vec1(0:i) = vec1(0:i) + 10;

  !$claw array-transform fusion
  vec2(0:i) = vec2(0:i) + 1;
END SUBROUTINE vector_add
```

###### Transformed code
```fortran
SUBROUTINE vector_add
  INTEGER :: claw_i
  INTEGER :: i = 10
  INTEGER, DIMENSION(0:9) :: vec1
  INTEGER, DIMENSION(0:9) :: vec2

  ! CLAW transformation array notation vec1(0:i) to do loop
  ! CLAW transformation array notation vec2(0:i) to do loop
  ! CLAW transformation fusion
  DO claw_i=0, i
    vec1(claw_i) = vec1(claw_i) + 10;
    vec2(claw_i) = vec2(claw_i) + 1;
  END DO
END SUBROUTINE vector_add
```

### Example 4 (with 2-dimensional arrays)
##### Original code
```fortran
SUBROUTINE vector_add
INTEGER :: i = 10
INTEGER, DIMENSION(0:10,0:10) :: vec1
INTEGER, DIMENSION(0:10,0:10) :: vec2

vec1(0:i,0:i) = 0;
vec2(0:i,0:i) = 100;

!$claw array-transform
vec1(0:i,0:i) = vec2(0:i,0:i) + 10
END SUBROUTINE vector_add
```

##### Transformed code
```fortran
SUBROUTINE vector_add
INTEGER :: i = 10
INTEGER, DIMENSION(0:10,0:10) :: vec1
INTEGER, DIMENSION(0:10,0:10) :: vec2

vec1(0:i,0:i) = 0;
vec2(0:i,0:i) = 100;

DO claw_i = 0, i, 1
  DO claw_j = 0, i, 1
    vec1(claw_i,claw_j) = vec2(claw_i, claw_j) + 10    
  END DO
END DO
END SUBROUTINE vector_add
```
