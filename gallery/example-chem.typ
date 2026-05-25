#import "@preview/sanor:0.3.0": *

// Set up presentation format.
#set page(paper: "presentation-16-9", fill: luma(20))
#set text(size: 25pt, fill: white)

#import "@preview/chemformula:0.1.3": ch

#slide(
  defined-cases: ("grayed": text.with(fill: gray.transparentize(70%))),
  s => (
    [
      #let tag = tag.with(s)
      = Chemical Reaction
      #set align(center + horizon)
      #tag(1, tag => {
        $
          ch("aA + bB -> cC + dD")
        $
      })
    
      #tag("species")[#ch("A"), #ch("B"), #ch("C"), and #ch("D") are _chemical species_.] \
      #tag("stoi")[$a$, $b$, $c$, and $d$ are _stoichiometric coefficients_.] \
      #tag("rxttext", [#ch("A") and #ch("B") are _reactants_.]) \
      #tag("prdtext", [#ch("C") and #ch("D") are _products_.])

      #s.push(apply(1))
      #s.push((
        once(1, it => {
          show regex("[ABCD]"): set text(fill: fuchsia)
          it
        }),
        apply("species", it => {
          show regex("[ABCD]"): set text(fill: fuchsia)
          show emph: set text(fill: fuchsia)
          it
        })
      ))

      #s.push((
        once(1, it => {
          show math.equation: eq => {
            show regex("[abcd]"): set text(fill: green)
            eq
          }
          it
        }), 
        apply("stoi", it => {
          show math.equation: eq => {
            show regex("[abcd]"): set text(fill: green)
            show emph: set text(fill: green)
            eq
          }
          it
        }),
        force("species", "grayed")
      ))

      #s.push((
        once(1 , it => {
          show regex("A|B"): set text(fill: yellow)
          it
        }),
        apply("rxttext", it => {
          show regex("A|B"): set text(fill: yellow)
          show emph: set text(fill: yellow)
          it
        }),
        force("stoi", "grayed")
      ))

      #s.push((
        once(1, it => {
          show regex("C|D"): set text(fill: eastern)
          it
        }),
        apply("prdtext", it => {
          show regex("C|D"): set text(fill: eastern)
          show emph: set text(fill: eastern)
          it
        }), 
        force("rxttext", "grayed")
      ))
    ],
    s,
  ),
)
