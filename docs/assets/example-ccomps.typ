#import "../../src/lib.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 30pt)
// start-example
#slide(s => ([
#import ccomps: * // Import the component

= CeTZ ccomps

#cetz.canvas({
  import cetz.draw: * 
  ccircle(s, (0, 0))
  // default name is 'c' + element's function
  line("ccircle.east", (rel: (3, 0)), name: "l1")
  // name of the CeTZ objects will be used as a name in tag too
  crect(s, (6, -1), (8, 1), name: "r1")
})
#s.push("ccircle")
#s.push(apply("ccircle", fill: red, radius: 3))
#s.push("r1")
#s.push(apply("r1", stroke: green + 5pt))
], s))
