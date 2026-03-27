#import "../config.typ": template, tufted, picture, centered, small
#import "@preview/cmarker:0.1.8"
#show: template

#centered[
  #picture(
    image("imgs/headshot.jpg", width: 40%),
    caption: [
      #link("https://github.com/mward19")[GitHub] 
      #sym.dot 
      #link("https://linkedin.com/in/matthew-m-ward")[LinkedIn] 
      #sym.dot 
      #link("me@matthewward.info")[Email] 
    ]
  )

  Applied Mathematics student at Brigham Young University \
  #small[Interested in computer vision, optimization, machine learning, etc.
  Learn more about me #link("about/")[here].]
]



