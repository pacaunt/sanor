// #scene({
//   frame(tag => {

//   })
//   apply(name)
//   pause([Some Content])
//   once(name)
// })
#import "utils.typ"

#let class(
  name,
  fields: (:),
  methods: (:),
) = {
  let self = fields + methods
  // handle the `new` methods
  if "new" not in methods {
    methods.new = (self, ..new-fields) => self + new-fields.named()
  }
  // initializing
  self.__sanor_class_name = name
  self.__sanor_class_methods = () => methods
  // process the methods
  // At this point, the methods in self are not yet resolved.
  // (method in self.method does not receive the `self` argument)
  //                                                 vvvv
  self += utils.map-dict-values(methods, f => f.with(self))
  // At this point, the methods in self are resolved completely.
  self += utils.map-dict-values(methods, f => f.with(self))

  return self
}

#let class-of(obj) = {
  if type(obj) == dictionary and "__sanor_class_name" in obj {
    obj.__sanor_class_name
  } else {
    type(obj)
  }
}

#let compile(obj) = {
  let updated-methods = utils.map-dict-values(
    (obj.__sanor_class_methods)(),
    f => f.with(obj),
  )
  obj += updated-methods

  return obj
}

#let Case = class(
  "case",
  fields: (
    stylers: (:),
    wrappers: (),
  ),
  methods: (
    new: (self, ..modifiers) => {
      self.stylers = modifiers.named()
      self.wrappers = modifiers
        .pos()
        .map(m => {
          if type(m) != function { it => m } else { m }
        })
      return compile(self)
    },
    combine: (self, ..cases) => {
      for case in cases.pos() {
        self.stylers = utils.merge-dicts(base: self.stylers, case.stylers)
        self.wrappers += case.wrappers
      }
      return compile(self)
    },
    ensure: (self, maybe-case, defined-cases: (:)) => {
      if class-of(maybe-case) == "case" {
        return maybe-case
      }
      if class-of(maybe-case) == str {
        return defined-cases.at(maybe-case)
      }
      if class-of(maybe-case) == dictionary {
        return (self.new)(..maybe-case)
      }
      if class-of(maybe-case) == function {
        return (self.new)(maybe-case)
      }
      return (self.new)(it => maybe-case)
    },
  ),
)

#let case(..modifiers) = (Case.new)(..modifiers)

// TEST 1
#let c1 = case(fill: red, body: [])
#let c2 = case(it => it)
#let cmp = (c1.combine)(c2)

#let Object = class(
  "object",
  fields: (
    func: () => none,
    cases: (hidden: case(hide), base: case(it => it)),
  ),
  methods: (
    new: (self, func, named-cases) => {
      self.func = func
      // The base case MUST NOT rely on the other cases.
      if "base" in named-cases {
        self.cases.base = (Case.ensure)(named-cases.remove("base"))
      }
      let cases = utils.map-dict-values(
        named-cases,
        c => (Case.ensure)(c, defined-cases: self.cases),
      )
      self.cases += cases

      return compile(self)
    },
    call: (self, ..args) => (self.func)(..args),
    when: (self, ..maybe-cases) => {
      let stylers = maybe-cases.named()
      let cases = maybe-cases.pos().map(c => (Case.ensure)(c, defined-cases: self.cases))

      let combined-cases = (Case.combine)(..cases, (Case.new)(..stylers))

      return utils.pipe(
        (self.func)(..combined-cases.stylers),
        ..combined-cases.wrappers,
      )
    },
    with: (self, ..args) => {
      self.func = self.func.with(..args)

      return compile(self)
    },
    add-case: (self, ..named-cases) => {
      assert(
        named-cases.pos() == (),
        message: "Defined cases must be named arguments",
      )

      self.cases += utils.map-dict-values(
        named-cases.named(),
        Case.ensure.with(defined-cases: self.cases),
      )

      return compile(self)
    },
  ),
)

#let object(func, ..named-cases) = {
  assert(
    named-cases.pos() == (),
    message: "Defined cases must be named arguments",
  )
  (Object.new)(func, named-cases.named())
}

// TEST 2
#let Rect = object(rect, hidden: "base", base: (fill: green))

#(Rect.when)("hidden")
#(Rect.call)([Hello!])
#let Rect2 = (Rect.with)([Body])
#{ Rect2 = (Rect2.add-case)(biggen: case(scale.with(200%), place.with(center))) }

#(Rect2.when)(fill: red, align.with(center))
#(Rect2.when)("biggen")

#let Applier = class(
  "applier",
  fields: (
    kind: "apply",
    target: "name",
    send: true,
    active: true,
    inherit: true,
    cases: (),
  ),
  methods: (
    new: (
      self,
      kind,
      target: "name",
      send: true,
      active: true,
      inherit: true,
      default: "base",
      cases: (),
    ) => {
      self.kind = kind
      self.target = target
      self.send = send
      self.active = active
      self.inherit = inherit
      self.cases = if cases == () { default } else { cases }

      return compile(self)
    },
    make: (self, ..args) => ((self.new)(kind, ..args),),
  ),
)

#let apply(name, inherit: true, ..cases) = (Applier.make)(
  "apply",
  target: name,
  send: true,
  active: true,
  inherit: inherit,
  default: "base",
  cases: (cases.named(), ..cases.pos()),
)

#let once(name, ..cases) = (Applier.make)(
  "once",
  target: name,
  send: false,
  active: true,
  inherit: true,
  default: "base",
  cases: (cases.named(), ..cases.pos()),
)

#let clear(name) = (Applier.make)(
  "clear",
  target: name,
  send: false,
  active: auto,
  inherit: false,
  default: "base",
  cases: (),
)

#let cover(name, ..cases) = (Applier.make)(
  "apply",
  target: name,
  send: false,
  active: false,
  inherit: false,
  default: "hidden",
  cases: (cases.named(), ..cases.pos()),
)

#let revert(name, ..cases) = (Applier.make)(
  "apply",
  target: name,
  send: true,
  active: auto,
  inherit: false,
  default: "base",
  cases: (cases.named(), ..cases.pos()),
)

#let force(name, ..cases) = apply(name, ..cases, inherit: false)

#let preprocess(rules) = rules.map(r => {
  if type(r) == str {
    return apply(r)
  }
  if class-of(r) == "applier" {
    return r
  }
  if type(r) == array {
    return preprocess(r)
  }
  panic(strfmt("Unexpected rule specification `{}`", r))
})

// IDEA for multiple tags
// The data:
// name1: ((), (), (cases1..), (), ())
// name2: ((), (..cases2), (), (), ())
// The `tag`, which knows all of the aliases, should combine it to
// modifiers: ((), (..cases2), (..cases1), (), ())
// resolve the history, then process the current applier for the current step.

