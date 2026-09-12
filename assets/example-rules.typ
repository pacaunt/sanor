#import "@local/sanor:0.3.0": * 

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
// start-example
#slide(s => ([
  #let tag = tag.with(s) 
  #set text(size: 100pt) // for visually apparent images
  #tag("name", [Element])
  #s.push(cover("name"))                        // on subslide 1
  #s.push(apply("name")) // display it          // on subslide 2 
  #s.push(apply("name", text.with(fill: red)))  // on subslide 3
  #s.push(once("name", emph))                   // on subslide 4
  // Do nothing, to see that the once's effect is gone                          
  #s.push(())                                   // on subslide 5
  #s.push(revert("name"))                       // on subslide 6   
], s))