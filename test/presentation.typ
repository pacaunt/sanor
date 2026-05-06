#import "../src/lib.typ": *

#set page(paper: "presentation-16-9", fill: luma(20))
#set text(fill: white, size: 25pt)


#slide(s => (
  [
    #let tag = tag.with(s)

    = Hello, from Sanor
    #tag("Hello")[This is a text.]
    #s.push(apply("Hello", place.with(center + horizon)))
    #s.push(once("Hello", text.with(fill: red)))

  ],
  s,
))

#slide(s => (
  [
    #let tag = tag.with(s)
    = Integration with `pause`
    #let myrect = object(rect, base: case(), yellow: case(fill: yellow))

    This is the first text. #tag("yrect", myrect[Hi])

    #pause(s)[Then this came later]
    #s.push(1)

    #pause(s)[Like This]
    #s.push(1)

    #s.push(apply("yrect", "yellow"))
  ],
  s,
))

#slide(s => (
  [
    #let tag = tag.with(s)
    #let c1 = object(circle, hidden: hide)
    #tag("c1", c1())

    #s.push((apply("c1"), once("normal")))
    #s.push((apply("c1", fill: red), once("red")))
    #s.push((apply("c1", radius: 3cm), once("grow")))
    #s.push((clear("c1"), once("normal")))  // Reset to base
    #s.push((apply("c1"), once("back")))    // Apply will not preserve previous transforms
  ],
  s,
))

#slide(s => (
  [
    #let tag = tag.with(s)
    #let c1 = object(circle, hidden: hide)
    #tag("c1", c1())

    #s.push((apply("c1"), once("normal")))
    #s.push((apply("c1", fill: red), once("red")))
    #s.push((apply("c1", radius: 3cm), once("grow")))
    #s.push((revert("c1"), once("normal")))  // Reset to base
    #s.push((apply("c1"), once("back")))     // Apply will show as if previous animations weren't applied, but history is preserved
  ],
  s,
))

#slide(
  defined-cases: (
    "error": case(text.with(fill: red, weight: "bold")),
    "success": case(text.with(fill: green, weight: "bold")),
    "highlight": case(block.with(fill: yellow.transparentize(80%))),
  ),
  s => ([
    #let tag = tag.with(s)
    
    #tag("msg1")[Operation completed]
    #tag("msg2")[Check the results]
    
    #s.push(apply("msg1", "success"))
    #s.push(apply("msg2", "highlight"))
  ], s),
)

#slide(s => (
  [
    #let tag = tag.with(s)
    = Shorthand for apply
    #set align(center + horizon)
    #set circle(stroke: white)
    #set rect(stroke: white)
    #set polygon(stroke: white)
    #stack(dir: ltr, spacing: 1fr)[
      #tag("circ", circle[A circle])
    ][
      #tag("rect", rect[A rectangle])
    ][
      #tag("trig", polygon((0%, 0%), (10%, 10%), (0%, 10%)))
    ]
    #s.push("circ")
    #s.push("rect")
    #s.push("trig")
  ],
  s
))