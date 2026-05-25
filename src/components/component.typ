#import "../object-case.typ": case, object
#import "../sanor.typ": tag

/// Component constructor
///
/// Helper for building reusable components. Components created with this
/// constructor wrap an `object` and call `tag` for you. Note: the first
/// argument passed at call-time (`tag-s`) may be either a slide context `s`
/// or a `tag` function (for example the result of `tag.with(s)`). The
/// constructor adapts automatically so components can be used both inside
/// `slide` blocks and in helper contexts that already have a bound `tag`.
///
/// - name (str): Default name for the component
/// - func (function): Function to create the component
/// - hidden (case | function): Modifier to apply on the component in hidden case
/// - defined-cases (arguments): Keyword arguments of cases with their name as the key.
/// -> function
#let new(name, func, hidden: case(hide), ..defined-cases) = (
  tag-s,
  name: name,
  defined-cases: defined-cases,
  ..args,
) => {
  let tag = if type(tag-s) == function { tag-s } else { tag.with(tag-s) }
  let obj = object(func, hidden: hidden, ..defined-cases)
  tag(name, obj(..args))
}