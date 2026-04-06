#import "../src/lib.typ": *

#set page(paper: "presentation-16-9", fill: luma(20))
#set text(fill: white, size: 25pt)


#slide(
  s => {
    show regex("\{\{.*\}\}"): it => {
      [#it.text.trim(regex("\{|\}"))<label1>]
    }
    let tag = tag.with(s)
    tag("text1")[Hello]
    tag("text2")[How Equation of State Works?]
    tag("text3")[
      Here is an example:
      #tag("eq1", $ P V = n R T $)
      #tag("des1")[
        *Equation of state* is any equation that relates $P$, $V$, and $T$.
      ]
    ]

    tag("text4")[
      Let's see some code example.


      #tag("code1", {
        (
          ```typst
          Hello Typst
          Well {{Done}}
          ```
        )
      })
    ]
  },
  controls: (
    once("text1", place.with(center + horizon)),
    once("text2", place.with(center + horizon)),
    apply("text3", place.with(center + horizon)),
    apply("eq1"),
    apply("des1"),
    (
      once("eq1", it => {
        show regex("P|V|T"): set text(fill: yellow)
        it
      }),
      once("des1", it => {
        show $a$.func(): s => {
          show regex("P|V|T"): set text(fill: yellow)
          s
        }
        it
      }),
    ),
    (
      clear("text3"),
      apply("text4", place.with(center + horizon)),
    ),
    apply("code1"),
    apply("code1", it => {
      show <label1>: set text(fill: green)
      it
    }),
  ),
  hider: it => none,
)


#set page(margin: 0pt)
#import "@preview/cetz:0.4.2": canvas, draw
#let transformer(body, ..funcs) = {
  funcs.pos().fold(body, (acc, f) => f(acc))
}
#let transformer = object(transformer, hidden: it => none)
#slide(
  s => {
    let tag = tag.with(s)
    let cobj(name, func, ..args) = {
      tag(name, func(name: name, ..args))
    }
    set align(center + horizon)
    layout(size => {
      canvas(length: 10% * size.height, {
        import draw: *
        stroke(white)
        tag("all", transformer({
          tag("coords", grid(
            (-5, -5),
            (5, 5),
            stroke: luma(80),
          ))
          tag("axes", {
            set-style(mark: (width: .1, length: .2, fill: white))
            line((-5, 0), (5, 0), mark: (symbol: ">"), name: "x")
            line((0, -5), (0, 5), mark: (symbol: ">"), name: "y")
            floating({
              content("x.end", $x$, anchor: "west", padding: .2)
              content("y.97%", $y$, anchor: "west", padding: .2)
            })
          })
        }))
      })
    })
  },
  hider: it => none,
  controls: (
    (
      apply("all"),
      apply("coords"),
    ),
    apply("axes"),
    apply("all", it => {
      draw.rotate(-30deg)
      it
    }),
    apply("all", it => {
      draw.scale(x: 150%)
      it
    }),
    revert("all"),
  ),
)


#slide(s => {
  let tag = tag.with(s)
  set align(center + horizon)
  tag("t1")[
    #tag("doc")[
      #block[NOTE]
    ]
    #tag("report")[
      #block[REPORT PIC]
    ]
    You can use Typst with #box(width: 3cm)[
      #set align(left)
      #set text(fill: yellow)
      #tag("doc")[notes]
      #tag("report")[reports]
      #tag("thesis")[theses]
      #tag("slides")[slides]
    ]
  ]
}, hider: it => none, controls: (
  apply("t1"),
  once("doc"),
  once("report"),
  once("thesis"),
  once("slides")
))
