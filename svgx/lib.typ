#let svgx = plugin("svgx.wasm")

/// Modified the svg-string by applying the provided properties to elements matching the specified id or class.
/// -> str
#let change-svg(
  // The SVG sourceto be modified
  // -> bytes
  svg-bytes,
  // Optional id to target specific elements  
  // -> str or none
  id: none, 
  // Optional class to target specific elements
  // -> str or none
  class: none, 
  // A dictionary of properties to apply to the targeted elements
  // -> property
  ..properties
) = {
  let changes = bytes(json.encode((
    target_id: id, 
    target_class: class, 
    properties: properties.named()
  )))

  svgx.apply_changes(svg-bytes, changes)
}

/// Apply changes to svg elements by assigning multiple properties
/// at once. 
/// -> bytes
#let apply-changes(
  // The svg source. Please use it by the following examples.
  // 
  // ```typst 
  // #let img = read("image.svg")
  // #let changed = apply-changes(bytes(img), /* changes */)
  // #image(changed)
  // ```
  // -> bytes
  svg-bytes, 
  // The changes 
  // -> dictionary in the form `key : value`
  ..changes
) = {
  let changes = changes.pos()
  let img-bytes = svg-bytes
  for change in changes {
    img-bytes = change-svg(img-bytes, ..change)
  }
  return img-bytes
}