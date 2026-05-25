#import "../src/class.typ": *

#let Data-A = class("data", fill: red)
#let Data-B = class("data", body: none)

#is-class(Data-A)
#is-class(Data-B)


#let Obj = Class(
  "object",
  fields: (
    stylers: (:),
    wrappers: (:),
  ),
  methods: (
    new: (self, ..modifiers) => {
      self.stylers = modifiers.named()
      self.wrappers = modifiers.pos()
      assert(self.wrappers.all(w => type(w) == function), message: "All positional arguments must be a function")
      return self
    },
  ),
)

#let mydata = (Obj.new)(fill: red, body: none)

#mydata

