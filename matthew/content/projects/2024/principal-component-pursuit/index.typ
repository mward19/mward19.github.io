#import "../../index.typ": template, tufted, picture, article-heading
#show: template.with(title: "3DEO Pose Graph Optimization")

#article-heading[Internship with 3DEO---Pose Graph Optimization][September 13, 2026]
// #picture(image("imgs/thumb.png", width: 75%))

#html.div(class: "introduction")[
  This project is hosted on #link("https://www.github.com/mward19/pcp")[GitHub]).
]

#set math.equation(numbering: none)

#html.hr()

== Brief summary

While looking for ways to work with and extract information from cryo-ET tomograms (noisy 3D images) in the summer of 2024, I read a #link("https://book-wright-ma.github.io/")[book] about ways of making the most of messy data using linear algebra and optimization. In the process, I learned about Robust Principal Component Analysis (RPCA), which can be performed with Principal Component Pursuit (PCP). 

Here I apply Principal Component Pursuit to a video I shot in my lab. Using this method, I am able to extract the background and foreground of a video, using nothing more than linear algebra and a simple convex optimization problem.

#picture(html.video(
  controls: true,
  style: "width: 50%",
  src: "/assets/2024/video/pcp_demo.mp4",
)[
  Your browser does not support the video tag.
])

 - The top video is the original, which I shot of myself in my lab.
 - The middle video is the "background" (not moving) component of the video.
 - The bottom video is the "foreground" (moving) component of the video.

This project is inspired by a common application of PCP: #link("https://www.sciencedirect.com/science/article/pii/S1077314213002294?via%3Dihub")[identifying video segments in surveillance camera feeds] where something of interest is happening. The video above simulates this in just a few seconds.

I have yet to successfully apply this method to tomograms, but my advisor and I thought it was fascinating, so we feel like we succeeded anyway! I implemented the method in Julia, a language I am coming to love. See my implementation code on #link("https://www.github.com/mward19/pcp")[GitHub].

If you would like to learn more details, read the longer summary below. 

== Longer summary
=== What is this?
This is an implementation and demonstration of Principal Component Pursuit, a way to solve the #link("https://en.wikipedia.org/wiki/Robust_principal_component_analysis")[Robust Principal Component Analysis] problem, which is here applied to a short video I shot.

=== What am I seeing?
I recorded the top video in my lab. I wanted a video with a mostly static background and something moving in the foreground.

Using the method, which I will describe next, I separate the video into a static component and a moving component. The static component is the middle video. The moving component is the bottom video. In other words, the bottom video added to the middle video yields the top video.

=== How does it work?
Each frame of a grayscale video can be thought of as a matrix of grayscale values. For each frame, I take that matrix and flatten it into a vector. Thus, each frame of the video can be represented as a long vector with as many elements as there are pixels in a frame. I will call this vector a "frame vector".

By representing the frames as vectors, the entire video can itself be represented as a matrix. This is done by stacking all of the frame vectors side by side into a huge matrix, with as many columns as there are frames in the video. I will call this matrix a "video matrix".

In a video with a mostly static background and something moving in the foreground, the video matrix is *almost* low rank, since the frame vectors are mostly the same (since most of the pixels don't change). But it isn't, because of the movement in the foreground. Nevertheless, we can find a video matrix that is nearly equal to the original video matrix but is in fact low rank. In simpler terms, we can extract the background of the video.

#let bm(it) = $upright(bold(it))$
Let $bm(Y)$ be the original video matrix. We want a video matrix $bm(L)$ that is nearly equal to $bm(Y)$, differing only by a sparse (meaning most of the elements are 0) matrix $bm(L)$. In other words, we want to find $bm(L)$ and $bm(S)$ such that $bm(Y) = bm(L) + bm(S)$, while minimizing $"rank"(bm(L))$ and $norm(bm(S))_0$ (where $norm(dot)_0$ gives the number of non-zero elements of its input, which technically is not a proper mathematical norm). 

One could set this up as an optimization problem

$
  "minimize" quad &"rank"(bm(L)) + lambda norm(bm(S))_0 \
  "subject to" quad &bm(Y) = bm(L) + bm(S)
$

for some tuning parameter $lambda in RR_(>0)$, but the objective is not convex, making this very difficult to solve.

Rather, we set up the problem using convex surrogate norms:

// $$
// \begin{aligned}
//     \text{minimize}\quad&\Vert\bf{L}\Vert_* + \lambda \Vert\bf{S}\Vert_1 \\\
//     \text{subject to}\quad&\bf{Y} = \bf{L} + \bf{S},
// \end{aligned}
// $$
$
  "minimize" quad &norm(bm(L))_* + lambda norm(bm(S))_1 \
  "subject to" quad &bm(Y) = bm(L) + bm(S)
$

where $norm(dot)_*$ is the _nuclear norm_, meaning, the sum of the singular values of the input matrix, and $norm(dot)_1$ is the standard matrix 1-norm (the maximum column sum). (See "Note: Why these norms?" below.)

This new problem is convex! It is easy to solve with off-the-shelf convex optimizers. I have opted to implement the optimizer myself, but other libraries like CVXPY (in Python) or Convex.jl (for Julia) should work fine.

By solving

// $$
// \begin{aligned}
//     \text{minimize}\quad&\Vert\bf{L}\Vert_* + \lambda \Vert\bf{S}\Vert_1 \\\
//     \text{subject to}\quad&\bf{Y} = \bf{L} + \bf{S},
// \end{aligned}
// $$
$
  "minimize" quad &norm(bm(L))_* + lambda norm(bm(S))_1 \
  "subject to" quad &bm(Y) = bm(L) + bm(S),
$
we find video matrices $bm(L)$ and $bm(S)$ that, for all intents and purposes, separate the original video matrix $bm(Y)$ into "background" and "foreground" components respectively. Problem solved!

==== Note: Why these norms?
First, we want to minimize the rank of $bm(L)$. When the rank of $bm(L)$ is minimized, we hope that most of its singular values are zero. Perhaps this will shed some intuition on why the nuclear norm makes sense here.

Second, we want to minimize the number of nonzero elements of $bm(S)$ (what I called $norm(dot)_0$ above). When the number of nonzero elements of $bm(S)$ is minimized, we would hope that the maximum column sum of $bm(S)$ is quite small. Hopefully this clarifies why the 1-norm is a reasonable choice.

For more formal justification for these choices of norm, consult Wright and Ma's textbook
#link("https://book-wright-ma.github.io/")[High-Dimensional Data Analysis with Low-Dimensional Models: Principles, Computation, and Applications].
