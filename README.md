## Introduction 
This application builds off the automated visual inspection application to investigate the effects of noise on an image processing application, as well as the performance of an image processing application after applying different noise removal filter techniques.

Part one deals with the evaluation of a visual inspection system with with Gaussian noise. Part two investigates the removal of this noise using different types of spacial domain filtering and frequency domain filtering.

---

### 1. Evaluation of Visual Inspection System with Noisy Images 

Part one chooses three fault categories from the previous application. The "imnoise" function is used to add Gaussian noise for each fault of increasing levels of noise variance. Each fault is then checked using the same methods as previous and the results are graphed. The overall performance can be seen below.

![alt text](https://github.com/JordanCahill/ProductionLineNoiseAnalysis/blob/master/Results/PartOne/OverallResults.png =250x250)

---

### 2. Investigation of Noise Removal using Filtering 

Part two adds applies filtering to the noisy images and investigates the performance of the program. The "Cap missing" fault was chosen as it performed in between the other two faults chosen for part one. This gave a better picture of performance post-filtering. 

Initially, a single noise level was chosen as a test operating point. A sigma value of 0.12 was chosen as this resulted in a 10% detection rate when no filtering was applied. Each image was separately subjected to four different types of filters:

* Average Filtering (Spatial Domain)
* Median Filtering (Spatial Domain)
* Gaussian Filtering (Spatial Domain)
* Low-Pass Filtering (Frequency Domain)

The application was then extended to the full range of noise variance from part one to obtain a plot of system performance vs noise variance.

![alt text](https://github.com/JordanCahill/ProductionLineNoiseAnalysis/blob/master/Results/PartTwo/OverallPerformance.png =250x250)

