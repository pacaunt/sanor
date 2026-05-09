#import "../src/object-case.typ": *



#let text-1 = object(
  text, 
  hidden: case(fill: gray), 
  redden: case(fill: red),
  framed: case(rect, fill: orange)
)

#text-1([A])("base") \
#text-1([A])("hidden") \
#text-1([A])("redden") \
#text-1([A])("framed") \
// unnamed modifier
#text-1([A])(case(weight: "bold", box.with(stroke: red), align.with(right))))

#let A = make-object([Hello], redden: case(text.with(fill: red)))
#A("base") \
#A("redden") 