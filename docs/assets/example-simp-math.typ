#import "../../src/lib.typ": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
// start-example
#slide(s => ([
  #let tag = tag.with(s)
  #set text(size: 50pt) // for visually apparent images
  = Math Simplification
  // same tag name "expr"
  $ (x tag("expr", (x + 1))) / (2 tag("expr", (x + 1))) $
  #s.push(apply("expr")) // to show the element
  #s.push(apply("expr", text.with(fill: red))) // make it red 
  #s.push(apply("expr", math.cancel.with(stroke: red))) // cancel it
  #s.push(apply("expr", it => none)) // eliminates it
], s))