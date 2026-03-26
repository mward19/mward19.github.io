#import "@preview/tufted:0.1.1"

#let template = tufted.tufted-web.with(
  header-links: (
    "/": "Home",
    "/about/": "About",
    "/posts/": "Posts",
    "/projects/": "Projects"
  ),
  title: "Matthew Ward",
)
