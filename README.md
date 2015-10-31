# CLAW language definition

*CURRENTLY IN CONSTRUCTION*

This reposition contains the draft of the directive language of the CLAW
project

CLAW is a directive language. The directive are either local or global directive.

* Local directive: those directives have a limited impact on a local block of
code (for example, only in a subroutine)
* Global directive: those directives can have an impact on the whole
application.


This language is separated in the followings sections:

* [Loop transformation](https://github.com/clementval/claw-definition/blob/master/definition/loop-transform.md) (loop fusion, loop interchange/reordering)
* [Variable transformation](https://github.com/clementval/claw-definition/blob/master/definition/var-transform.md) (promotion/demtion, scalar replacement)
* [OpenACC abstraction](https://github.com/clementval/claw-definition/blob/master/definition/openacc-abstraction.md)
* *More to come*
