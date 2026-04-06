#import "utils.typ"
#import "object.typ": object, call-object, update-modifier

#let make-object(
  func,
  ..modify-cases,
) = (..args) => {
  let obj = object(func, ..modify-cases)(..args)
  let cases = obj(show-all: true).modifiers
  let base = func(..args)
  let result = (__base__: base)
  for case in cases.keys() {
    result.insert(case, call-object(obj, case))
  }
  return (..m) => {
    let out = (object(func, ..result)(..args)(..m))
    out.at("modifier", default: out)
  }
}

#let _tag(
  // the context of animation
  // -> info
  s,
  // identifier
  // -> str
  name,
  // the body
  // -> any | object
  body,
  // hiding function or methods
  // -> any
  hider: auto,
  // the ways to manipulate the body.
  ..cases,
) = {
  let info = s.tag-info
  let default-case = if info.is-shown { "__base__" } else { "hidden" }
  let current-state = info.tags.at(name, default: (case: default-case, modifier: (:)))
  let defined-case = info.defined-states

  if hider == auto { hider = info.hider }
  // make all body be an object
  if type(body) != function {
    body = object(() => body, hidden: hider, ..defined-case, ..cases)()
  }
  body = update-modifier(body, ..defined-case)
  body = update-modifier(body, ..((current-state.case): current-state.modifier))
  return call-object(body, current-state.case)
}

/// There are 3 types of state:
/// 1. once
/// 2. start-apply (apply)
/// 3. stop-apply (clear)
/// A state is in the form:
/// (
///   type: "once",
///   name: {name},
///   case: {case},
///   modifier: {modifier},
/// )


#let _apply(name, ..modifier-cases) = kind => {
  let styles-modifier = modifier-cases.named()
  let modifier-cases = modifier-cases.pos()
  let case = ()
  let modifier = ()
  for mc in modifier-cases {
    if type(mc) == str { case.push(mc) } else { modifier.push(mc) }
  }
  if modifier == () { modifier = styles-modifier }

  return (
    type: kind,
    name: name,
    case: if case.len() == 0 { "__applied__" } else { case.remove(0) },
    modifier: modifier,
  )
}

#let apply(
  name, 
  ..modifier-cases
) = _apply(name, ..modifier-cases)("apply")

#let once(
  name, ..modifier-cases
) = _apply(name, ..modifier-cases)("once")

#let clear(name) = {
  return (
    type: "clear",
    name: name,
    case: "__base__",
    modifier: (:),
  )
}

#let process-a-step(rules, ctx: (:), onces: (:)) = {
  if type(rules) != array { rules = (rules,) }
  for rule in rules {
    if rule.type == "apply" {
      ctx.insert(rule.name, (
        case: rule.case,
        modifier: rule.modifier,
      ))
    }
    if rule.type == "clear" {
      let _ = ctx.remove(rule.name, default: none)
    }
    if rule.type == "once" {
      let case = "__base__"
      let modifier = (:)
      if not onces.at(rule.name, default: false) {
        case = rule.case
        modifier = rule.modifier
        onces.insert(rule.name, true)
      }
      ctx.insert(rule.name, (
        case: case,
        modifier: modifier,
      ))
    }
  }
  return (ctx, onces)
}

#let process-steps(steps) = {
  let ctx = (:)
  let onces = (:)
  let result = ()
  for step in steps {
    let original = ctx
    (ctx, onces) = process-a-step(step, ctx: ctx, onces: onces)
    result.push(ctx)
    for (name, applied) in onces.pairs() {
      if applied {
        if name in original {
          ctx.insert(name, original.at(name))
        } else {
          let _ = ctx.remove(name)
        }
        let _ = onces.remove(name)
      }
    }
  }
  return result
}

#let cover(name) = apply(name, "hidden")
#let revert(name) = apply(name, "__base__")

#let control(i, body-func, steps, hider: hide, is-shown: false) = {
  let commands = process-steps(steps)
  let info = (
    subslide: i,
    tag-info: (
      hider: hider,
      is-shown: is-shown,
      defined-states: (:),
      tags: commands.at(i, default: (:)),
    ),
  )
  body-func(info)
}

#let subslide(info, func) = {
  let i = info.subslide
  {
    set heading(outlined: i == 1, bookmarked: i == 1)
    func(info)
  }
  v(0pt)
  counter(page).update(n => n - 1)
  pagebreak(weak: true)
}

#let superhide(body) = {
  show enum: hide
  show list: hide
  hide(body) 
}

#let options = (
  handout: false,
  subslide: 1,
  tag-info: (hider: hide, is-shown: false, defined-states: (:), tags: (:)),
  handout-index: auto,
)

#let slide(
  info: (:),
  func,
  controls: (),
  hider: superhide,
  is-shown: false,
  defined-states: (:),
) = {
  let info = utils.merge-dicts(
    base: options,
    info
      + (
        tag-info: (
          hider: hider,
          is-shown: is-shown,
          defined-states: defined-states,
        ),
      ),
  )

  let steps = controls.len()
  let commands = process-steps(controls)
  if steps == 0 { steps += 1 }
  if info.handout {
    let index = if info.handout-index == auto { steps - 1 } else { info.handout-index }
    info.tag-info.tags = commands.at(index, default: (:))
    return subslide(info, func)
  } else {
    for i in range(steps) {
      info.tag-info.tags = commands.at(i, default: (:))
      subslide(info, func)
    }
  }
}
