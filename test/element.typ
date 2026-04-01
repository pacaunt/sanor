#import "../src/element.typ": * 
#import "../src/store.typ"
#import "../src/modifier.typ": pause

#let Text = _elem(text, exargs: arguments([Text], fill: green, weight: "bold"))

#Text(modified: true)()

#let Text = reactive(text, exargs: (fill: green))
#let s = store.default 
#{
  s.hider = text.with(fill: red)
}
#{ s.subslide = 5 }

#Text(s)([ABCDEF])

#let Table = elem(table)
#let Etext = elem(text)
#let Cell = elem(it => it)
#Table(pause(s) + {s.pauses += 1})(
  Cell(pause(s) + {s.pauses += 1})([A]), 
  Cell(pause(s) + {s.pauses += 1})([B]), 
  Cell(pause(s) + {s.pauses += 1})([C])
)
#Etext(pause(s))([A B C])

#let group = (s) => elem(it => it)(pause(s))

#group(s)([
  HEY THIS IS A GROUP
])

#group(s)([
  #show: group(s)
  cetz-pause(s)({
    Eh
  })
])

$ A #group(s)($1/2 a^2$) $

#let f = (..args) => (s) => table(..args)

#f(columns: 3)[A][B][C](pause(s))
