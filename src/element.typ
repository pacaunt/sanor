#import "utils.typ"
#import "store.typ"
#import "modifier.typ"

#let modify(func, appliers, ..exargs) = {
  if type(appliers) != array { appliers = (appliers,) }
  return (..args) => {
    let base = func(..args, ..exargs)
    utils.pipe(base, ..appliers)
  }
}

/// Syntax for reactive element in sanor
/// Every element will be a function that must receive a
/// context state `s` before accessing the actual function.
/// Then the element will be reactive to whatever update was done to `s`.
#let _elem(
  func,
  exargs: arguments(),
  applier: it => it,
  modified: false,
) = (
  modified: modified,
  applier: applier,
  exargs: exargs,
) => {
  if modified { modify(func, applier, ..exargs) } else { func }
}

#let elem(func, exargs: (:), applier: it => it, modified: false) = (
  modified: modified,
  applier: applier,
  exargs: exargs,
  ..args,
) => {
  let args = args.pos()

  assert(args.len() <= 1, message: "Element accepts atmost one positional argument.")

  let mod = if args.len() > 0 { args.first() } else {
    (modified: modified, exargs: exargs, applier: applier)
  }

  _elem(func)(..mod)
}

#let reactive(func, exargs: (:), hider: auto) = s => {
  elem(func)(modifier.pause(s, exargs: exargs, hider: hider))
}
// #let reactive(func, exargs: (:), hider: auto) = s => {
//   let mod = modifier.pause(s, exargs: exargs, hider: hider)
//   return elem(func)(s, mod: mod)
// }

