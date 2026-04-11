#let resolve-length(lng, unit: 0cm) = if type(lng) in (int, float) { 
  lng * unit 
} else { 
  lng 
}

#let resolve-coordinate((a, b), unit: 0cm) = {
  if type(a) == angle and type(b) != angle {
    b = resolve-length(b, unit: unit)
    let x = b * calc.cos(a)
    let y = b * calc.sin(a)
    return (x, y)
  } else {
    return (a, b).map(resolve-length.with(unit: unit))
  }
}

#let place(coord, anchor: center + horizon, unit: 1cm, body) = {
  let (dx, dy) = resolve-coordinate(coord, unit: unit)
  std.place(dx: dx, dy: dy, std.place(anchor, body))
}

#let rect(center, size: auto, anchor: center + horizon, unit: 1cm, body, ..styles) = {
  let (width, height) = (auto, auto)
  if type(size) == array and size.len() == 2 {
    (width, height) = size.map(resolve-length.with(unit: unit))
  }
  place(center, anchor: anchor, unit: unit, std.rect(
    width: width,
    height: height,
    body,
    ..styles,
  ))
}

#let circle(center, radius: auto, anchor: center + horizon, unit: 1cm, body, ..styles) = {
  radius = resolve-length(radius, unit: unit)
  place(center, anchor: anchor, unit: unit, std.circle(radius: radius, body, ..styles))
}

#let ellipse(center, size: auto, anchor: center + horizon, unit: 1cm, body, ..styles) = {
  let (width, height) = (auto, auto)
  if type(size) == array and size.len() == 2 {
    (width, height) = size.map(resolve-length.with(unit: unit))
  }
  place(center, anchor: anchor, unit: unit, std.ellipse(
    width: width, 
    height: height, 
    body, 
    ..styles
  ))
}
