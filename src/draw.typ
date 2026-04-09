#import "@preview/cetz:0.4.2" as cetz: draw
#import draw: *

#let element(func) = (..args, name: none, class: none) => {
  import cetz.styles
  get-ctx(ctx => {
    let style = args.named()
    let style-from-name = (:)
    let style-from-class = (:)
    if class != none {
      style-from-class = styles.resolve(ctx.style, root: "class").at(class, default: (:))
      style = styles.merge(style, style-from-class)
    }
    if name != none {
      style-from-name = styles.resolve(ctx.style, root: "name").at(name, default: (:))
      style = styles.merge(style, style-from-name)
    }
    
    func(..args.pos(), ..style, name: name)
  })
}


#let circle = element(circle)
#let rect = element(rect)
#let line = element(line)
#let content = element(content)
#let rect-around = element(rect-around)
#let bezier = element(bezier)
#let group = element(group)
#let arc = element(arc)
#let circle-through = element(circle-through)
#let merge-path = element(merge-path)
#let grid = element(grid)
#let bezier-through = element(bezier-through)
#let catmull = element(catmull)
#let hobby = element(hobby)
#let polygon = element(polygon)
#let compound-path = element(compound-path)
#let arc-through = element(arc-through)
#let n-star = element(n-star)
