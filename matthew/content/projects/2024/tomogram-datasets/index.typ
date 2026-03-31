#import "../../index.typ": template, tufted, picture, article-heading
#show: template.with(title: "tomogram-datasets")

#article-heading[tomogram-datasets][September 13, 2026]
#picture(image("imgs/cover.png", width: 75%))

#html.div(class: "introduction")[
  This project is hosted on #link("https://www.github.com/byu-biophysics/tomogram-datasets")[GitHub].
]

#set math.equation(numbering: none)



#html.hr()

In the BYU Biophysics research group, we spend much of our time working with 3-dimensional images of bacteria called tomograms. Researchers have spent a lot of time looking for structures in these tomograms, and save their findings in annotation files. `tomogram_datasets` makes it easier to navigate the web of tomograms and annotations we have, simplifying analysis and dataset creation. While it's something I'm still working on, I use it every day in my research.

The code is hosted on #link("https://github.com/byu-biophysics/tomogram-datasets/tree/master")[GitHub].

It puts tomograms and their respective annotations into an object-oriented framework, so that accessing attributes of a particular tomogram, like annotations, supercomputer filepath, or header data, is quick and easy. This is primarily to facilitate the creation and analysis of competition datasets. Our group has already done a couple #link("https://www.kaggle.com/competitions/byu-locating-bacterial-flagellar-motors-v2")[Kaggle competitions] internally at BYU, and as we prepare to launch our first worldwide competition, I found myself in need of an easier way to work with our tomograms.

The project was also an opportunity to practice robust coding practices (#link("https://github.com/byu-biophysics/tomogram-datasets/blob/3823769f406fc5e84e14e635c78e38e924f626f7/test/test_tomogram.py")[implementing unit tests], #link("https://byu-biophysics.github.io/tomogram-datasets/")[thorough documentation]), scripting (#link("https://github.com/byu-biophysics/tomogram-datasets/blob/3823769f406fc5e84e14e635c78e38e924f626f7/tomogram_datasets/supercomputer_utils.py")[file management on a supercomputer], #link("https://github.com/byu-biophysics/tomogram-datasets/blob/3823769f406fc5e84e14e635c78e38e924f626f7/tomogram_datasets/tomogram.py")[file loading]), as well as #link("https://github.com/byu-biophysics/tomogram-datasets/blob/3823769f406fc5e84e14e635c78e38e924f626f7/tomogram_datasets/subtomogram.py")[data processing].

In addition, I learned a lot about Python libraries making this, like how to define the dependencies of my project so users could install it without having to think about that. I think my favorite part was learning to generate a #link("https://byu-biophysics.github.io/tomogram-datasets/")[documentation site] automatically from the code's docstrings using #link("https://www.mkdocs.org/")[MkDocs]. Seeing it update itself as I added features was fascinating. 