#import "../object-case.typ": case, object
#import "../sanor.typ": tag

/// Component constructor
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