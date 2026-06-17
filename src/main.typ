// Uses https://typst.app/docs/reference/bundle/
#set figure(numbering: none)

#import "shared.typ": *
#include "about/about.typ"

#site-page("index.html", tab-title: "Matthew Ward")[
  #metadata(none) <home>
  Welcome to my site. Read about me #link(<about-me>)[here].
]