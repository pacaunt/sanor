#import "utils.typ" as utils: strfmt
#import "object-case.typ": *

/// The `cases` are an array of cases.
/// `Applier` tells what kind of rule we are dealing with.
/// - kind -> "apply" | "once" | "clear", class of the action. "once" will make the animation appears only one step, while the others retain their visibility.
/// - inherited -> bool : whether to combine with previous active cases,
/// - retained -> bool : whether to retain the animation to the next cases,
/// - active -> true | false | auto: ability to change the visibility state of the element. 'true' makes it visible, 'false' makes it hidden, 'auto' retains the previous state.
#let Applier(
  kind,
  cases,
  inherit: true,
  remain: true,
  active: auto,
) = class(
  "applier",
  kind: kind,
  cases: cases,
  inherit: inherit, 
  remain: remain,
  active: active,
)

#let Rule(name, applier) = class("rule", name: name, applier: applier)

/// Constructor for an applier
/// 'maybe-cases' may be 'cases' or 'name' of the element.
/// 'kwarg-cases' is for changing properties of the element (as object).
#let make-applier(
  kind, 
  ..maybe-cases, 
  inherit: true, 
  remain: true, 
  active: auto
) = {
  let kwarg-cases = maybe-cases.named()
  let arg-cases = maybe-cases.pos()
  let all-cases = ()
  // Filtering out the empty modifiers
  if kwarg-cases != (:) { 
    all-cases += (kwarg-cases,)
  }
  if arg-cases != () {
    all-cases += arg-cases
  }

  Applier(kind, all-cases, inherit: inherit, remain: remain, active: active)
}

#let rule(name, applier, default: "base") = {
  // ensure name is a string
  name = str(name) 
  // apply default cases
  if applier.cases == () { applier.cases = (default,) }

  return Rule(name, applier)
}

/// Applies cases to tagged content for the current and all subsequent steps.
///
/// This function creates a rule that applies the specified cases to content
/// tagged with the given name, and keeps those cases active in future steps.
///
/// - name (str): The tag name to apply to.
/// - ..cases (any): Cases or modifiers to apply.
/// - inherited (bool): Whether to combine with existing active cases.
/// -> rule
///
/// #example ```typst
/// #slide(s => ([
///   #let tag = tag.with(s)
///   #tag("text")[Hello]
///   #s.push(apply("text", text.with(fill: red)))
/// ], s))
/// ```
#let apply(name, ..cases, inherit: true, remain: true, active: true) = rule(
  name,
  default: "base",
  make-applier("apply", ..cases, inherit: inherit, remain: remain, active: active),
)

/// Applies cases to tagged content for only one step.
///
/// This function creates a rule that applies the specified cases to content
/// tagged with the given name, but only for the current step.
///
/// - name (str): The tag name to apply to.
/// - ..cases (any): Cases or modifiers to apply.
/// - inherited (bool): Whether to combine with existing active cases.
/// -> rule
///
/// #example ```typst
/// #slide(s => ([
///   #let tag = tag.with(s)
///   #tag("text")[Hello]
///   #s.push(once("text", text.with(fill: red)))
///   #s.push(1)  // Next step, red is gone
/// ], s))
/// ```
#let once(name, ..cases, inherit: true, remain: false, active: true) = rule(
  name,
  default: "base",
  make-applier("once", ..cases, inherit: inherit, remain: remain, active: active),
)

/// Covers tagged content by applying cases and preventing inheritedance.
///
/// This function hides content by applying the specified cases without
/// inheriteding previous modifications.
///
/// - name (str): The tag name to cover.
/// - ..cases (any): Cases or modifiers to apply.
/// -> rule
///
/// #example ```typst
/// #slide(s => ([
///   #let tag = tag.with(s)
///   #tag("text")[Hello]
///   #s.push(cover("text"))  // Hides the text
/// ], s))
/// ```
#let cover(name, ..cases, inherit: true, remain: true, active: false) = rule(
  name,
  default: "hidden",
  make-applier("apply", ..cases, inherit: inherit, remain: remain, active: active),
)

/// Reverts tagged content to specified cases without inheritance.
/// This keeps the previous modifications, unlike 'clear'
///
/// This function applies the specified cases to content without combining
/// with previous modifications.
///
/// - name (str): The tag name to revert.
/// - ..cases (any): Cases or modifiers to apply.
/// -> rule
///
/// #example ```typst
/// #slide(s => ([
///   #let tag = tag.with(s)
///   #tag("text")[Hello]
///   #s.push(apply("text", text.with(fill: red)))
///   #s.push(revert("text", text.with(fill: blue)))  // Only blue, not red+blue
/// ], s))
/// ```
#let revert(name, ..cases, inherit: false, remain: true, active: auto) = rule(
  name,
  default: "base",
  make-applier("revert", ..cases, inherit: inherit, remain: remain, active: active),
)

/// Forces application of cases without inheritance.
///
/// This is equivalent to `apply(name, ..cases, inherited: false)`.
///
/// - name (str): The tag name to force.
/// - ..cases (any): Cases or modifiers to apply.
/// -> rule
///
/// #example ```typst
/// #slide(s => ([
///   #let tag = tag.with(s)
///   #tag("text")[Hello]
///   #s.push(force("text", text.with(fill: red)))
/// ], s))
/// ```
#let force(name, ..cases) = apply(name, ..cases, inherit: false)

/// Clear the previous animation sequence on an element.
/// 
/// - name (str): The tag name of the element to clear.
/// -> rule
#let clear(name, ..cases) = rule(
  name,
  default: "base",
  make-applier("clear", ..cases, inherit: false, remain: true, active: true)
)