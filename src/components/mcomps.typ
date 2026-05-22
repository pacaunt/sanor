#import "component.typ"

#let mcomp = component.new

// Usage: 
// ```example
// #let rrect = mrect.with(
//   defined-cases: (yellow: case(fill: yellow)),
//   radius: 0.5em,
//   inset: 0.5em,
// )
// #rrect(tag, name: "r1")[A rounded rectangle]
// ```
#let mrect = mcomp("rect", rect)
#let mcircle = mcomp("circle", circle)
#let mellipse = mcomp("ellipse", ellipse)
#let mcurve = mcomp("curve", curve)
#let mline = mcomp("line", line)
#let mblock = mcomp("block", block)
#let mpolygon = mcomp("polygon", polygon)
#let mbox = mcomp("block", box)
#let mtext = mcomp("text", text)
#let mequation = mcomp("equation", math.equation)
#let mtable = mcomp("table", table)
#let mgrid = mcomp("grid", grid)
#let mimage = mcomp("image", image)
#let mfigure = mcomp("figure", figure)
