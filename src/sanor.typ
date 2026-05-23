#import "utils.typ"
#import "object-case.typ": case, provide-object, class-of
#import "process.typ": _process, get-total-steps
#import "class.typ"
#import "pdfpc.typ"

#let resolve(s, name) = {
  let (ctx, ..) = s
  ctx
    .cases
    .at(name, default: ())
    .at(ctx.subslide - 1, default: (
      if ctx.is-shown { ("base",) } else { ("hidden",) }
    ))
}

// raw tag function
#let _tag(s, name, body, hidden: auto, ..defined-cases) = {
  let (ctx, ..) = s
  if hidden == auto and class-of(body) != "object" { 
    hidden = ctx.defined-cases.remove("hidden") 
  }
  let resolved-cases = resolve(s, name)
  provide-object(
    body,
    ..ctx.defined-cases,
    ..defined-cases,
    hidden: hidden,
  )(..resolved-cases)
}

/// Tags content for animation control.
///
/// This function allows you to mark content that can be modified or revealed
/// step by step during a presentation.
///
/// - s (context): The slide context provided by `slide()`.
/// - name (str): A unique identifier for the tagged content.
/// - body (content): The content to tag.
/// - hidden (auto, case): The case to use when content is hidden.
/// - ..defined-cases (cases): Additional cases defined for this tag.
/// -> content
///
/// #example ```typst
/// #slide(s => ([
///   #let tag = tag.with(s)
///   #tag("hello")[Hello World!]
///   #s.push(apply("hello", text.with(fill: red)))
/// ], s))
/// ```
#let tag(s, name, body, hidden: auto, ..defined-cases) = {
  if type(body) == function {
    // nested tag will apply without hidden by default
    body = body(_tag.with(s, hidden: "base"))
  }
  _tag(s, name, body, hidden: hidden, ..defined-cases)
}

/// The `pause` function.
/// Show the content after the current number of calls
/// Must be used with `#s.push(1)` for step forward, or
/// #s.push(-1) for stepping backward.
/// -> content
///
/// #example ```typst
/// #slide(s => ([
///   This is visible immediately.
///   #pause(s)[This appears after pushing a step.]
///   #s.push(1)
/// ], s))
/// ```
#let pause(s, body, hidden: auto) = {
  let (ctx, ..actions) = s
  let current-step = get-total-steps(actions)
  let hidden-case = if hidden == auto { ctx.defined-cases.hidden } else { hidden }
  let obj = provide-object(body, hidden: hidden-case)

  if ctx.subslide > current-step {
    obj("base")
  } else {
    obj("hidden")
  }
}

#let subslide(ctx, func) = {
  let (body, (ctx, ..)) = func((ctx,))
  let i = ctx.subslide

  {
    set heading(outlined: i == 1, bookmarked: i == 1)
    body

    if i > 1 {
      counter(page).update(n => n - 1)
    }
    pdfpc.pdfpc-slide-markers(ctx)
  }

  v(0pt)
  pagebreak(weak: true)
}

#let superhide(body) = {
  show enum: hide
  show list: hide
  hide(body)
}

/// The `cases` should be
/// (
///   name-1: (..array of cases,),
///   name-2: (..array of cases,),
/// )
#let default-options = (
  handout: false,
  handout-index: auto,
  cases: (:),
  subslide: 1,
  step: 1,
  total-steps: 1,
  defined-cases: (hidden: case(superhide)),
  is-shown: false,
)

/// The main slide function.
///
/// Creates an animated slide where content can be revealed or modified step by step.
/// The function takes a slide context `s` and returns content. Use `s.push()` to add actions
/// that control the animation sequence.
///
/// - options (dict): Options for the slide, including handout mode, cases, etc.
/// - func (function): A function that takes the slide context `s` and returns the slide content.
/// - hidden (auto, case): The default hidden case.
/// - is-shown (bool): Whether hidden content is shown by default.
/// - defined-states (dict): Predefined states for the slide.
/// -> content
///
/// #example ```typst
/// #slide(s => ([
///   #let tag = tag.with(s)
///   #tag("hello")[Hello from Sanor!]
///   #s.push(apply("hello"))
/// ], s))
/// ```
#let slide(
  options: default-options,
  func,
  hidden: auto,
  is-shown: false,
  defined-cases: (:),
) = {
  let base-ctx = utils.merge-dicts(base: default-options, options)
  let ctx = utils.merge-dicts(
    base: base-ctx,
    options
      + (
        is-shown: is-shown,
        defined-cases: defined-cases
          + (
            hidden: if hidden == auto { case(superhide) } else { hidden },
          ),
      ),
  )

  let (_, (_, ..actions)) = func((ctx,))

  let steps = get-total-steps(actions)
  ctx = _process(ctx, actions)

  if steps == 0 { steps += 1 }

  if ctx.handout {
    ctx.subslide = if ctx.handout-index == auto { steps } else { ctx.handout-index }

    return subslide(ctx, func)
  } else {
    for i in range(steps) {
      ctx.subslide = i + 1
      subslide(ctx, func)
    }
  }
}

/// A function for creating a slide, with an animation-context-included `tag` function.  
/// 
/// Unlike the slide function, the animation context is already included in the `tag` callback.
/// The rules for displaying the components must be specified in the `controls` argument instead.
///
/// - options (dictionary): A configuration option defined to control the behavior of the slide.
/// - func (function): A function that receives a `tag` function and returns content
/// - hidden (auto | case | function): Default modifier for tagged components in its hidden state.
/// - is-shown (bool): Whether to shown the tagged components by default when the component is not called by the control rules.
/// - defined-cases (dictionary): A dictionary whose key is a name and value is a case to modify the tagged components.
/// - controls (rule): An array of rules that will be applied for each step of the animation
/// -> content
#let scene(
  options: default-options,
  func,
  hidden: auto,
  is-shown: false,
  defined-cases: (:),
  controls: (),
) = slide(
  s => (func(tag.with(s)), s + controls),
  options: options,
  hidden: hidden,
  is-shown: is-shown,
  defined-cases: defined-cases,
)

/// Sets global options for slides.
///
/// This function allows you to configure default options for all slides,
/// such as enabling handout mode or defining default cases.
///
/// - ..new-options (any): Named options to set globally.
/// -> dict
///
/// #example ```typst
/// #let (slide,) = set-option(handout: true)
/// ```
#let set-option(..new-options) = {
  let options = utils.merge-dicts(base: default-options, new-options.named())
  return (
    slide: slide.with(options: options),
    scene: slide.with(options: options),
  )
}
