# CLAW language specification v0.1

#### General information about the CLAW language
The directives are either local or global.

* Local directive: those directives have a limited impact on a local block of
code (for example, only in a subroutine)
* Global directive: those directives can have an impact on the whole
application.


This language is separated in the followings sections:
* [CLAW abstraction](./definition/claw-abstraction.md)
  (specific abstraction for climate system modeling build on the top of other
  directives)
* [Loop transformation](./definition/loop-transform.md)
  * loop fusion
  * loop interchange/reordering
  * loop extraction
* [Utilities](./definition/utilities.md)

##### Line continuation
CLAW directives can be defined on several line. The syntax is described in the
listing below:

```Fortran
!$claw directive options &
!$claw options
```


##### Interpretation order of the CLAW directives
The claw directives can be combined together. For example, loop-fusion and
loop-interchange can be used together in a group of nested loops.

The interpretation order of the directives is the following:

1. remove
2. loop-extract
3. loop-fusion
4. loop-interchange

Users must be aware that directives transformation are applied sequentially and
therefore, a transformation can be performed on already transformed code.
