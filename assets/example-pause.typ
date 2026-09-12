#import "@local/sanor:0.3.0": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
#set text(size: 50pt) // for visually apparent images
// start-example
#slide(s => ([
  #s.push(1) // Skip the first subslide
  #pause(s)[- First Point]
  #s.push(1) // Creates the subslide 2
  #pause(s)[- Second Point] // This will be shown in the subslide 3
  #s.push(1) // Creates the subslide 3
], s))
