#import "../../../src/sanor.typ": *

#let test(input, expected) = {
  let is-pass = input == expected
  let result = if is-pass {
    text(fill: olive, strong[PASS])
  } else {
    text(fill: red, strong[NOT PASS])
  }
  (input, expected, result)
}

#let test-table(body, ..kwargs) = {
  table(
    columns: 3,
    table.header[Input][Expected][Result],
    ..kwargs,
    ..body.map(i => [#i]),
  )
}

#test-table({
  test(
    parse-array(([A], next, [B], [C]), subslide: 0),
    (max: 1, result: (hide[A], hide[B], hide[C])),
  )
  test(
    parse-array(([A], next, [B], [C]), subslide: 1),
    (max: 1, result: ([A], hide[B], hide[C])),
  )
  test(
    parse-array(([A], next, [B], [C]), subslide: 2),
    (max: 1, result: ([A], [B], [C])),
  )
  test(
    parse-array(([A], next, [B], next, [C]), subslide: 0),
    (max: 2, result: (hide[A], hide[B], hide[C])),
  )
  test(
    parse-array(([A], next, [B], next, [C]), subslide: 1),
    (max: 2, result: ([A], hide[B], hide[C])),
  )
  test(
    parse-array(([A], next, [B], next, [C]), subslide: 2),
    (max: 2, result: ([A], [B], hide[C])),
  )
  test(
    parse-summed-array(([A], next, [B], [C]), subslide: 0), 
    (max: 1, result: ("([A], [B], [C])",),)
  )
  test(
    parse-summed-array(([A], next, [B], [C]), subslide: 1), 
    (max: 1, result: ([A], "([B], [C])"))
  )
  test(
    parse-summed-array(([A], next, [B], [C]), subslide: 2), 
    (max: 1, result: ([A], [B], [C]))
  )
   test(
    parse-summed-array(([A], next, [B], next, [C]), subslide: 1), 
    (max: 2, result: ([A], "([B], [C])"),)
  )
  test(
    parse-summed-array(([A], next, [B], next, [C]), subslide: 2), 
    (max: 2, result: ([A], [B], "([C],)"))
  )
  test(
    parse-sequence(([A], next, [B], [C]), subslide: 0), 
    (max: 1, result: (hide(sequence(([A], [B], [C]))),))
  )
  test(
    parse-sequence(([A], next, [B], [C]), subslide: 1), 
    (max: 1, result: ([A], hide(sequence(([B], [C]))),))
  )
  test(
    parse-sequence(([A], next, [B], [C]), subslide: 2), 
    (max: 1, result: ([A], [B], [C]))
  )
  
})
