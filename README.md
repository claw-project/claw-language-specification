![CLAW Logo](./resources/logo_full_black.png)

# Directive Language Specification

#### Reference Compiler
The CLAW Compiler is the reference compiler for the claw directive
language. The project can be found here:
[claw-compiler](https://github.com/claw-project/claw-compiler)

#### Versions
##### Specification document
The current specification can be found here:
[CLAW specification document](./claw_language_specifications.pdf)

##### Generating the specification document
The specification is written using LaTeX. To generate the PDF document, you
can use `pdflatex` with the following command:

```
cd documentation
pdflatex claw_language_specifications.tex
```

##### History
* **Iteration 0.1**:
  * Define low-level block transformation.
    * Loop transformations.
    * Remove transformation.
* **Iteration 0.2**:
  * Refine low-level transformation from 0.1 if needed.
    * Add `collapse` clause to loop-fusion directive.
  * Add missing low-level transformation from the requirements.  
    * Add loop transformation `loop-hoist`.
    * Add array notation transformation `array-transform`.
    * Add claw transformation `kcache` for column caching.
    * Add claw transformation `call` for on the fly computation (array access to
      function call).
  * Start to abstract low-level transformation.
    * Introduction of the `parallelize` directive with the `define dimension`
      and `forward` clauses
* **Iteration 0.3**:      
  * Refine previous iterations, especially `parallelize` directive.
  **Iteration 0.4**:      
    * Refine previous iterations, especially `parallelize` directive.
    * Add conditional extraction `if-extract`

#### General information about the CLAW language
The directives are either local or global.

* Local directive: those directives have a limited impact on a local block of
code (for example, only in a subroutine)
* Global directive: those directives can have an impact on the whole
application.


This language is separated in the followings sections:
* CLAW abstraction
  (specific abstraction for climate system modeling build on the top of other
  directives)
  * k caching (column caching)
  * on the fly computation (array access to function call)
* Loop transformation
  * loop fusion
  * loop interchange/reordering
  * loop extraction
  * loop hoisting
  * conditional extraction
* OpenACC/OpenMP abstractions/helpers
  * array notation to do statement  
  * conditional primitive directive
* Utilities
  * remove
  * ignore
  * verbatim

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

1. ignore
2. remove
3. primitive
4. array-transform
5. loop-extract
6. loop-hoist
7. loop-fusion
8. loop-interchange
9. on-the-fly
10. kcache
11. if-extract
11. parallelize
12. parallelize-forward
13. formatting transformation (internal transformation only)

Users must be aware that directives transformation are applied sequentially and
therefore, a transformation can be performed on already transformed code.

---
Logo by [adrienbachmann.ch](http://www.adrienbachmann.ch)
