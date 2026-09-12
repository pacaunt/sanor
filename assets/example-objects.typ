#import "@local/sanor:0.3.0": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
// start-example
#slide(s => ([
  #let tag = tag.with(s)
  #set text(size: 50pt) // for visually apparent images
  = Two Rect Objects
  // Create 'my-rect' object
  #let my-rect = object(rect.with(width: 2in, height: 1in))

  #grid(
    columns: (1fr, 1fr), align: center, 
    tag("rect1", my-rect()),
    tag("rect2", my-rect())
  )
  // Show both rectangle together
  #s.push((apply("rect1"), apply("rect2")))
  // Change them to another in the same step
  #s.push((
    apply("rect1", fill: red),
    apply("rect2", fill: blue)
  ))
], s))