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
