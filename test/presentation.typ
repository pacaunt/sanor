#import "../src/lib.typ": *

#set page(paper: "presentation-16-9", fill: luma(20))
#set text(fill: white, size: 25pt)


#slide(s => ([
  #let tag = tag.with(s)

  = Hello, from Sanor
  #tag("Hello")[This is a text.]
  #s.push(apply("Hello", place.with(center + horizon)))
  #s.push(once("Hello", text.with(fill: red)))

], s))

#slide(s => ([
  #let tag = tag.with(s)
  = Integration with `pause`
  #let myrect = object(rect, base: case(), yellow: case(fill: yellow))

  This is the first text. #tag("yrect", myrect[Hi])

  #pause(s)[Then this came later]
  #s.push(1)

  #pause(s)[Like This]
  #s.push(1)
  
  #s.push(apply("yrect", "yellow"))
], s))