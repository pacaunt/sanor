# Sanor

Fast, small, but powerful presentation framework in Typst.

Sanor is a Typst package that provides utilities for creating animated presentations with incremental content reveals, state management, and flexible slide controls.

## Features

- **Incremental Reveals**: Show content step by step with `apply()`, `once()`, and `cover()` functions
- **Content Tagging**: Use `tag()` to mark content that can be animated
- **Object System**: Create reusable objects with different states using `object()`
- **Slide Controls**: Define animation sequences with `s.push()` for flexible step-by-step control
- **Handout Support**: Generate static handouts from animated presentations
- **Subslide Management**: Handle multiple slides within a single frame

## Presentation Package Comparison

There are several Typst presentation packages, and Sanor is designed specifically for animated, stepwise slide control.

| Package | Best fit | Sanor comparison |
| --- | --- | --- |
| `Sanor` | Animated presentations with incremental reveals and stateful slide content | Uses `slide()`, `tag()`, `apply()`, `once()`, and object states to keep presentation logic explicit and reusable. |
| `Touying` | Lightweight slide decks with straightforward page-based slide definitions | Typically simpler than Sanor, with fewer built-in animation primitives. Sanor is stronger when you need fine-grained reveal control and custom state changes. |
| `Polylux` | Design-oriented, theme-focused presentations | Often targeted at polished layout and visual styling. Sanor is more focused on dynamic behavior and step-by-step content sequencing rather than prebuilt visual themes. |
| `presentate` | General Typst presentation framework with slide scaffolding | Usually provides a higher-level slide structure and convenience defaults. Sanor offers more explicit animation controls and handout support for presentations that evolve over multiple steps. |

Use Sanor when your presentation needs incremental content reveals, reusable tagged content, or handout generation. Use `Touying`, `Polylux`, or `presentate` when you prefer a different slide abstraction, default theme, or simpler static deck workflow.

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

#### `slide(options: (:), func, hidden: auto, is-shown: false, defined-states: (:))`

Creates an animated slide where content can be revealed or modified step by step. The function takes a slide context `s` and returns content. Use `s.push()` to add actions that control the animation sequence.

- `options` (dict): Options for the slide, including handout mode, cases, etc.
- `func` (function): A function that takes the slide context `s` and returns the slide content.
- `hidden` (auto, case): The default hidden case.
- `is-shown` (bool): Whether hidden content is shown by default.
- `defined-states` (dict): Predefined states for the slide.

#### `tag(s, name, body, hidden: auto, ..defined-cases)`

Tags content for animation control. This function allows you to mark content that can be modified or revealed step by step during a presentation.

- `s` (context): The slide context provided by `slide()`.
- `name` (str): A unique identifier for the tagged content.
- `body` (content): The content to tag.
- `hidden` (auto, case): The case to use when content is hidden.
- `..defined-cases` (cases): Additional cases defined for this tag.

#### `pause(s, body, hidden: auto)`

Shows content after a certain number of steps. Must be used with `#s.push(1)` for step forward.

- `s` (context): The slide context.
- `body` (content): The content to show after pause.
- `hidden` (auto, case): The case to use when hidden.

#### `set-option(..new-options)`

Sets global options for slides. This function allows you to configure default options for all slides, such as enabling handout mode.

- `..new-options` (any): Named options to set globally.

### Animation Rules

#### `apply(name, ..cases, inherit: true)`

Applies cases to tagged content for the current and all subsequent steps.

- `name` (str): The tag name to apply to.
- `..cases` (any): Cases or modifiers to apply.
- `inherit` (bool): Whether to combine with existing active cases.

#### `once(name, ..cases, inherit: true)`

Applies cases to tagged content for only one step.

- `name` (str): The tag name to apply to.
- `..cases` (any): Cases or modifiers to apply.
- `inherit` (bool): Whether to combine with existing active cases.

#### `cover(name, ..cases)`

Covers tagged content by applying cases and preventing inheritance.

- `name` (str): The tag name to cover.
- `..cases` (any): Cases or modifiers to apply.

#### `revert(name, ..cases)`

Reverts tagged content to specified cases without inheritance.

- `name` (str): The tag name to revert.
- `..cases` (any): Cases or modifiers to apply.

#### `force(name, ..cases)`

Forces application of cases without inheritance. Equivalent to `apply(name, ..cases, inherit: false)`.

- `name` (str): The tag name to force.
- `..cases` (any): Cases or modifiers to apply.

### Simultaneous Actions

To apply multiple actions simultaneously in the same step, use an array:

```typst
#s.push((apply("left"), apply("right")))  // Both applied at once
```

### Object System

#### `object(func, hidden: case(hide), ..defined-cases)`

Creates an object with different states. This function creates a reusable object that can be displayed in different states defined by cases.

- `func` (function): The base function to create the object.
- `hidden` (case): The case to use when the object is hidden.
- `..defined-cases` (cases): Named cases defining different states.

#### `case(..modifiers)`

Creates a case that can modify content with stylers and wrappers.

- `..modifiers` (any): Named stylers and positional wrapper functions.

## Examples

### Basic Animation

```typst
#slide(s => ([
  #let tag = tag.with(s)
  = Basic Animation
  #tag("item1")[- First item]
  #tag("item2")[- Second item]
  #tag("item3")[- Third item]
  #s.push(apply("item1"))
  #s.push(apply("item2"))
  #s.push(apply("item3"))
], s))
```

### Using `pause`

```typst
#slide(s => ([
  This appears immediately.
  #pause(s)[This appears after a step.]
  #s.push(1)
], s))
```

### Content Modification

```typst
#slide(s => ([
  #let tag = tag.with(s)
  #tag("text", text(size: 28pt)[Hello World])
  #s.push(apply("text"))
  #s.push(apply("text", text.with(fill: blue)))
  #s.push(apply("text", text.with(fill: red, weight: "bold")))
], s))
```

### Using Objects

```typst
#let colored-box = object(
  rect,
  normal: case(width: 4cm, height: 3cm, fill: blue),
  highlighted: case(width: 4cm, height: 3cm, fill: yellow),
)

#slide(s => ([
  #let tag = tag.with(s)
  #tag("box", colored-box()[Normal Box])
  #s.push(apply("box"))
  #s.push(apply("box", "highlighted"))
], s))
```

### Simultaneous Changes

```typst
#slide(s => ([
  #let tag = tag.with(s)
  #tag("left", place(left)[Left])
  #tag("right", place(right)[Right])
  #s.push((apply("left"), apply("right"))) // Both at once
], s))
```

### Handout Mode

```typst
// For global handout mode
#let (slide,) = set-option(handout: true)

// For per-slide handout
#slide(options: (handout: true), s => ([ /* content */ ], s))
```

## Advanced Usage

### Custom States

```typst
#slide(s => ([
  #let tag = tag.with(s)
  #tag("text", [Hello], faded: case(text.with(fill: gray)))
  #s.push(apply("text"))
  #s.push(apply("text", "faded"))
], s))
```


## License

MIT License - see LICENSE file for details.

## Contributing

Contributions welcome! Please feel free to submit issues and pull requests.
