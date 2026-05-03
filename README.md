# Sanor

Fast, small, but powerful presentation framework in Typst.

Sanor is a Typst package that provides utilities for creating animated presentations with incremental content reveals, state management, and flexible slide controls.

## Features

- **Step-by-Step Reveals**: Control content visibility with `pause()` for narrative flow or tagged animations for interactive elements
- **Content Tagging System**: Use `tag()` to mark elements that can be animated, revealed, or transformed
- **Animation Rules**: Apply transformations with `apply()` (persistent), `once()` (single step), `cover()` (hide), `revert()` (reset), or `clear()` (remove prior modifiers)
- **Reusable Objects**: Create components with `object()` that can have multiple visual states via named cases
- **Cases System**: Define semantic transformations with `case()` that can be referenced by name instead of repeating properties
- **Simultaneous Actions**: Coordinate animations across multiple elements by grouping rules in tuples
- **Handout Support**: Generate static handouts from animated presentations with `set-option(handout: true)`
- **Flexible State Management**: Maintain complex presentation state across slides with full control over animation sequences

## Core Concepts

### Tags & Rules
A **tag** marks content for animation. Rules define what happens to tagged content at each step:
- `tag("name", content)` — Mark content with a unique identifier
- `apply("name", ...)` — Apply a transformation from now on (persists across steps)
- `once("name", ...)` — Apply a transformation for just this step
- `cover("name", ...)` — Hide content by applying a hidden case
- `revert("name", ...)` — Reset to a base state without inheritance

### Cases
A **case** is a named transformation that can be applied to content:
- `case(fill: red)` — Styling properties that modify content appearance
- `case(text.with(weight: "bold"))` — Wrapper functions that transform structure
- Cases can be defined when creating objects for reuse: `object(text, red: case(fill: red))`
- Reference cases by name: `apply("elem", "red")` instead of `apply("elem", text.with(fill: red))`

### Objects
An **object** is a reusable component with built-in state management:
- `object(func, case1: case(...), case2: case(...))` — Define multiple named cases
- Objects cache transformations, so multiple `apply()` calls accumulate effects
- Use `revert()` or `cover()` to change behavior between steps

### Animation Workflow
1. Define slide content using `slide(s => [content], s)`
2. Mark elements with `tag("name", content)` that you want to animate
3. Push animation rules with `s.push()`:
   - Single rule: `s.push(apply("name"))`
   - Multiple rules at once: `s.push((apply("left"), apply("right")))`
   - Advance without animation: `s.push(1)`
4. Each presentation step corresponds to one or more calls to `s.push()`

## Presentation Package Comparison

There are several Typst presentation packages, each with different strengths. Choose Sanor if you need fine-grained animation control and incremental content reveals.

| Package | Strengths | When to choose |
| --- | --- | --- |
| **Sanor** | Incremental reveals, custom state, tagged animations, step-by-step control | You need animated presentations with precise control over when and how content appears. Great for tutorials, lectures, interactive demos. |
| **Touying** | Simple slides, slide themes, straightforward syntax | You want a lightweight framework with sensible defaults and don't need complex animations. |
| **Polylux** | Polished visual designs, built-in themes, design-focused | You prioritize appearance and want prebuilt themes. Best for conference presentations with consistent visual branding. |
| **Presentate** | General-purpose framework, high-level abstractions, convenience functions | You want a general slide deck tool with reasonable defaults and don't need much precise animations. |

## Installation

Add the package to your Typst project:

```typst
#import "@preview/sanor:0.2.1": *
```

*Note: Version 0.2.1 may not be published yet. Check the latest available version on [Typst Universe](https://typst.app/universe). For local development, import from the local path.*

## Quick Start

```typst
#import "@preview/sanor:0.2.1": *

#slide(s => ([
  #let tag = tag.with(s)
  = Hello World
  #tag("title")[This is a presentation slide]
  #s.push(apply("title", text.with(fill: blue)))
], s))
```

## API Reference

### Core Functions

#### `slide(options: (:), func, hidden: auto, is-shown: false, defined-cases: (:))`

Creates a slide where content can be revealed or modified step by step via animation rules pushed with `s.push()`.

**Parameters:**
- `options` (dict): Slide configuration options
- `func` (function): Function receiving slide context `s` and returning `(content, s)`
- `hidden` (auto, case): The case used to hide content (default: `superhide`)
- `is-shown` (bool): Whether hidden elements are visible by default
- `defined-cases` (dict): Predefined named cases available on this slide

**Usage:**
```typst
#slide(s => ([
  #let tag = tag.with(s)
  = My Slide
  #tag("elem")[Content]
  #s.push(apply("elem"))
], s))
```

#### `tag(s, name, body, hidden: auto, ..defined-cases)`

Marks content for animation or state management. Tagged content can be modified by rules in `s.push()`.

**Parameters:**
- `s` (context): The slide context
- `name` (str): Unique identifier for this tagged element
- `body` (content): The content to tag
- `hidden` (auto, case): Case to use when content is hidden
- `..defined-cases` (cases): Additional named cases for this tag

**Returns:** The content with animation hooks applied

#### `pause(s, body, hidden: auto)`

Shows content after a certain number of presentation steps. Use `s.push(1)` to advance steps.

**Parameters:**
- `s` (context): The slide context
- `body` (content): Content to show after pause reaches this point
- `hidden` (auto, case): Case to use before pause reaches this point

**Usage:**
```typst
#pause(s, [Appears on step 1])
#s.push(1)
#pause(s, [Appears on step 2])
#s.push(1)
```

#### `set-option(..new-options)`

Sets global configuration options for all subsequent slides. Used before slides are defined.

**Parameters:**
- `..new-options` (named): Named options like `handout: true`

**Returns:** Updated exports with options applied

### Animation Rules

Rules define what happens to tagged content at each step. Use these in `s.push()`.

#### `apply(name, ..cases, inherit: true)`

Apply transformations from this step onward (persistent).

**Parameters:**
- `name` (str): Tag name to target
- `..cases` (any): Cases, properties, or wrapper functions to apply
- `inherit` (bool): Combine with previous active cases (default: true)

**Behavior:** Transformations accumulate across steps. Future steps continue with these transformations unless `revert()` is called.

#### `once(name, ..cases, inherit: true)`

Apply transformations for just this step (transient).

**Parameters:**
- `name` (str): Tag name to target
- `..cases` (any): Cases, properties, or wrapper functions
- `inherit` (bool): Combine with active cases from previous steps (default: true)

**Behavior:** Transformation applies only for this step. Next step reverts to previous state.

#### `cover(name, ..cases)`

Apply transformations without inheritance. Equivalent to `apply(name, ..cases, inherit: false)`.

**Parameters:**
- `name` (str): Tag name to target
- `..cases` (any): Cases to apply exclusively (ignoring previous active cases)

#### `clear(name)`

Clear previous modifiers applied to a tagged element, resetting it before applying new cases in the current step.

**Parameters:**
- `name` (str): Tag name to target

**Behavior:** Removes prior active cases from the element so subsequent transformations start from a clean state.

**Example:**
```typst
#slide(s => ([
  #let tag = tag.with(s)
  #tag("item")[Important]

  #s.push(apply("item", text.with(fill: red)))
  #s.push(clear("item"))
  #s.push(apply("item", text.with(fill: green)))
], s))
```

#### `revert(name, ..cases)`

Reset to base state and optionally apply new cases. Use to undo accumulated transformations.

**Parameters:**
- `name` (str): Tag name to target
- `..cases` (any): Cases to apply (inherits from previous steps)

#### `force(name, ..cases)`

Shorthand for `apply(name, ..cases, inherit: false)`. Apply without combining with previous cases.

**Parameters:**
- `name` (str): Tag name to target
- `..cases` (any): Cases to apply exclusively

### Object System

#### `object(func, hidden: case(hide), ..defined-cases)`

Creates a reusable component with built-in state management and named cases.

**Parameters:**
- `func` (function): The base function (e.g., `rect`, `text`) used to create the object
- `hidden` (case): The case applied when the object is hidden (default: `case(hide)`)
- `..defined-cases` (named): Named cases (e.g., `red: case(fill: red)`) for reuse

**Returns:** An object function that can be called like `obj[content]` or `obj(property: value)`

**Usage:**
```typst
#let box = object(rect, red: case(fill: red), large: case(width: 4cm))
#let tag = tag.with(s)
#tag("mybox", box[Text])
#s.push(apply("mybox", "red"))
#s.push(apply("mybox", "large"))
```

#### `case(..modifiers)`

Defines a reusable transformation for styling or wrapping content.

**Parameters:**
- `..modifiers` (named + positional): Named styling properties and positional wrapper functions

**Named arguments** become style properties:
```typst
#case(fill: red, weight: "bold")  // Apply fill and weight properties
```

**Positional arguments** must be functions that transform content:
```typst
#case(text.with(size: 14pt))      // Wrapper function
#case(it => block(it))            // Lambda wrapper
```

**Returns:** A case object that can be applied with `apply()` or referenced by name

### Simultaneous Actions

To apply multiple animations in the same step, group rules in a tuple or array:

```typst
#s.push((apply("left"), apply("right")))  // Both happen together
#s.push((once("a"), once("b"), once("c"))) // All three happen in this step
```

## API Reference

## Examples

### Basic Pause Example

Reveal bullet points one at a time:

```typst
#slide(s => ([
  = My Points
  #pause(s, [- First point])
  #s.push(1)
  #pause(s, [- Second point])
  #s.push(1)
  #pause(s, [- Third point])
  #s.push(1)
], s))
```

### Tagging and Animation

Mark content and apply transformations:

```typst
#slide(s => ([
  #let tag = tag.with(s)
  = Animated Content
  
  #tag("title")[Hello World!]
  #tag("subtitle")[Step-by-step animation]
  
  // Step 1: Show title
  #s.push(apply("title", text.with(size: 32pt)))
  
  // Step 2: Show subtitle and make title blue
  #s.push(apply("title", text.with(fill: blue)))
  #s.push(apply("subtitle", text.with(style: "italic")))
], s))
```

### Using Objects and Cases

Create a reusable component with named states:

```typst
#let fancy-box = object(
  rect,
  normal: case(width: 3cm, height: 2cm, fill: blue),
  highlight: case(width: 3cm, height: 2cm, fill: yellow, stroke: black),
  large: case(width: 5cm, height: 4cm),
)

#slide(s => ([
  #let tag = tag.with(s)
  #tag("box", fancy-box[Content])
  
  #s.push(apply("box", "normal"))
  #s.push(apply("box", "highlight"))
  #s.push(apply("box", "large"))
], s))
```

### Simultaneous Changes

Coordinate animations across multiple elements:

```typst
#slide(s => ([
  #let tag = tag.with(s)
  
  #grid(columns: 2fr, gap: 1em)[
    #tag("left")[Left item]
  ][
    #tag("right")[Right item]
  ]
  
  // Both appear together
  #s.push((
    apply("left", text.with(fill: red)),
    apply("right", text.with(fill: green)),
  ))
  
  // Both change together
  #s.push((
    once("left", text.with(weight: "bold")),
    once("right", text.with(weight: "bold")),
  ))
], s))
```

### Slide-Level Cases

Define global cases available throughout a slide:

```typst
#slide(
  defined-cases: (
    "error": case(text.with(fill: red, weight: "bold")),
    "success": case(text.with(fill: green, weight: "bold")),
    "highlight": case(block.with(fill: yellow.transparentize(80%))),
  ),
  s => ([
    #let tag = tag.with(s)
    
    #tag("msg1")[Operation completed]
    #tag("msg2")[Check the results]
    
    #s.push(apply("msg1", "success"))
    #s.push(apply("msg2", "highlight"))
  ], s),
)
```

### Handout Mode

Generate a static version showing all steps:

```typst
// Enable handout mode globally
#let (slide,) = set-option(handout: true)

// Now all slides generate multi-page handouts with all steps visible
#slide(s => ([
  #let tag = tag.with(s)
  #tag("content")[This content evolves]
  #s.push(apply("content", text.with(fill: red)))
  #s.push(apply("content", text.with(weight: "bold")))
], s))
```

### Advanced: Content Modification

Transform and combine transformations across steps:

```typst
#slide(s => ([
  #let tag = tag.with(s)
  = Evolution
  
  #let shape = object(
    rect.with(width: 2cm, height: 2cm),
    grow: case(width: 3cm, height: 3cm),
    color-red: case(fill: red),
    color-blue: case(fill: blue),
  )
  
  #tag("obj", shape[Box])
  
  // Step 1: Show at normal size
  #s.push(apply("obj"))
  
  // Step 2: Grow (box is now 3cm x 3cm)
  #s.push(apply("obj", "grow"))
  
  // Step 3: Color red (remains grown, now red)
  #s.push(apply("obj", "color-red"))
  
  // Step 4: Switch to blue (remains grown)
  #s.push(cover("obj", "color-blue"))
], s))
```

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions welcome! Please feel free to submit issues and pull requests.
