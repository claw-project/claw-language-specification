<<<<<<< HEAD
# CLAW language definition

*CURRENTLY UNDER CONSTRUCTION* language will evolve under several iteration

This repository contains the draft of the directive language of the CLAW
project

The directives are either local or global.

* Local directive: those directives have a limited impact on a local block of
code (for example, only in a subroutine)
* Global directive: those directives can have an impact on the whole
application.


This language is separated in the followings sections:
* [CLAW abstraction](https://github.com/clementval/claw-definition/blob/master/definition/claw-abstraction.md) (specific abstraction for climate system modeling build
  on the top of other directives)
* [Loop transformation](https://github.com/clementval/claw-definition/blob/master/definition/loop-transform.md) (loop fusion, loop interchange/reordering, vector to loop)
* [Variable transformation](https://github.com/clementval/claw-definition/blob/master/definition/var-transform.md) (promotion/demtion, scalar replacement)
* [OpenACC abstraction](https://github.com/clementval/claw-definition/blob/master/definition/openacc-abstraction.md)
* *More to come*


##### Interpretation order of the CLAW directives
The claw directives can be combined together. For example, loop-fusion and
loop-interchange can be used together in a group of nested loops for example.

The interpretation order of the directives is the following:

1. loop-fusion
2. loop-interchange
3. ...

<!--- TODO Add directives in correct order --->

Users must be aware that directives transformation are applied successfully and
therefore, a transformation can be performed on already transformed code.
=======
# claw-samples
>>>>>>> 8ff321f80ad866c84bf18a14ec94cda7128a7b19
