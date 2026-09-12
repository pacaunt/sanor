#import "@local/sanor:0.3.0": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
// start-example
#slide(s => ([
  #let tag = tag.with(s)
  #set text(size: 50pt) // for visually apparent images
  = Two Rects 
  #grid(
    columns: (1fr, 1fr), align: center, 
    tag("rect1", rect(width: 2in, height: 1in)),
    tag("rect2", rect(width: 2in, height: 1in))
  )
  // Show both rectangle together
  #s.push((apply("rect1"), apply("rect2")))
  // Change them to another in the same step
  #s.push((
    apply("rect1", rect(width: 2in, height: 1in, fill: red)),
    apply("rect2", rect(width: 2in, height: 1in, fill: blue))
  ))
], s))