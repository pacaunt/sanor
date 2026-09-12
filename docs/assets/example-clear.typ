#import "../../src/lib.typ": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
// start-example
#slide(s => ([
  #let tag = tag.with(s)
  #set text(size: 50pt) // for visually apparent images
  = Clear Example
  #tag("name", [Element])
  #s.push(apply("name"))
  #s.push(apply("name", rect.with(inset: 0.5em)))
  #s.push(apply("name", text.with(fill: red)))
  #s.push(clear("name")) // <-- base form.
  #s.push(apply("name")) // <-- No coming back...
], s))