#import "../src/selector.typ": *

#show select($a_b$): set text(fill: red)

#select($a^2$)

$ a^2 a + a_b $

#show select($(a + b)$): set text(fill: red)
// #show select($integral$.body): set text(fill: green)
// #show select(math.integral): set text(fill: blue)


$ (a + b)^2(c + d) integral_0^2  $
