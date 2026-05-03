/// Sanor Examples
///
/// This file demonstrates the key features of the Sanor presentation framework:
/// - Pause: Reveal content step by step with manual control
/// - Tag + Apply/Once: Mark and animate specific elements
/// - Objects: Create reusable components with multiple states
/// - Cases: Define named transformations for flexible styling
/// - Simultaneous actions: Animate multiple elements at once
///
/// Each slide is a standalone example showing one or more features.

#import "../src/lib.typ": *

// Set up presentation format.
#set page(paper: "presentation-16-9", fill: luma(20))
#set text(size: 25pt, fill: white)

/// Slide 1: Title Slide
///
/// Basic slide setup with title and author. This demonstrates the minimal
/// structure needed for a Sanor slide: wrap content in a function that receives
/// the slide context `s`.

#slide(s => (
  [
    #let tag = tag.with(s)
    #set align(center + horizon)
    #title[Sanor Examples]
    \@pacaunt
  ],
  s,
))

/// Slide 2: Basic Pause
///
/// Demonstrates the `pause()` function for incremental reveals.
/// - `pause(s, content)` shows content only when the current step exceeds the
///   number of previous `pause()` calls.
/// - `s.push(1)` advances to the next step.
/// Use `pause()` for simple bullet-point or text reveals that don't need animation.

#slide(s => (
  [
    #let tag = tag.with(s)
    = Normal Pause
    #set align(horizon)
    #pause(s, [- First Item])
    #s.push(1)
    #pause(s, [- Second Item])
    #s.push(1)
    #pause(s, [- Third Item])
    #s.push(1)
  ],
  s,
))

/// Slide 3: Tagged Element Examples
///
/// Shows the difference between tagging strategies and animation rules:
/// - `tag("once", content)`: Content appears for a single step, then disappears.
/// - `tag("apply", content)`: Content appears and remains visible in all subsequent steps.
/// - `tag("trans", content)`: Content is shown with different styles across steps.
///
/// Animation rules:
/// - `once("name")`: Apply a modification for one step only.
/// - `apply("name")`: Apply a modification for the current step and all future steps.

#slide(s => (
  [
    #let tag = tag.with(s)
    = Tagged Element Examples
    #set align(center + horizon)
    #tag("once")[This will appear _once_.] \
    #tag("apply")[This will appear _all the time_.]

    #tag("trans")[This will transform.]

    #s.push(once("once"))
    #s.push(apply("apply"))
    #s.push(apply("trans"))
    #s.push(apply("trans", text(fill: yellow, "Transformed!")))
  ],
  s,
))

/// Slide 4: Math Examples
///
/// Demonstrates using tagged elements in mathematical expressions.
/// - Tag specific parts of math content (here: `tag("m", ...)` for the term "x + 2")
/// - Apply different transformations to the tagged term across steps:
///   - Show it normally
///   - Color it red
///   - Use `math.cancel` to visually cross it out
///   - Hide it completely with `it => none`
/// - Use `s.push(-1)` to adjust positioning and `s.push(1)` to advance steps.

#slide(s => (
  [
    #let tag = tag.with(s)
    = Math Examples
    Simplify
    $
      (x(x + 1)tag("m", (x + 2)))/(2 tag("m", (x + 2)))
    $
    #s.push(apply("m")) // Show the `m`.
    #s.push(apply("m", text.with(fill: red))) // Make it red.
    #s.push(apply("m", math.cancel)) // Cancel it.
    #s.push(apply("m", it => none)) // Remove it.
    #s.push(-1) // to move the `pause` up
    #pause(s)[End.]
    #s.push(1) // to update the last `pause`.
  ],
  s,
))

/// Slide 5: Code Example
///
/// Integrates Sanor animations with the `zebraw` code highlighting package.
/// - Tag code blocks for step-by-step highlighting or modification
/// - First step: Show the base code
/// - Second step: Rerender with `zebraw` and custom highlighting applied to specific lines
/// - This technique works with any Typst package for syntax highlighting or rendering.

#slide(s => (
  [
    #import "@preview/zebraw:0.6.3": zebraw
    #let tag = tag.with(s)
    #let zebraw = zebraw.with(
      background-color: luma(30),
      lang: false,
      highlight-color: white.transparentize(90%),
      comment-color: white.transparentize(90%),
      comment-font-args: (font: "Libertinus serif"),
    )
    = Code Example
    Integration with `zebraw`.
    #set align(horizon)

    #show: zebraw

    #tag("snippet")[```typst
    #slide(s => ([
      #let tag = tag.with(s)
      // Your Content Goes Here
    ],s))
    ```]

    #s.push(apply("snippet"))
    #s.push(apply("snippet", it => {
      zebraw(it, highlight-lines: (
        "2": [
          Don't forget this line!
        ],
      ))
    }))

  ],
  s,
))

/// Slide 6: Simultaneous Animation
///
/// Shows how to animate multiple elements at the same time:
/// - Wrap multiple rules in a tuple (or array) when calling `s.push()`
/// - Step 1: Show both Jack and Julie labels
/// - Step 2: Highlight Jack and show his description
/// - Step 3: Highlight Julie and show her description
/// This is useful for coordinating animations across different elements on a slide.

#slide(s => (
  [
    #let tag = tag.with(s)
    = Simultaneous Animation
    #set align(center + horizon)

    #grid(columns: (1fr,) * 2, align: horizon)[
      #tag("Jack")[Jack]

      #tag("jtext")[Jack was a teacher.]
    ][
      #tag("Julie")[Julie]

      #tag("ltext")[Julie was a student.]
    ]

    #s.push((
      apply("Jack"),
      apply("Julie"),
    ))

    #s.push((
      once("Jack", circle.with(fill: blue)),
      once("jtext"),
    ))

    #s.push((
      once("Julie", circle.with(fill: fuchsia)),
      once("ltext"),
    ))
  ],
  s,
))

/// Slide 7: Object Manipulation
///
/// Introduces the `object()` function for creating reusable components with state:
/// - `object(func, hidden: hide)` creates a component that can be instantiated multiple times
/// - Apply modifications cumulatively to the same object across steps
/// - `outset: 1em` is applied as a direct property modification
/// - Objects combine all active transformations from previous steps (unless using `revert()`)
/// Useful for building complex interactive diagrams or UI mockups.

#slide(s => (
  [
    #let tag = tag.with(s)
    = Object Manipulation
    Elements defined by `object` declaration can be modified.
    #set align(horizon)
    #let myrect = object(rect.with(stroke: yellow), hidden: hide)

    #tag("base", myrect[Hello])
    #s.push(apply("base", align.with(center)))
    #s.push(apply("base", outset: 1em))
    #s.push(once("base", text.with(fill: yellow)))
    #s.push(apply("base", radius: 2em))
  ],
  s,
))

/// Slide 8: Custom Defined Cases
///
/// Shows how to define named cases for an object, enabling semantic animation rules:
/// - `case(property: value)` creates a case with styling applied
/// - `case(function)` creates a case that wraps content with a function
/// - Reference cases by name in `apply()` / `once()` instead of repeating properties
/// This makes complex animations more readable and reusable. Named cases can include
/// both styling properties and wrapper functions.

#slide(s => (
  [
    #let tag = tag.with(s)
    = Custom Defined Cases
    *Cases* are a short hand for defining actions that will act on an element.

    #let mytext = object(
      text,
      redden: case(fill: red),
      grayed: case(fill: gray),
      rotated: case(rotate.with(30deg)),
    )

    #show: block.with(height: 1fr, width: 100%)
    #tag("elem", mytext[This is a text.])
    #s.push(apply("elem", place.with(center + horizon)))
    #s.push(once("elem", "redden"))
    #s.push(once("elem", "grayed"))
    #s.push(once("elem", "rotated", place.with(center + horizon)))
  ],
  s,
))

/// Slide 9: Mixing Animations and Pause
///
/// Demonstrates combining multiple features in a single slide:
/// - Define custom cases at the slide level with `defined-cases:` option
/// - Mix `pause()` for narrative flow with tagged animations for interactivity
/// - Use tuples in `s.push()` for simultaneous multi-element animations
/// - Coordinate text reveals and element highlighting across presentation steps
/// - This slide shows a "choose your path" interaction pattern with visual feedback.

#slide(
  defined-cases: (
    "highlighted": case(block.with(outset: 0.5em, stroke: yellow)),
    "alert": case(text.with(fill: yellow)),
  ),
  s => (
    [
      #let tag = tag.with(s)
      = Mixing animations and pause

      #pause(s, [Hello, there!])
      #s.push(1)

      #pause(s, [Here are some switches you can choose.])
      #s.push(1)

      #set align(center + horizon)

      #let myrect = object(rect.with(height: 2cm, width: 2cm))

      #grid(columns: (1fr,) * 2, align: top)[
        #tag("green", myrect(fill: green))
        #tag("gtext", [If you press the green one, you will survive.])
      ][
        #tag("red", myrect(fill: red))
        #tag("rtext", [If you press the red one, you will get sick!])
      ]

      #s.push((
        apply("green"),
        apply("red"),
      ))
      #s.push((
        once("gtext", "alert"),
        once("green", "highlighted"),
      ))
      #s.push((
        once("rtext", "alert"),
        once("red", "highlighted"),
      ))

      #pause(s, move(dy: -2em)[What did you choose?])
      #s.push(1)
    ],
    s,
  ),
)
