#import "../config.typ": template, tufted, picture, centered, small, article, article-heading, numberless-figures
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
      #link("mailto:me@matthewward.info")[Email] 
    ]
  )

  Applied Mathematics student at Brigham Young University \
  #small[Interested in computer vision, optimization, machine learning, etc.
  Learn more about me #link("about/")[here].]
]

#html.hr()

#article(
  "posts/2025/internship-3deo", 
  image("posts/2025/internship-3deo/imgs/thumb.png"), 
  [Internship with 3DEO—Data Engineering for Geiger-mode Lidar], 
  [September 13, 2025]
)

#article(
  "projects/2025/internship-3deo-processing-report",
  image("projects/2025/internship-3deo-processing-report/imgs/thumb.png"),
  [Internship with 3DEO---Processing Performance Report],
  [September 13, 2025]
)

#article(
  "projects/2025/internship-3deo-spot-modeling",
  image("projects/2025/internship-3deo-spot-modeling/imgs/thumb.png"),
  [Internship with 3DEO---Illumination Spot Modeling],
  [September 13, 2025]
)

#article(
  "projects/2025/internship-3deo-pose-graph",
  image("projects/2025/internship-3deo-pose-graph/imgs/thumb.png"),
  [Internship with 3DEO---Pose Graph Optimization],
  [September 13, 2025]
)

#article(
  "posts/2025/byu-acme-thoughts", 
  image("posts/2025/byu-acme-thoughts/imgs/thumb.jpg"), 
  [Thoughts on BYU's ACME math program upon finishing core classes], 
  [April 28, 2025]
)

#article(
  "posts/2025/teaching-pcp", 
  image("posts/2025/teaching-pcp/imgs/thumb.png"), 
  [Teaching Principal Component Pursuit in a computational physics class], 
  [February 25, 2025]
)

#article(
  "projects/2024/predicting-life-expectancy",
  image("projects/2024/predicting-life-expectancy/imgs/thumb.png"),
  [Predicting future life expectancy in countries using present data],
  [December 17, 2024]
)

#article(
  "posts/2024/tablet-and-mouse", 
  image("posts/2024/tablet-and-mouse/imgs/thumb.jpg"), 
  [A cheaper alternative to tablets, and the mouse to rule them all], 
  [November 25, 2024]
)

#article(
  "projects/2024/tomogram-datasets",
  image("projects/2024/tomogram-datasets/imgs/thumb.png"),
  [tomogram-datasets],
  [November 13, 2024]
)

#article(
  "projects/2024/principal-component-pursuit",
  image("projects/2024/principal-component-pursuit/imgs/thumb.png"),
  [Principal Component Pursuit],
  [November 13, 2024]
)

#article(
  "projects/2024/visualize-voxels",
  image("projects/2024/visualize-voxels/imgs/thumb.png"),
  [visualize-voxels],
  [November 13, 2024]
)