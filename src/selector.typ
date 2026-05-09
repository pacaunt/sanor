#import "utils.typ": strfmt

#let select(element) = {
  if type(element) in (str, selector, function, regex, symbol) {
    return selector(element)
  } 
  
  if type(element) == content {
    // extract the element in math mode.
    if element.func() == math.equation {
      element = element.body
    }

    let func = element.func()
    let fields = element.fields()

    return selector(func.where(..fields))
  }

  panic(strfmt("Unresolvable element `{}` for casting to selector.", element))
}
