#import "../../src/lib.typ": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
// start-example
#slide(s => ([
  #let tag = tag.with(s)  // Shorthand to avoid repeating `s`.
  #set text(size: 100pt)  // for visually apparent images
  #tag("name", [Element])
  #s.push(apply("name"))                        // on subslide 1
  #s.push(apply("name", text.with(fill: red)))  // on subslide 2
  #s.push(apply("name", strong))                // on subslide 3
], s))