+++
date = '2025-08-26T12:21:00-06:00'
draft = false
showDate = true
title = "Data Engineering for Geiger-mode Lidar with 3DEO"
+++

This summer I had the opportunity to intern with [3DEO](https://3deolidar.com/), a spin-out from MIT Lincoln Laboratory specializing in Geiger-mode lidar. Read more about 3DEO's systems in [this LIDAR Magazine article](https://lidarmag.com/2024/12/30/next-generation-geiger-mode-lidar-systems/). Here I will focus primarily on my contributions.

***

The data collection rate of Geiger-mode lidar sensors is incomprehensibly fast. [compare to linear mode]. The size of the data 3DEO works with astounded me. When I worked with a 60 or 70 gigabyte dataset I helped create for [BYU's "Locating Bacterial Flagellar Motors 2025" Kaggle competition](https://www.kaggle.com/c/byu-locating-bacterial-flagellar-motors-2025), I struggled to perform any kind of processing because of the I/O bottlenecks resulting from the size of the data, but at 3DEO I worked with _terabytes_ of point cloud data. It is not unusual for a single data processing run to go through tens (if not hundreds) of billions of photon detections and pull them together into a single data product, plowing through days of CPU time to do so.