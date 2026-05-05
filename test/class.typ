#import "../src/class.typ": *

#let Data-A = class("data", fill: red)
#let Data-B = class("data", body: none)

#is-class(Data-A)
#is-class(Data-B)

#match-class(Data-A, Data-B)