#let site-icon = html.img(alt: "Headshot of Matthew Ward", style: "height: 2.5rem; width: 2.5rem;", src: "/_assets/headshot.jpg")

// Utility functions
#let small-img(src, caption: none, alt: "", width: 100%) = {
  html.div(style: "max-width: 20rem; margin: 0 auto; text-align: center;", {
    html.img(src: src, alt: alt, style: "width: " + str(width / 1%) + "%;")
    html.div(style: "width: 100%; text-align: center; color: #444;", caption)
  })
}

#let large-img(src, caption: none, alt: "", width: 100%) = {
  html.div(style: "max-width: 50rem; width: 100%; margin: 0 auto; text-align: center;", {
    html.img(src: src, alt: alt, style: "width: " + str(width / 1%) + "%;")
    html.div(style: "width: 100%; text-align: center; color: #444;", caption)
  })
}

#let cover(src, caption: none, alt: "", width: 100%) = {
  html.div(style: "max-width: 50rem; width: 80%; margin: 0 auto; text-align: center;", {
    html.img(src: src, alt: alt, style: "width: " + str(width / 1%) + "%;")
    html.div(style: "width: 100%; text-align: center; color: #444;", caption)
  })
}

// Especially for complex formulas that MathML doesn't format well
#let centered-frame(it) = html.div(class: "centered-frame", style: "display: flex; justify-content: center;", html.frame(it))
#let inline-frame(it) = box(html.frame(it))

#let article-link(path, thumbnail-path, title, date, subtitle: none) = html.div(class: "article-link",
  link(path, html.div(style: "display: flex; gap: 1rem; align-items: center; margin-bottom: 1rem;", {
    html.img(src: thumbnail-path, style: "width: 8rem; height: 6rem; object-fit: cover; flex-shrink: 0;")
    html.div({
      html.div(style: "font-weight: bold;", title)
      if subtitle != none {
        html.div(style: "color: #666;", subtitle)
      }
      html.div(style: "color: #999; font-size: 0.85em;", date)
    })
  }))
)


// Site page format
// Template applying to the body of each site page
#let template(body) = {
  show figure: it => html.div(
    style: "width: 100%; text-align: center;",
    it
  )
  body
}

#let top-nav-bar = [
  #html.nav(class: "top-nav-bar")[
    - #link(<home>)[#site-icon *Matthew Ward*]
    - #link(<about-me>)[About]
    - #link("/posts/")[Posts]
    - #link("/projects/")[Projects]
  ]
]
#let header = {
  // Import css into header so it's attached in every site page
  html.style(read(path("styles/styles.css")))
  html.link(rel: "icon", type: "image/x-icon", href: "/_assets/favicon/favicon.ico")
  html.link(rel: "icon", type: "image/png", sizes: ((16, 16),), href: "/_assets/favicon/favicon-16x16.png")
  html.link(rel: "icon", type: "image/png", sizes: ((32, 32),), href: "/_assets/favicon/favicon-32x32.png")
  html.link(rel: "icon", type: "image/png", sizes: ((48, 48),), href: "/_assets/favicon/favicon-48x48.png")
  html.link(rel: "icon", type: "image/png", sizes: ((192, 192),), href: "/_assets/favicon/android-chrome-192x192.png")
  html.link(rel: "icon", type: "image/png", sizes: ((512, 512),), href: "/_assets/favicon/android-chrome-512x512.png")
  html.elem("link", attrs: (rel: "apple-touch-icon", href: "/_assets/favicon/apple-touch-icon.png"))
  top-nav-bar
}

#let footer = {
  html.footer[
    © 2026 Matthew Ward — #link("https://typst.app/home/")[Typst 0.15]
  ]
}

#let site-page(html-path, body, tab-title: none) = document(
  html-path,
  title: tab-title,
  {
    header
    html.main(template(body))
    footer
  }
)



