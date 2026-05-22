#import "../src/lib.typ": *
#import ccomps: *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#slide(s => ({
  cetz.canvas({
    import cetz.draw: * 
    ccircle(s, (0, 0))
    line("ccircle.east", (rel: (3, 0)))
    // name of the CeTZ objects will be used as a name in tag too
    crect(s, (3, 0), (0, 3), name: "r1")
  })
  s.push("ccircle")
  s.push(apply("ccircle", fill: red, radius: 3))
  s.push("r1")
  s.push(apply("r1", stroke: green + 5pt))
}, s))
