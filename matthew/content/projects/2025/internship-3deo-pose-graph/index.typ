#import "../../index.typ": template, tufted, picture, article-heading
#show: template.with(title: "3DEO Pose Graph Optimization")

#article-heading[Internship with 3DEO---Pose Graph Optimization][September 13, 2026]
#picture(image("imgs/cover.png", width: 75%))

#html.div(class: "introduction")[
  See #link("/content/posts/2025/internship-3deo")[3DEO internship overview], slides from my internship presentation on #link("https://github.com/mward19/3deo-internship-presentation/tree/master")[GitHub], and a relevant #link("https://robotics.caltech.edu/~jerma/research_papers/scan_matching_papers/milios_globally_consistent.pdf")[paper] by Lu and Milios.
]

#set math.equation(numbering: none)

#html.hr()
#set image(width: 100%)
= Pose Graph Optimization

All lidar sensors function by shooting light at a target and timing how long the light takes to reflect back. Geiger-mode lidar is special in that it detects _individual photons_ returning to the sensor, making it especially good at seeing through partial cover, like forest canopies. When scanning from an airplane, most of the reflected photons still come from the leaves, but by scanning from multiple angles, you can gather enough data from the ground to clearly map the understory. Thus piecing together scans taken from different angles is a key step in processing Geiger-mode lidar data.

#html.hr()

Since the lidar sensor is equipped with plenty of tools to track its position and orientation in the sky, it is possible to identify where the source of each reflected photon lies in 3D space, and thus place a point for each photon in a point cloud... but those sensor measurements can drift between scans. If you put the scans together naively, using just the noisy sensor position and orientation measurements to determine the location of the source of each reflected photon, the scans appear misaligned in a phenomenon called _ghosting_.

#picture(image("imgs/registrations.png"))

Fortunately, we have more information to place the points besides sensor position and orientation measurements. We have _the points themselves_. Ghosting is easy for us to spot because we can see duplicate structures in the misaligned scans, as in the images above. Many algorithms exist to align a pair of scans based on this principle, like #link("https://en.wikipedia.org/wiki/Iterative_closest_point")[Iterative Closest Point]. (At the moment, 3DEO primarily uses a novel algorithm better suited to the properties of its data, since other algorithms like ICP tend to be too slow and complex.) Again, these algorithms serve only to align a pair of scans. How can one extend them to align $n > 2$ scans?

#picture(image("imgs/main-19.png"))

We can set this problem up as a _pose graph_, a kind of mathematical #link("https://en.wikipedia.org/wiki/Graph_(discrete_mathematics)")[graph]. In it, each node ($X_1, ..., X_n$) represents the position of a scan relative to where it "belongs". Each edge ($macron(D)_(i j), i, j in {1, ..., n}$, transformation from scan $j$ to scan $i$) represents a pairwise alignment (also called a pairwise _registration_) derived from an algorithm like ICP. Some of the edges $macron(D)_(i j)$ are known, and each $X_i, i in {1, ..., n}$ is unknown. Now, one would hope that taking scan 3 and aligning with scan 1 would be equivalent to taking scan 3, aligning it with scan 2, and aligning that to scan 1, but in practice this is never the case since no pairwise registration algorithm is perfect. That is, $macron(D)_13 != macron(D)_12 macron(D)_23$.

#html.hr()

To determine the optimal pose of each scan (the value of each $X_i$), we can imagine that each pairwise registration is a spring in the pose graph. Since poses are multidimensional, the "elasticity" of each spring is a covariance matrix $C_(i j)$, and the energy in each spring given a set of poses $X_1, ..., X_n$ is the squared Mahalanobis distance $ (macron(D)_(i j) - (X_i - X_j))^T C_(i j)^(-1) (macron(D)_(i j) - (X_i - X_j)). $ The optimal poses minimize the sum of the energy in the springs. That is, we seek

$
  limits("argmin")_(X_1, ..., X_n) (macron(D)_(i j) - (X_i - X_j))^T C_(i j)^(-1) (macron(D)_(i j) - (X_i - X_j)).
$

#picture(image("imgs/main-21.png"))

Closely related problems arise in robotics, like #link("https://en.wikipedia.org/wiki/Simultaneous_localization_and_mapping")[Simultaneous Localization and Mapping] (SLAM).

#html.hr()
#picture(image("imgs/main-22.png"))

The trickiest part of the problem is deciding the covariance of each pairwise registration (the elasticity of each spring). One might let the covariance for each pairwise registration be the same, making each edge have the same "elasticity" in the pose graph. Alternatively, one might use features on each pairwise registration to determine the covariance. For example, if scans $i$ and $j$ don't overlap very much, we might expect the pairwise registration between them $macron(D)_(i j)$ to have more error (a higher covariance). 

#html.hr()

One advantage of this pose graph framework for registration is how easy it makes pruning bad pairwise registrations. 

#picture(image("imgs/main-23.png"))

After solving 
$
  limits("argmin")_(X_1, ..., X_n) (macron(D)_(i j) - (X_i - X_j))^T C_(i j)^(-1) (macron(D)_(i j) - (X_i - X_j))
$
we can check how "stretched out" each spring is in the solved pose graph. If a particular spring is compressed or streched more than expected, the pairwise registration it represents might be no good. (See a couple examples at the right side of the plot above.) By reweighting such outliers or removing them entirely, one can converge on an even more precise solution.

#html.hr()
I implemented a registration optimizer using the closed-form least squares pose graph solution described by Lu and Milios in #link("https://robotics.caltech.edu/~jerma/research_papers/scan_matching_papers/milios_globally_consistent.pdf")[Globally Consistent Range Scan Alignment for Environment Mapping].

#picture(image("imgs/main-26.png"))

Because it gives a closed-form solution to the minimization problem described earlier, it is very fast. It can also handle non-constant pairwise covariances, which is important if you want to weight some pairwise registrations more than others.  (In my analysis, I fixed the covariances to encode an expected translational error of a meter and an expected rotational error in each axis of 2~mrad.)

Now, our point cloud registrations were 6 dimensional, with both translation and rotation components. The space of rotations is #link("https://en.wikipedia.org/wiki/3D_rotation_group")[not really a vector space], so it is improper to perform linear least squares in it. However, our angles were very small (no more than a few milliradians), so it still worked quite well.

#html.hr()
#picture(image("imgs/main-27.png"))

On a large dataset with over 200 scans of the same target, the Lu-Milios optimizer was 58 times faster than the old one (which was an iterative method, and not a closed-form solution to the pose graph problem like Lu and Milios' is).

#html.hr()
#picture(image("imgs/main-28.png"))

The translations my new optimizer gave were about the same as those of the old optimizer, validating its correctness. (Northing, Easting, and Up correspond to translations in the north, east, and vertical directions respectively. Rotational components are not shown.)

#html.hr()
The registrations from the new optimizer also looked similar visually.

#picture(image("imgs/main-29.png"))
#picture(image("imgs/main-30.png"))


#picture(image("imgs/main-31.png"))
#picture(image("imgs/main-32.png"))

In the above plot we see some ghosting. Because both registration optimizers exhibited the same ghosting, we can conclude that the issue lies with the pairwise registrations themselves (the scans are probably a little warped and need a non-rigid transformation to come into perfect alignment).

#html.hr()
My new Lu–Milios optimizer gave more than a 50x speedup while producing registrations that looked just as good as the old method. That kind of efficiency is valuable when working with large lidar datasets. Hovever, a more intelligent choice of covariances will help make the method more robust to noise. The ghosting I observed seems to come from the limitations of the pairwise registrations themselves, not the optimizer, so future improvements will likely come from better or even non-rigid registration techniques. Still, moving to a closed-form pose graph solution was a step forward in making the process faster and more practical. 