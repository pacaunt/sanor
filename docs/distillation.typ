#import "../src/lib.typ": *

#set page(paper: "presentation-16-9", margin: 2cm)
#set text(size: 24pt)
#set align(center + horizon)


#let (slide,) = set-option(hider: it => none)

#slide(s => {
  [#text(size: 32pt, weight: "bold")[Multicomponent Distillation]
    #v(1cm)
    A Fundamental Separation Process \ in Chemical Engineering]
  v(0.5cm)
  [\@pacaunt]
})

#import "@preview/cetz:0.4.2" as cetz: canvas, draw

#slide(
  s => {
    let tag = tag.with(s)
    let material(
      name: none,
      ..pts-styles,
    ) = {
      draw.get-ctx(ctx => {
        import draw: *
        let input-styles = pts-styles.named()
        let points = pts-styles.pos()
        let base-styles = (mark: (width: .2, length: .4, end: ">"))
        let line-styles = cetz.styles.resolve(ctx.style, root: "line", merge: base-styles)
        let styles = cetz.styles.resolve(ctx.style, base: line-styles, root: "material", merge: input-styles)

        if type(styles.mark) == dictionary and "fill" in styles.mark and styles.mark.fill == none {
          styles.mark.fill = styles.stroke.paint
        }

        line(..points, name: name, ..styles)
      })
    }

    tag("title")[= Distillation Compartments]
    canvas({
      import draw: *
      let tag = tag.with(hider: hide)
      set-style(mark: (width: .2, length: .4), content: (padding: .5em))
      tag("all", {
        tag("column", {
          rect((0, 0), (3, 6), name: "column")
          content("column.north-west", anchor: "east", padding: 0.5em, [Column])
        })
        tag("reboiler", {
          rect((4, -2), (rel: (4, 2)), name: "reboiler")
          content("reboiler", [Reboiler])
        })

        tag("condenser", {
          rect((4, 6), (rel: (5, 2)), name: "condenser")
          content("condenser", [Condenser])
        })

        tag("feed", {
          material((to: "column.west", rel: (-3, 0)), "column.west", name: "feed")
          content("feed.start", [Feed $F, z_F$], anchor: "east")
        })

        tag("vapor", {
          material("column.north", ((), "|-", "condenser.west"), "condenser.west", name: "vapor")
        })

        tag("reflux", {
          material("condenser.south", (rel: (0, -2)), ((), "-|", "column.east"), name: "reflux")
          content("reflux.40%", [Reflux, $L$], anchor: "west", padding: 0.5em)
        })

        tag("liquid", {
          material("column.south", ((), "|-", "reboiler.west"), "reboiler.west", name: "liquid")
          // content("liquid.20%", [Liquid, $overline(L)$], anchor: "east", padding: 0.5em)
        })

        tag("vapor-flow", {
          material("reboiler.north", (rel: (0, 2)), ((), "-|", "column.east"), name: "vapor-flow")
        })

        tag("distillate", {
          material("reflux.20%", (rel: (3, 0)), name: "distillate")
          content("distillate.end", [Distillate, $D$], anchor: "west")
        })

        tag("bottom", {
          material("liquid.20%", (rel: (0, -2)), name: "bottom")
          content("bottom.mid", [Bottom, $B$], anchor: "east", padding: 0.5em)
        })
      })
    })
  },
  is-shown: false,
  controls: (
    once("title"),
    (
      apply("all"),
      apply("column"),
    ),
    apply("feed"),
    (apply("condenser"), apply("vapor")),
    apply("reflux"),
    (
      apply("distillate"),
      once("distillate", it => {
        draw.scope({
          draw.stroke(red)
          it
        })
      }),
    ),
    (apply("distillate"), apply("liquid")),
    apply("reboiler"),
    apply("vapor-flow"),
    apply("bottom"),
    apply("all", it => {
      draw.scale(origin: (2, 0),200%)
      it
    }),
    ()
  ),
)
