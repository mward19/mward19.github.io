#let site-icon = html.img(alt: "Headshot of Matthew Ward", style: "height: 2.5rem; width: 2.5rem;", src: "/_assets/headshot.jpg")

// Utility functions
#let small-figure(src, caption: none) = {
  html.div(style: "max-width: 20rem;", {
    html.img(src: src, style: "width: 100;")
    html.div(style: "width: 100%; text-align: center; color: #444;", caption)
  })
  
  
}

// Site page format
// Template applying to the body of each site page
#let template(it) = {
  it
}

#let top-nav-bar = [
  #html.nav(class: "top-nav-bar")[
    - #link(<home>)[#site-icon *Matthew Ward*]
    - #link(<about-me>)[About]
    - Posts
    - Projects
  ]
]
#let header = {
  // Import css into header so it's attached in every site page
  html.style(read(path("styles/styles.css")))
  top-nav-bar
}

#let site-page(html-path, body, tab-title: none) = document(
  html-path,
  title: tab-title,
  {
    header
    show: template
    body
  }
)



