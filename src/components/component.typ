#import "../object-case.typ": case, object
#import "../sanor.typ": tag

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