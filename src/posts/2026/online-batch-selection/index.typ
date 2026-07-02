#import "../../../shared.typ": *
#site-page("posts/2026/online-batch-selection/index.html", tab-title: "Online Batch Selection")[
  #article-title([Online Batch Selection (and Deep Learning) for the Uninitiated], [July 1, 2026])

  #let bm(it) = $bold(upright(it))$
  #set heading(numbering: "1.1.1.")

  I am about to start a two-year thesis-based Master's of Mathematics program with #link("https://sites.google.com/view/kevin-miller/home")[Dr. Kevin Miller], a professor of mathematics at Brigham Young University. I started researching with him this summer, focusing primarily on methods of online batch selection for deep learning. Without a doubt, my friends and family will be curious what I'm spending my time doing. What follows is a high-school level treatment of online batch selection in the context of deep learning, and why it's worth spending two years studying.
  // #cover("imgs/cover.jpg")
  // For a Harrison-type person. Intelligent, informed about programming, but not familiar with deep learning
  
  = An introduction to deep learning
  Neural networks were inspired by the brain, but in reality they have little to do with it. Rather, a neural network is a kind of mathematical function---one with many parameters (numbers that determine the function's behavior). 

  In mathematics, a function simply takes _stuff_ in, and, based on the input, deterministically outputs other _stuff_. Neural networks take in some numbers and output other numbers, usually to model something useful. For example, an image is really just some numbers arranged in a special way.

  #figure(
    large-img("notebooks/example-data.svg", width: 60%),
    caption: [
      One sample from FashionMNIST, a dataset of 28#sym.times;28 grayscale images of clothing. Each image falls into one of ten classes: _T-shirt/top_, _Trouser_, _Pullover_, _Dress_, _Coat_, _Sandal_, _Shirt_, _Sneaker_, _Bag_, or _Ankle boot_.
    ]
  ) <example-data>
  
  #figure(
    large-img("notebooks/example-data-df.png", width: 70%),
    caption: [The image in @example-data is really just a long list of numbers arranged in a grid (28#sym.times;28 = 784 numbers, to be exact).]
  ) <example-data-df>

  
  You can probably tell that the image in @example-data and @example-data-df isn't a _Sandal_ or a _Trouser_, but you might not be certain if it's a _T-shirt/top_, a _Shirt_, or a _Bag_. I might reasonably claim there's a 60% chance it's a _T-shirt/top_, a 30% chance it's a _Shirt_, a 10% chance it's a _Bag_, and a 0% chance it's anything else. I could represent these confidence values as a list of numbers (a *vector*) adding to 1:
  #let probabilityvec = $vec(0.6, 0, 0, 0, 0, 0, 0.3, 0, 0.1, 0)$
  $
    probabilityvec
  $
  I would then be acting like a function on the dataset: one that takes in FashionMNIST images and outputs how confident I am that it belongs to each class.
  
  #let image = emoji.painting
  #let brain = emoji.brain
  The output of this "me looking at an image" function depends on two things: the image, and the configuration of my brain. Let's call the function "$"matt"$", the image "#image", and my brain "#brain". Then we could write that

  #centered[$"matt"(image\; brain) = probabilityvec.$]
  
  Neural network classifiers do the same thing: they take in an image and output a vector representing how "confident" it is that the image belongs to each class. They only differ in that their "brain" isn't made of cells and tissue---it's just a pile of numbers called "parameters". One common convention in machine learning is to call the neural network "$f$", the input image "$bm(x)$", and the network's parameters "$bold(Theta)$" (the Greek letter _theta_):

  #centered[$f(bm(x)\; bold(Theta)) = probabilityvec$]

  Thus, neural networks are a kind of *model*---they are used to approximate (possibly very complex) mathematical functions like $"matt"(image, brain)$. Neural networks work by taking the numbers in $bm(x)$ and methodically mixing them around with the numbers in $bold(Theta)$ through multiplication and addition. A _deep_ neural network mixes over and over again, with tons of numbers within $bold(Theta)$ to enable extra mixing. Large language models (LLMs) like ChatGPT and Claude are deep neural networks. Instead of classifying images, they "classify" sequences of words, outputting a vector that represents which words are most likely to come next in the sequence. The latest LLMs have over a trillion numbers in their $bold(Theta)$!

  Of course, the brain (#brain) in my brain-classifier ($"matt"$) was "trained" through my own life experiences. Since nobody really knows how to directly translate "life experience" into math, we tune the parameters $bold(Theta)$ of a neural network model differently: with calculus!

  == Training a neural network model
  To get $f(bm(x)\; bold(Theta))$ to output good confidence values, we first need a way to measure how "wrong" $f(bm(x)\; bold(Theta))$ currently is. There are lots of ways to do this, but they follow the same general principles. 

  Let's call this "wrongness" measure $ell(bm(x)\; bold(Theta))$ ($ell$ is a cursive "l", which stands for "loss"), and let's call the image in @example-data "$bm(x)^((101))$" (I added $(101)$ because it's the 101#super[st] image in the dataset). If $f(bm(x)^((101))\; bold(Theta))$ is ridiculous (for example, a vector saying there's a 50% chance that @example-data is a _Sneaker_, a 50% chance it's a _Sandal_, and 0% for everything else), then $ell(bm(x)^((101))\; bold(Theta))$ should be a high number (high wrongness). If $f(bm(x)^((101))\; bold(Theta))$ is close to the truth (near 100% chance $bm(x)^((101))$ is what it actually is known to be, near 0% anything else), then $ell(bm(x)^((101))\; bold(Theta))$ should be a low number (low wrongness).

  We want to figure out what the parameters $bold(Theta)$ should be so that $ell(bm(x)\; bold(Theta))$ is low for most images $bm(x)$. Neural networks are designed such that if I single out just one image---let's say it's the $i$#super[th] one, $bm(x)^((i))$---it's pretty easy to figure out in which direction to shift each parameter (each number in $bold(Theta)$) to decrease $ell(bm(x)^((i))\; bold(Theta))$ (entirely thanks to #link("https://en.wikipedia.org/wiki/Backpropagation")[_backpropagation_]). In math-speak, this is done by calculating 
  $
    -(partial ell(bm(x)^((i))\; bold(Theta)))/(partial bold(Theta)),
  $ 
  the derivative of the loss function $ell$ with respect to the model parameters. To "train" the model is to randomly pick lots of different images, shifting $bold(Theta)$ a little in the calculated direction ($-(partial ell(bm(x)\; bold(Theta)))/(partial bold(Theta))$) for each one. This process is called _stochastic gradient descent_ (SGD).
  
  Figuring out how far to shift $bold(Theta)$ is a hard problem. If you don't shift enough, you might not make $ell$ that much lower. If you shift too much, you might overshoot and ruin $bold(Theta)$, making $ell$ increase. The number that determines how far you choose to shift $bold(Theta)$ by is called the _learning rate_, and is often represented by $eta$ (the Greek letter _eta_).

  After performing stochastic gradient descent for a while, you hope that $ell$ is small for most images. In practice, it tends to work pretty well, and on a good day, $f(bm(x)\; bold(Theta))$ ends up _better_ than $"matt"(image\; brain)$! 
  
  The study of the training and application of deep neural networks is called _deep learning_.

  = Online Batch Selection
  To review, training a neural network involves repeatedly selecting a data point $bm(x)^((i))$ from a training dataset (the data points in FashionMNIST are images), calculating $-(partial ell(bm(x)^((i))\; bold(Theta)))/(partial bold(Theta))$, and shifting $bold(Theta)$ accordingly.
  
  In fact, for efficiency, we usually pick a few data points at once and calculate $-(partial ell(bm(x)\; bold(Theta)))/(partial bold(Theta))$ for them at the same time (GPUs make this quite easy). The set of data points we train on at each training step is called a *batch*---the batch size can vary from just a couple data points to hundreds at once. Each time we select a batch of data and shift $bold(Theta)$ based on the batch is called a *training step*.
  
  How should we pick which data points go into each batch? Most people treat all the data points equally and pick which ones to add to the batch completely at random, like drawing names from a hat. This approach is called *uniform sampling*.

  == Calling uniform sampling into question
  But why should we treat all the data the same? With curated toy datasets like FashionMNIST, uniform sampling works fine, but real data is never that clean. Usually, some of the data points' labels are wrong, and the dataset you're training on isn't quite representative of the task you really want your model to perform. 
  
  For example, I used to work on training neural network models to process 3-dimensional images (cryo-ET tomograms) of bacteria and output the location of certain structures in them (if present at all). I put together #link("https://www.biorxiv.org/content/10.1101/2025.04.23.650258v1.full.pdf")[a dataset of these bacteria] for a large, well-funded #link("https://www.kaggle.com/competitions/byu-locating-bacterial-flagellar-motors-2025")[data science competition]. Among other things, I learned that creating a good dataset is hard! Incorrect labels and unintended artifacts creep in, and that can lead to unintended bias in neural networks trained on that data. Aside from errors, real datasets are unbalanced. I could not possibly make my bacteria dataset contain examples of every kind of bacteria and every possible kind of tomogram, and some kinds were better represented than others. 
  
  If we train a neural network model using uniform sampling on a 1000-point dataset that contains 975 data points of type A, but only 25 of an unusual type B, bad things can happen. For instance, the model might learn a lot about type A data points and just ignore type B. Or it might learn a little about type B, but perform worse on type A than it would have if it were trained on those points alone. How can we ensure that the model learns as much as possible about _both_ types of data?

  Another problem is redundant training. Let's pretend that not only are 975 points in the 1000-point dataset of type A, but they are also nearly identical, while the 25 type B points are more varied and interesting. With uniform sampling, we'll spend 975/1000 = 97.5% of the time training on nearly-identical type A points. Not only is that slow, unnecessary, and wasteful, but it also exacerbates the risk that the model just ignores type B points. 
  
  Consider that the Internet---the primary source of training data for many large neural networks like LLMs---is full of duplicate or uninteresting data (type A), yet it has rare nuggets of wisdom scattered throughout if you look hard enough (type B). If we could somehow tell our model's training algorithm to add extra type B data to the batches it uses at each training step, that might help. Or we could instruct it to only add data points that appear "difficult" or "interesting" to the batches. 
  
  == Online batch selection methods
  Methods of choosing what points go into each batch during training are called *online batch selection methods*. The ideas behind it had been developing for a while, but the term was coined by Loshchilov and Hutter in their 2016 paper #link("https://arxiv.org/abs/1511.06343")[Online Batch Selection for Faster Training of Neural Networks]. Since then, many papers on intelligent online batch selection methods have been published. Some important methods include:
  - #link("https://arxiv.org/abs/1803.00942")[Gradient Norm Independence Sampling (2018)], which increases a point's probability of being selected into a batch when it is predicted to induce the most change in $bold(Theta)$. Actually figuring out how much a point will change $bold(Theta)$ by would be too expensive to be worth doing, so it uses a clever approximation instead. Messy data can really mess this algorithm up, but on clean datasets, it is faster at training than uniform sampling.
  - #link("https://arxiv.org/abs/2206.07137")[RHO-LOSS (Reducible Holdout Loss Selection) (2022)], which, to quote the paper, chooses for each batch "low-noise, task-relevant, non-redundant points---points that are learnable, worth learning, and not yet learnt." It relies on a pre-trained "teacher" model to help the neural network model-in-training (the "student" model) understand which points are learnable and worth learning. In my experience, when there are mistakes in the dataset's labels, this method excels. #to-do[Discuss DPD?]
  - #link("https://arxiv.org/abs/2406.04872")[DivBS (Diversified Batch Selection) (2024)], which ensures that in every batch, each data point is unlike the rest in the batch (the batch is "diversified"). It works much better than uniform sampling if the dataset is clean, but if some samples are unusual and labeled incorrectly, it can completely derail training. However, DivBS doesn't need a pre-trained teacher model, and in my experience not only trains faster than uniform sampling, but it also leads to a higher-quality model (speaking technically, the model _generalizes_ better to unseen data).

  Admittedly, no online batch selection method has proven objectively better than uniform sampling across all contexts, otherwise we'd all be using it. #to-do[Give strong justification for why it still matters]
  
  = Open questions I'm currently investigating
  #to-do[Will Luke's thesis be published, or is it a _secret?_]
  
] <posts-2026-online-batch-selection>