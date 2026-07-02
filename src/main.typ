// Uses https://typst.app/docs/reference/bundle/
#import "shared.typ": *

// About
#include "about/about.typ"

// Posts
#include "posts/index.typ"
#include "posts/2026/online-batch-selection/index.typ"
#include "posts/2025/internship-3deo/index.typ"
#include "posts/2025/byu-acme-thoughts/index.typ"
#include "posts/2025/teaching-pcp/index.typ"
#include "posts/2024/tablet-and-mouse/index.typ"

// Projects
#include "projects/index.typ"
#include "projects/2025/internship-3deo-processing-report/index.typ"
#include "projects/2025/internship-3deo-spot-modeling/index.typ"
#include "projects/2025/internship-3deo-pose-graph/index.typ"
#include "projects/2024/predicting-life-expectancy/index.typ"
#include "projects/2024/tomogram-datasets/index.typ"
#include "projects/2024/principal-component-pursuit/index.typ"
#include "projects/2024/visualize-voxels/index.typ"


#site-page("index.html", tab-title: "Matthew Ward")[
  #metadata(none)

  #html.div(style: "text-align: center; width: 100%;")[
    // = Matthew Ward
    #html.div(style: "padding-bottom: 2em;")
    #small-img(
      "_assets/headshot.jpg",
      caption: [
        #small-text(link("https://github.com/mward19/")[GitHub])
        #sym.dot.c
        #small-text(link("https://linkedin.com/in/matthew-m-ward")[LinkedIn])
        #sym.dot.c
        #small-text(link("mailto:me@matthewward.info")[Email])
      ]
    )

    *Matthew M. Ward* \
    Applied Mathematics student at Brigham Young University \
    #small-text[_Interested in optimization, machine learning, computer vision, typesetting, etc. Learn more about me #link(<about-me>)[here]._]
  ]

  #html.hr()

  == Featured Work
  #article-link(
    <projects-2025-internship-3deo-pose-graph>,
    "projects/2025/internship-3deo-pose-graph/imgs/thumb.png",
    [Internship with 3DEO---Pose Graph Optimization],
    [September 13, 2025]
  )

  #article-link(
    <posts-2025-byu-acme-thoughts>,
    "posts/2025/byu-acme-thoughts/imgs/thumb.jpg",
    [Thoughts on BYU's ACME math program upon finishing core classes],
    [April 28, 2025]
  )

  #article-link(
    <posts-2025-teaching-pcp>,
    "posts/2025/teaching-pcp/imgs/thumb.png",
    [Teaching Principal Component Pursuit in a computational physics class],
    [February 25, 2025]
  )

  Read on in #link(<posts>)[Posts] and #link(<projects>)[Projects].

] <home>