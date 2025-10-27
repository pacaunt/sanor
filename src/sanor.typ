/// User interface
/// ```typ
/// #slide[
///   A #next B
/// ]
/// ```
/// For simple pauses.
///
/// For package integration:
/// #let canvas = render(func: canvas, hider: it => ..)
/// Then
/// #canvas({
///   A
///   (next,)
///   B
/// })
/// or
/// #canvas(
///   A, next, B
/// )

#let prefix = "_sanor-0.1.0"

#let sequence = [].func()

#let states = (
  slides: 1,
  subslide: 1,
  hider: hide,
  pause: (hider: auto, update: true),
  only: (hider: it => none, update: false),
  uncover: (hider: auto, update: false),
  indices: (),
)

#let next = metadata(prefix + "_next-marker")

#let parse-array(
  // start index
  start: 0,
  // current subslide
  subslide: 0,
  // hider function to hide stuff inside array
  hider: hide,
  // the array to parse
  arr,
) = {
  let result = ()
  for item in arr {
    if item == next {
      start += 1
      continue
    }

    if subslide > start {
      result.push(item)
    } else {
      result.push(hider(item))
    }
  }
  return (max: start, result: result)
}


#let parse-summed-array(
  // start index
  start: 0,
  // current subslide
  subslide: 0,
  // hider function to hide array of elements that need to be hidden.
  hider: it => (repr(it),),
  // the array to parse
  arr,
) = {
  let result = ()
  let hidden = ()
  let shown = ()
  for item in arr {
    if item == next {
      start += 1
      continue
    }

    if subslide > start {
      shown.push(item)
    } else {
      hidden.push(item)
    }
  }
  shown = if shown.len() == 0 {} else { shown }
  hidden = if hidden.len() == 0 {} else { hider(hidden) }
  return (max: start, result: shown + hidden)
}

#let parse-sequence = parse-summed-array.with(hider: it => (hide(it.sum()),))
