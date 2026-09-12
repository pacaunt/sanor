#import "../../src/lib.typ": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
#set text(size: 50pt) // for visually apparent images
// start-example
#slide(s => ([
  #let tag = tag.with(s)
  #set align(horizon + center)
  #tag("A", rect(width: 1in, height: 1in, fill: red))
  #tag("B", rect(width: 1in, height: 1in, fill: blue))
  #s.push(apply("A")) // shown on subslide 1
  #s.push(apply("B")) // shown on subslide 2
  #s.push(-1)         // shift the next animation to 1 subslide eariler
  #pause(s)[Content]  // shown on subslide 2, instead of 3
  #s.push(1)          // should create subslide 3, but got shifted to 2.
], s))
