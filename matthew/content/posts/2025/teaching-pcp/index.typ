#import "../../index.typ": template, tufted, picture, article, article-heading, numberless-figures
#show: template.with(title: "Teaching Principal Component Pursuit in a computational physics class")


#article-heading(
  [Teaching Principal Component Pursuit in a computational physics class],
  [February 25, 2025]
)

#picture(image("imgs/cover_orig.png"))

#html.hr()

#let bm(it) = $upright(bold(it))$

A few months back I dove into a book on making sense of complex data with simple models as a part of my research (#link("https://book-wright-ma.github.io/")[High-Dimensional Data Analysis with Low-Dimensional Models, by Wright and Ma]). I learned about and implemented #link("/projects/principal-component-pursuit/")[a fun demo of Principal Component Pursuit (PCP)]. My advisor loved it! We played with feeding the algorithm different kinds of simulated data, and wondered about how we might apply such an idea to better understand 3D tomograms.

Recently my advisor was out of town. He's currently introducing a new class on scientific computing (Computational Physics, PHSCS 530) here at BYU. I was surprised when he asked me to fill in for him, teaching about my Principal Component Pursuit project!

In preparation, I cleaned up #link("https://github.com/mward19/pcp")[my code] a little, made a new demonstration, and prepared my lecture. It went really well, and taught me so much.

Here I've essentially written out what I taught the class, minus a few side tangents about machine learning and dimensionality reduction from questions that students asked. 

Read on to learn about it!

#html.hr()
= A lesson on Principal Component Pursuit

#link("https://docs.google.com/presentation/d/1FSjhJYuzKLjxlEZJyOgvMNyyBlsdVEzCRpTZQ4oWrCo/edit?usp=sharing")[Presentation Slides (Google Slides)]

#picture(image("imgs/Principal Component Pursuit_page-0001.jpg", alt: "Slide 1"))

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0002.jpg", alt: "Slide 2"))

A signal $bm(Y)$ can often be broken up into two parts---a part that stays mostly the same over time ($bm(L)$), and part that is usually zero ($bm(S)$).

To formalize what this means, we say that $bm(L)$ should be *low rank*, and $bm(S)$ should be *sparse*.

The plot in the slide provides some intuition for what a sparse signal is. You can see that $bm(S)$ is usually zero (it is sparse), and the original signal $bm(Y)$ is the sum of the two components $bm(L)$ and $bm(S)$. 

The plot can't depict a low-rank signal well since this signal $bm(Y)$ is only one-dimensional, but a low-rank signal in this context may be understood as a signal that stays mostly the same, most of the time. In a moment we will look at a higher dimensional signal and talk more about this.

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0003.jpg", alt: "Slide 3"))

#picture(html.video(
  controls: true,
  style: "width: 50%",
  src: "/assets/2025/video/walking decomposed.webm",
)[
  Your browser does not support the video tag.
])

A video is a high dimensional signal! Just as the previous plot showed a signal decomposed into a low-rank and a sparse component, here is a short video of me in my lab decomposed in a similar way, to motivate what I'm about to share with you.

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0004.jpg", alt: "Slide 4"))

Here is a three-dimensional signal. Each column represents the signal at a point in time.

The *rank* of a matrix is the number of linearly independent columns (or rows) in the matrix. Here $bm(Y)$ is *full-rank*, meaning that the rank is as high as possible for a matrix of this size ($"rank"(bm(Y)) = 3$). (Given an $m times$ matrix, the highest the rank can be is the smallest dimension, either the number of rows $m$ or the number of columns $n$.)

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0005.jpg", alt: "Slide 5"))

Now we will decompose $bm(Y)$ into a low-rank and a sparse component such that $bm(Y) = bm(L) + bm(S)$. What do you think this will look like?

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0006.jpg", alt: "Slide 6"))

Here is one good decomposition. The rank of $bm(L)$ is as low as possible---just 1! Meanwhile, $bm(S)$ is somewhat sparse, with only 5 nonzero elements. And, as desired, $bm(Y) = bm(L) + bm(S)$.

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0007.jpg", alt: "Slide 7"))

How might we formalize and automate such a decomposition? We want the rank of $bm(L)$ and the number of non-zero elements of $bm(S)$ to both be low. So let's minimize that, with a parameter $lambda > 0$ to control the relative importance of each. 

And to make sure it's a true decomposition of $bm(Y)$, we add the condition that $bm(Y) = bm(L) + bm(S)$.

This problem perfectly describes our goal mathematically, but it is hard to program a routine that does this automatically. It isn't a convex problem, so we cannot expect it to have unique optimizers (in other words, we cannot expect there to be a unique $bm(L)$ and $bm(S)$ that minimize $"rank"(bm(L)) + lambda norm(bm(S))_0$. Solving this problem automatically would be very hard.

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0008.jpg", alt: "Slide 8"))

So we set up a similar problem that *is* easy to solve. We want to make the problem *convex*, a mathematical condition that implies that any local minimum of the problem is also a global minimum---generally, this means that there is a unique optimizer for the problem, which will make it easy to solve.

We replace $"rank"(bm(L))$ with the *nuclear norm* of $bm(L)$, denoted $norm(bm(L))_*$. This represents the sum of the *singular values* of $bm(L)$, which are closely tied to its eigenvalues. In particular, if $bm(L)$ has a low rank, then most of $bm(L)$'s singular values are zero. (Specifically, $"rank"(bm(L)) = norm(bold(sigma)(bm(L)))_0$ where $bold(sigma)(bm(L))$ yields the singular values of $bm(L)$). This norm is convex.

We replace $norm(bm(S))_0$ with the largest column sum (taking the absolute value of each element) of $bm(S)$, denoted $norm(bm(S))_1$. If most of the elements of $bm(S)$ are 0, then we may safely assume that the largest column sum of $bm(S)$ will be small, barring the possibility that the non-zero elements of $bm(S)$ are huge in magnitude. This norm is also convex.

The new problem we have constructed is convex, and thus, any $bm(L)$ and $bm(S)$ that minimize the problem locally also minimize it globally! This makes our search much easier. We call this new problem *Principal Component Pursuit*.

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0009.jpg", alt: "Slide 9"))

Wright and Ma provided pseudocode in their book for ADMM (Alternating Direction Method of Multipliers), an algorithm for solving convex optimization problems that happens to work well for this problem. I implemented it in Julia. 

(I could have used a standard Julia library like #link("https://jump.dev/Convex.jl/")[Convex.jl], which would probably be more robust, but decided to implement the pseudocode to practice.)

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0010.jpg", alt: "Slide 10"))

Now let's talk about how a video fits into this whole framework, like the earlier video of me walking in my lab.

A video is a signal. For simplicity's sake, I'm working with my videos in grayscale, but these methods should also apply (with some modifications) in color. Here I have an example "video" with three frames, each of which is just 4 by 6 pixels.

Each frame is a "block" of pixel intensity values. We can "flatten" each frame into a vector of values. 

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0011.jpg", alt: "Slide 11"))
Applying this "flattening" to each frame of the video, we can convert the video (which is a 4×6×3 array) into a 24×3 matrix, where each column represents the signal at a point in time (a frame).

Now we're ready to throw the video into the optimization problem previously described! I'll set $lambda = 1 \/ sqrt(max(m, n))$, where $bm(Y)$ is $m times n$, a rule-of-thumb suggestion by Wright and Ma in their book.

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0012.jpg", alt: "Slide 12"))

#picture(html.video(
  controls: true,
  style: "width: 50%",
  src: "/assets/2025/video/walking decomposed.webm",
)[
  Your browser does not support the video tag.
])

Here's the video I showed earlier again. Each frame has 111,000 pixels, and there are 195 frames in the video, so $bm(Y)$ is a 111,000×195 matrix. You can see that the rank of the original signal (the original grayscale video) is maximal, at 195.

After Principal Component Pursuit, the low-rank component has a rank of just 4. You can see that it only has a few unique frames---one where I'm standing with my hand seemingly chopped off (it was moving, so the algorithm added it to the sparse component), another where I'm not there at all, and another where I'm *just* visible by the fume hood.

The sparse component shows what was missing in the low-rank component, particularly, any part of the video that was moving. Only 2.2% of the pixels in the video are non-zero.

It looks like the new problem we constructed,

$
  "minimize" quad &norm(bm(L))_* + lambda norm(bm(S))_1 \
  "subject to" quad &bm(Y) = bm(L) + bm(S)
$

is a good replacement for the original problem

$
  "minimize" quad &"rank"(bm(L)) + lambda norm(bm(S))_0 \
  "subject to" quad &bm(Y) = bm(L) + bm(S)
$

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0013.jpg", alt: "Slide 13"))

#picture(html.video(
  controls: true,
  style: "width: 50%",
  src: "/assets/2025/video/fridge decomposed.webm",
)[
  Your browser does not support the video tag.
])

Here's another demo.

The original video had 723 frames, and as before, 111,000 pixels per frame. Thus $bm(Y)$ is a 111,000×723 matrix, with yet again full rank (723). 

The low rank component isn't as low rank as before, at 44. Perhaps a different choice of $lambda$ would help here. Notice the digits displayed on the watch. It seems like 9 is Principal Component Pursuit's favorite number!

About 12.8% of the pixels in the sparse component are non-zero. 

Maybe this video is a little harder to decompose than the other one!

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0014.jpg", alt: "Slide 14"))

// {{< youtube ax09-fxxhPM >}}
#html.iframe(
  src: "https://www.youtube.com/embed/ax09-fxxhPM",
  style: "width: 55%; height: 35em;",
  width: 560,
  height: 315,
//   title: "YouTube video",
  allow: "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
  allowfullscreen: true
)

One simple application of this technique is to detect and quantify motion in a video. In this demo, I've counted the number of non-zero elements in each frame of the sparse component of the video and plotted it over time to measure motion.

(Here's some bonus content---the same motion demo on the original video of me walking across the lab!)
// {{< youtube KY6dH0fadyA >}}
#html.iframe(
  src: "https://www.youtube.com/embed/KY6dH0fadyA",
  style: "width: 55%; height: 35em;",
  width: 560,
  height: 315,
//   title: "YouTube video",
  allow: "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture",
  allowfullscreen: true
)

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0015.jpg", alt: "Slide 15"))

There are a number of issues with this approach.

- It doesn't take advantage of spatial and temporal relationships in video.
  - We converted the video to a matrix $bm(Y)$, where each column is a frame of the video, and each row is a single pixel's intensity over time. Since all we're concerning ourselves with is the rank and sparsity of the components of $bm(Y)$, we could mix all the rows (frames) around and it wouldn't make a difference (although it certainly should, especially in the context of the motion demo I did)! Likewise mixing the columns (pixels) around. No change.

- It scales quite poorly with the length of the video.
  - The walking-across-the-lab video took about 20 seconds on my ThinkPad to process, while the fridge video took a couple of minutes, even though the fridge video is only 3 or 4 times longer.

- Setting $lambda$ is difficult. A better choice of $lambda$ might've helped in the fridge video demo.

#html.hr()
#picture(image("imgs/Principal Component Pursuit_page-0016.jpg", alt: "Slide 16"))
*References*
- #link("http://book-wright-ma.github.io")[Wright and Ma's book]
- #link("https://matthewward.info/projects/principal-component-pursuit")[The original demo and description I made]
- #link("https://github.com/mward19/pcp")[The project's GitHub]