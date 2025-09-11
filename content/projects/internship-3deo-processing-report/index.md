+++
date = '2025-09-10T18:21:01-06:00'
draft = false
showDate = true
title = "Internship with 3DEO&mdash;Processing Performance Report"
+++

{{< katex >}}

*See [overview article](/posts/internship-3deo) and slides from my internship presentation on [GitHub](https://github.com/mward19/3deo-internship-presentation/tree/master).*

***

# Processing Performance Report
After processing a batch of data, it is not immediately obvious how well processing went. To find and diagnose problems, one might have to parse through a SQL database with thousands of Slurm jobs, download and view hundreds of large, unwieldy point clouds, parse program log files, locate and interpret plots output at various stages of processing, and more. It is also useful to know how long the various stages of processing took in order to know which need to be optimized. To more easily fetch that kind of diagnostic information, the company asked me to find a way to automatically generate human-readable processing performance reports.

***

![](main-07.png)

I chose to generate the report in a few stages. First, my program collects data from processing outputs and the SQL database of Slurm jobs. Then it compiles that information into a large JSON, which it uses to populate fields in a number of \\(\LaTeX\\) templates I wrote. Finally, it generates a PDF from the \\(\LaTeX\\).

***

![](main-08.png)

3DEO's processing pipeline is designed to handle both small and large amounts of data. As such, the report must be very flexible. Some reports are just a few pages, while others are longer than many college textbooks. 

***

![](main-10.png)

The report begins with an overview of all processing performed in the run. It contains a number of useful visualizations focused on processing time, among other things.

***

![](main-12.png)

One such visualization is the Processing Timeline. It shows how long in real time (as opposed to CPU time) each stage of processing took. 

![](main-13.png)

Each thread shows how long one Slurm job took.

![](main-14.png)

When processing many targets (tiles) at once, the vertical axis also gives an idea of which target the Slurm job corresponds to. This is primarily useful to display how _concurrent_ the processing was at a given time.

***

![](main-15.png)

The per-target (per-tile) sections of the report give lower-level information useful for evaluating how successful processing was for a given target. (3DEO's processing currently processes each target separately.) 

***

Writing the processing performance report program gave me a chance to dive into 3DEO's processing pipeline and understand the purpose of each step in it. For some of the statistics that the reports display, I had to modify the existing pipeline to report more information at the appropriate processing step (for example, report on data rejection as data is rejected throughout processing). I also learned more about the scripting and document typesetting side of \\(\LaTeX,\\) as opposed to just typesetting math.
