#import "@preview/tufted:0.1.1"

#let template = tufted.tufted-web.with(
  header-links: (
    "/": [#sym.dot *Matthew Ward* #sym.dot],
    "/about/": [About],
    "/posts/": [Posts],
    "/projects/": [Projects]
  ),
  title: "Matthew Ward",
)

#let centered(it) = html.div(it, class: "centered")

#let picture(img, caption: none) = html.div({
    img
    if caption != none {
      // html.span(caption, class: "picture")
      caption
    }
  },
  class: "picture"
)

#let small(it) = html.span(it, class: "small-text")