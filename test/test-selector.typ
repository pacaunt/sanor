#import "../src/selector.typ": *

#show select($a_b$): set text(fill: red)

#select($a^2$.body)

$ a^2 a + a_b $

#show select($(a + b)$): set text(fill: red)
// #show select($integral$.body): set text(fill: green)
// #show select(math.integral): set text(fill: blue)


$ (a + b)^2(c + d) integral_0^2  $

#show select($a + b$): set text(fill: orange)
$a + b$
$ #$a + b$ + c + d + a + b $

#import "@local/chemformula:0.1.3": ch 

#show select(ch("e-")): set text(fill: green)
#ch("Na")
#ch("e-")

#ch("Na -> Na+ + e-")
$ ch("Cl + e- -> Cl-") $