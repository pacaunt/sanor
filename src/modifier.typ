#import "utils.typ"
#import "store.typ"
#import "indices.typ"

#let resolve-hider(info, hider, exargs) = {
  if hider == auto {
    if exargs in ((), (:), arguments()) {
      info.hider
    } else {
      it => it
    }
  } else {
    hider
  }
}
// -> modifier
#let pause(s, hider: auto, exargs: (:)) = {
  let info = store.get(s)
  let modified = not info.pauses <= info.subslide
  hider = resolve-hider(info, hider, exargs)

  return (
    modified: modified,
    applier: hider,
    exargs: exargs,
  )
}

#let uncover(
  s,
  index,
  hider: auto,
  exargs: (:),
) = {
  let (from, to, between) = indices.resolve(s, index)
  let info = store.get(s)
  let modified = (
    (
      info.subslide >= from and info.subslide <= to
    )
      or (
        info.subslide <= to
      )
      or (
        info.subslide >= from
      )
      or (
        info.subslide in between
      )
  )

  hider = resolve-hider(info, hider, exargs)

  return (
    modified: modified,
    exargs: exargs,
    applier: hider,
  )
}

#let only(
  s,
  index,
  hider: it => none,
  exargs: (:),
) = uncover(s, index, hider: hider, exargs: exargs)
