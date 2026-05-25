#import "utils.typ"
#import "class.typ": *

// GOAL:
// #slide(tag => {
//   tag(name, tag => {
//     tag(name, object)
//   })
// })(
//   apply(action),
//   apply(action),
//   once(action) + apply(action),
// )

#let Object(func, modifiers) = class(
  "object",
  func: func, 
)