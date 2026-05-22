#import "../src/process.typ": *
#import "../src/rules.typ": *
#import "../src/object-case.typ": case

#let ctx = (
  handout: false,
  handout-index: auto,
  drafted: false,
  cases: (:),
  subslide: 1,
  total-steps: 1,
  step: 1,
  defined-cases: (hidden: case(hide)),
  is-shown: false,
)

#let actions = ()

#actions.push(1)
#actions.push(1)
#actions.push(apply("A"))
#actions.push(once("A"))
#actions.push(-1)
#actions.push((revert("B"), cover("B")))

= Allocate

#_allocate-appliers(ctx, actions)

= Process
== Process 1
#_process(ctx, actions)

== Process 2

#let a = ()
#a.push(apply("A", scale))
#a.push(once("A", figure))
#a.push((once("B"),))
#a.push(())
#a.push(cover("A"))


#_allocate-appliers(ctx, a)

RESULT

#_process(ctx, a)

