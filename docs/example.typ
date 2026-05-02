#import "../src/lib.typ": *

// Set up presentation format
#set page(paper: "presentation-16-9", margin: 2cm, fill: rgb("#1a1a1a"))
#set text(fill: white, size: 24pt)

// Title slide
#slide(s => ([
  #let tag = tag.with(s)
  #tag("title")[
    #text(size: 48pt, weight: "bold")[Sanor Examples]
    #v(1cm)
    #text(size: 32pt)[Presentation Framework for Typst]
    #v(2cm)
    #text(size: 24pt)[Demonstrating Key Features]
  ]
  #s.push(apply("title"))
], s))

// Basic Animation Example
#slide(s => ([
  #let tag = tag.with(s)
  #tag("header")[= Basic Animation]
  #tag("item1")[- First item appears]
  #tag("item2")[- Second item appears]
  #tag("item3")[- Third item appears]
  #tag("conclusion")[All items are now visible!]
  #s.push(once("header"))
  #s.push(apply("item1"))
  #s.push(apply("item2"))
  #s.push(apply("item3"))
  #s.push(apply("conclusion"))
], s))

// Apply vs Once Demonstration
#slide(s => ([
  #let tag = tag.with(s)
  #tag("title")[= Apply vs Once]
  #tag("persistent")[This content stays visible (apply)]
  #tag("temporary")[This appears only briefly (once)]
  #tag("next")[Next step - temporary content is gone]
  #s.push(once("title"))
  #s.push(apply("persistent"))
  #s.push(once("temporary"))
  #s.push(1) // Empty step to show temporary content disappears
  #s.push(apply("next"))
], s))

// Content Modification
#slide(s => ([
  #let tag = tag.with(s)
  #tag("title")[= Content Modification]
  #tag("text", text(size: 28pt)[Hello World])
  #s.push(once("title"))
  #s.push(apply("text"))
  #s.push(apply("text", text.with(fill: blue)))
  #s.push(apply("text", text.with(fill: red, weight: "bold")))
  #s.push(apply("text", text.with(fill: green, style: "italic")))
], s))

// Object System
#let colored-box = object(
  rect,
  normal: case(width: 4cm, height: 3cm, fill: blue, stroke: 2pt),
  highlighted: case(width: 4cm, height: 3cm, fill: yellow, stroke: 3pt + red),
  large: case(width: 6cm, height: 4.5cm, fill: blue, stroke: 2pt),
)

#slide(s => ([
  #let tag = tag.with(s)
  #tag("title")[= Object System]
  #tag("box", colored-box()[Normal Box])
  #s.push(once("title"))
  #s.push(apply("box"))
  #s.push(apply("box", "highlighted"))
  #s.push(apply("box", "large"))
], s))

// Complex Animation with Multiple Elements
#slide(s => ([
  #let tag = tag.with(s)
  #tag("title")[= Complex Animation]
  #tag("diagram", align(center)[
    #rect(width: 2cm, height: 1cm, fill: blue)[A]
    #h(1cm)
    #rect(width: 2cm, height: 1cm, fill: gray)[B]
    #h(1cm)
    #rect(width: 2cm, height: 1cm, fill: gray)[C]
  ])
  #tag("arrow1", align(center)[→])
  #tag("arrow2", align(center)[→])
  #tag("explanation")[Processing step by step]
  #s.push(once("title"))
  #s.push(apply("diagram"))
  #s.push(apply("arrow1"))
  #s.push(apply("explanation"))
  #s.push(apply("diagram", it => {
    show "A": set rect(fill: green)
    it
  }))
  #s.push(apply("arrow2"))
], s))

// Code Presentation
#slide(s => ([
  #let tag = tag.with(s)
  #tag("title")[= Code Presentation]
  #tag("code", ```typst
  #import "@preview/sanor:0.2.1": *

  #slide(s => ([
    #let tag = tag.with(s)
    #tag("content")[Hello Sanor!]
    #s.push(apply("content"))
  ], s))
  ```)
  #s.push(once("title"))
  #s.push(apply("code"))
  #s.push(apply("code", it => {
    show "slide": set text(fill: blue)
    show "tag": set text(fill: green)
    it
  }))
], s))

// Mathematical Content
#slide(s => ([
  #let tag = tag.with(s)
  #tag("title")[= Mathematical Animation]
  #tag("equation", $ E = m c^2 $)
  #tag("explanation")[Einstein's famous equation]
  #s.push(once("title"))
  #s.push(apply("equation"))
  #s.push(apply("explanation"))
  #s.push(apply("equation", it => {
    show "E": set text(fill: red, weight: "bold")
    show "m": set text(fill: blue)
    show "c": set text(fill: green)
    it
  }))
], s))

// State Management with Clear
#slide(s => ([
  #let tag = tag.with(s)
  #tag("title")[= State Management]
  #tag("content", [This text changes appearance])
  #s.push(once("title"))
  #s.push(apply("content"))
  #s.push(apply("content", text.with(fill: red)))
  #s.push(apply("content", text.with(fill: blue, size: 32pt)))
  #s.push(revert("content")) // Back to original
  #s.push(apply("content", text.with(fill: green, style: "italic")))
], s))

// Multiple Simultaneous Changes
#slide(s => ([controls: (
    once("title"),
    apply("diagram"),
    apply("arrow1"),
    apply("explanation"),
    (
      apply("diagram", it => {
        show "A": set rect(fill: green)
        it
      }),
      apply("arrow2"),
    ),
  )
  #let tag = tag.with(s)
  #tag("title")[= Simultaneous Changes]
  #tag("left", place(left)[Left side content])
  #tag("right", place(right)[Right side content])
  #tag("center", place(center)[Center content])
  #s.push(once("title"))
  #s.push(apply("center"))
  #s.push((apply("left"), apply("right"))) // Both at once
  #s.push((revert("left"), revert("right"))) // Both disappear
], s))

// Custom States Example
#slide(s => ([
  #let tag = tag.with(s)
  #tag("title")[= Custom States]
  #tag("demo", [Demo Text], faded: case(text.with(fill: gray)), highlighted: case(text.with(fill: yellow, weight: "bold")))
  #s.push(once("title"))
  #s.push(apply("demo"))
  #s.push(apply("demo", "faded"))
  #s.push(apply("demo", "highlighted"))
  #s.push((apply("demo", "faded"), apply("demo", "highlighted"))) // Multiple states
], s))

// Handout Mode Example
#slide(options: (handout: true, handout-index: 3), s => ([
  #let tag = tag.with(s)
  #tag("title")[= Handout Mode]
  #tag("step1")[Step 1: Introduction]
  #linebreak()
  #tag("step2")[Step 2: Details]
  #linebreak()
  #tag("step3")[Step 3: Conclusion]
  #s.push(once("title"))
  #s.push(apply("step1"))
  #s.push(apply("step2"))
  #s.push(apply("step3"))
], s))

// Final slide
#slide(s => ([
  #let tag = tag.with(s)
  #tag("thanks")[
    #text(size: 36pt, weight: "bold")[Thank You!]
    #v(1cm)
    #text(size: 24pt)[For exploring Sanor examples]
    #v(2cm)
    #text(size: 18pt)[Visit the documentation for more features]
  ]
  #s.push(apply("thanks"))
], s))
