#import "../src/lib.typ": *

#set page(paper: "presentation-16-9", margin: 2cm)
#set text(size: 24pt)
#set align(center + horizon)


#let otext(s, body, ..styles, name: none) = tag(
  s,
  name, 
  class: "text", 
  object(text, hidden: hide)(body)
)

#slide(s => {
  let tag = tag.with(s)
  tag("title")[= Welcome]
  otext(s, name: "txt")[SOME TEXT]
}, controls: (
  apply("title"),
  apply("text", fill: red, weight: "bold"),
  apply("txt", fill: green),
))

