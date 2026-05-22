#import "../src/lib.typ": *
#import mcomps: *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#let rrect = mrect.with(
  defined-cases: (yellow: case(fill: yellow)),
  radius: 0.5em,
  inset: 0.5em,
)

#let yellowbox = mcomp("yellowbox", rect.with(stroke: yellow)).with(
  defined-cases: (
    wide: case(width: 100%),
    fade: case(fill: yellow.transparentize(80%)),
  ),
)

#scene(
  tag => [
    = Test 1: scene
    #set align(center + horizon)

    #rrect(tag, name: "r1")[A rounded rectangle]
    #yellowbox(tag, [A custom mobject])


  ],
  controls: (
    (),
    "r1",
    once("r1", "yellow"),
    apply("yellowbox"),
    once("yellowbox", "wide", "fade"),
  ),
)
