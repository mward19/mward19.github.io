+++
date = '2024-11-13T13:06:41-07:00'
draft = false
title = 'tomogram-datasets'
+++

In the BYU Biophysics research group, we spend much of our time working with 3-dimensional images of bacteria called tomograms. Researchers have spent a lot of time looking for structures in these tomograms, and save their findings in annotation files. This repository contains code that makes it easier to navigate the web of tomograms and annotations we have, simplifying analysis and dataset creation. While it's something I'm still working on, I use it every day in my research.

The code is hosted on [GitHub](https://github.com/byu-biophysics/tomogram-datasets/tree/master).

I learned a lot about Python libraries making this, like how to define the dependencies of my project so users could install it without having to think about that. I think my favorite part was learning to generate a [documentation site](https://byu-biophysics.github.io/tomogram-datasets/) automatically from the code's docstrings using [MkDocs](https://www.mkdocs.org/). Seeing it update itself as I added features was fascinating. 