#import "utils.typ": strfmt

/// `class` is a dictionary with a `name` that is like a label that differentiate between each objects
#let class(name, ..fields) = {
  assert(fields.pos().len() == 0, message: "Fields of a class must be keyword arguments.")
  (
    __sanor_class_name: name,
    ..fields.named(),
  )
}

/// Check if the `obj` is a class and optionally whether the class is `name`.
#let is-class(obj) = {
  type(obj) == dictionary and "__sanor_class_name" in obj
}

/// returns the 'class' or 'type' of the `obj`.
#let class-of(obj) = {
  if is-class(obj) { obj.__sanor_class_name } else { type(obj) }
}

#let Class(name, fields: (:), methods: (:)) = {
  fields.__sanor_class_name = name 
  fields.new = (self) => fields
  for (k, m) in methods.pairs() {
    fields.insert(k, m.with(fields))
  }
  fields
}

#let compile(data) = {

}