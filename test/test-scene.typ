#import "../src/lib.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
#set align(center + horizon)
#show heading: set align(top + left)

#scene(tag => [
  #title[Scene Examples]
])

#scene(
  tag => [
    = Simple Scene
    #tag("t1")[some text]
    #tag("m1", ll => {
      $
        a^2 + b^2 = ll("c", c^2)
      $
    })
  ],
  controls: (
    (apply("t1"), apply("m1")),
    apply("t1", text.with(fill: red)),
    apply("c", text.with(fill: orange)),
  ),
)