// Uses https://typst.app/docs/reference/bundle/
#import "shared.typ": *

// About
#include "about/about.typ"

// Posts
#include "posts/index.typ"
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
  #metadata(none) <home>
  Welcome to my site. Read about me #link(<about-me>)[here].
]