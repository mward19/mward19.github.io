#import "@preview/tufted:0.1.1"

#let template = tufted.tufted-web.with(
  header-links: (
    "/": [#box(image("content/imgs/headshot.jpg"))~~~*Matthew Ward*],
    "/about/": [About],
    "/posts/": [Posts],
    "/projects/": [Projects]
  ),
  title: "Matthew Ward"
)
// ------------------------------------------
// Custom functions


#let template-figures(content, supplement: true) = {
  // Redefine figure caption to use marginnote
  show figure.caption: it => html.span(
    class: "marginnote",
    if supplement {it.supplement + sym.space.nobreak + it.counter.display() + it.separator} else {} + it.body,
  )

  // Redefine figure itself
  show figure: it => if target() == "html" {
    html.figure({
      it.caption
      it.body
    })
  }

  content
}
#let numberless-figures = template-figures.with(supplement: false)


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

#let article(path, thumb, title, date, subtitle: none) = {
  html.div(class: "thumbnail", link(path, table(
    columns: 2, // Widths set in custom.css
    thumb, 
    [
      #html.span(class: "thumbnail-title", title) \
      #if subtitle != none [
        #html.span(class: "thumbnail-subtitle", subtitle) \
      ]
      #html.span(class: "thumbnail-date", date)
    ]
  )))
}

#let article-heading(title, date, subtitle: none) = {
  html.div(class: "article-heading")[
    #html.span(class: "article-title", title) \
    #if subtitle != none [
      #html.span(class: "article-subtitle", subtitle) \
    ]
    #html.span(class: "article-date", date)
  ]
}