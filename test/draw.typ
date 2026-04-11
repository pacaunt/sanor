#import "../src/lib.typ": * 

#set page(paper: "presentation-16-9", fill: luma(20))
#set text(fill: white, size: 25pt)

#slide(s => {
  let tag = tag.with(s)
  let tag = tag.with(hider: draw.hide)
  cetz.canvas({
    import draw: *
    stroke(white.transparentize(70%))
    tag("grid", {
      grid((0, 0), (16, 9), name: "grid", class: "background")
    })
  })

}, controls: (
  apply("grid"),
  apply("grid", it => {
    draw.scale(x: 2)
    draw.rotate(45deg)
    it
  }), 
  apply("grid", it => {
    draw.set-style(
      class: (
        background: (stroke: red)
      )
    )
    it
  })
))

#slide(s => {
  import annotation: *
  place((50%, 50%), anchor: top + left)[HELLO]
  circle((0, 0), stroke: green, radius: 3)[]
}, controls: ())