#import "../src/sanor.typ": *
#import "../src/rules.typ": *

// #let mytext = make-object(text, normal: (), hidden: hide, transparent: (fill: black.transparentize(80%)))

// #mytext("Hello")("normal")
// #mytext("Hello")("__base__")
// #mytext("Hello")("hidden")
// #mytext("Hello")("transparent")
// #mytext("Hello")(debug: true)

// #let s = (
//   tag-info: (
//     hider: text.with(fill: red),
//     defined-states: (:),
//     is-shown: false,
//     tags: (
//       "label": (case: "__base__", modifier: (:))
//     )
//   )
// )

// #_tag(s, "label", [TEST])
// #{ s.tag-info.tags.label.case = "hidden" }
// #_tag(s, "label", [TEST])
// #{ s.tag-info.tags.label.case = "__base__" }
// #let myrect = object(rect, hidden: (fill: gray))
// #_tag(s, "label", myrect())
// #{ s.tag-info.tags.label.case = "hidden" }
// #_tag(s, "label", myrect())


// #process-steps((
//   clear("Z"),
//   apply("A", text.with(fill: red)),
//   (apply("B", "hidden"), apply("C")),
//   (clear("A"), apply("B")),
//   once("D", "func"),
//   apply("A", "GOOD", fill: green),
//   clear("A")
// ))

// #control(3,s => {
//   s.tag-info.defined-states.redden = text.with(fill: red)
//   let tag = _tag.with(s)
//   $ a^2 tag("B",+  b^2) tag("C",+  c^2) $
// }, (
//   apply("B", text.with(fill: red)),
//   apply("C"),
//   (revert("B"), once("C", "redden")),
//   (),
// ))

// #process-steps((
//   apply("B", text.with(fill: red)),
//   (revert("B"), apply("C", "redden")),
// ))

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#let item-tag = _tag.with(hider: it => {
  show enum: hide
  show list: hide
  it
})

#slide(
  s => [
    #let tag = _tag.with(s)
    #let item-tag = _tag.with(s)

    = Hello
    #tag("1")[Some Text]
    #tag("2")[Another Text]

    #show: tag.with("3")
    - First Item

    #show: item-tag.with("4")
    - Second Item

    #show: item-tag.with("5")
    - Third Item

  ],
  controls: (
    apply("1"),
    apply("2"),
    apply("3"),
    apply("4"),
    apply("5"),
  ),
)

#slide(
  s => [
    #let tag = _tag.with(s)
    = Some Key

    #tag("author")[The author of this package is `@pacaunt`] \

    #tag("p1")[Here is some paragraph, with #tag("imp1")[important] word.]

    #tag("p2")[To show some extent; here is the result]

    #table(
      [A],
      [V],
      [F],
    )

  ],
  controls: (
    (),
    apply("author"),
    (apply("p1"), apply("imp1")),
    once("imp1", emph),
    apply("p2"),
  ),
  is-shown: false,
)

