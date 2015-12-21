# On the fly computation
[Back to root](https://github.com/C2SM-RCM/claw-language-definition)

---

Sometimes, replacing pre-computed arrays with computation on the fly can
increase the performance. It can reduce the memory access for memory-bound
kernel and exploit some unused resource to perform the computation on the fly.

### Abstraction 1
#### Directive definition
**Local directive**
```fortran
!$claw
```
<!---  Description of the directive --->

###### Options and details

###### Behavior with other directives

###### Limitations

#### Example 1
###### Original code
```fortran
!$claw
```

###### Transformed code
```fortran
! CLAW
```
