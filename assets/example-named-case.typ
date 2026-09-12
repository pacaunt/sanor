#import "@local/sanor:0.3.0": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
// start-example
#slide(s => ([
#let tag = tag.with(s)
#set text(size: 50pt) // for visually apparent images
= Predefined Case
// Create 'my-rect' object, with predefined cases
#let my-rect = object(
  rect.with(width: 4in, height: 2in), 
  redden: case(fill: red), 
  grayed: case(fill: gray),
  bigger: scale.with(150%) // this is a shorthand for `case(scale.with(150%))`
)
// The content
#set align(center + horizon)
#tag("rect", my-rect[My Rect])
// Rules
#s.push(apply("rect"))
#s.push(once("rect", "redden")) // apply the 'redden' predefined case.
#s.push(once("rect", "bigger", "grayed")) // predefined cases can be combined.
], s))