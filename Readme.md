Guillaume NOYEL

# Logarithmic Mathematical Morphology: theory and applications

This is the papers's code.

Please cite it as follows:
```bibtex
@article{Noyel2026,
   abstract = {In mathematical morphology for grey-level functions, an image is analysed by another image named the structuring function. This structuring function is translated over the image domain and summed to the image. However, in an image presenting lighting variations, when the structuring function is added to this image, the amplitude of this translated structuring function should vary according to the image intensity. Such a property is not verified in mathematical morphology for grey-level functions, when the structuring function is summed to the image with the usual additive law. This issue has been addressed by defining a framework that uses an additive law, for which the amplitude of the structuring function added to the image varies according to the amplitude of the image itself. This additive law is chosen within the logarithmic image processing framework and models the lighting variations with a physical cause such as a change of light intensity. The framework is named logarithmic mathematical morphology (LMM) and allows the definition of operators which are robust to such lighting variations.},
   author = {Guillaume Noyel},
   doi = {10.1007/S10851-026-01346-1},
   issn = {1573-7683},
   issue = {5},
   journal = {Journal of Mathematical Imaging and Vision 2026 68:5},
   keywords = {Applications of Mathematics,Image Processing and Computer Vision,Image and Speech Processing,Mathematical Methods in Physics,Signal},
   month = {9},
   pages = {74-},
   publisher = {Springer},
   title = {Logarithmic Mathematical Morphology: Theory and Applications},
   volume = {68},
   url = {https://link.springer.com/article/10.1007/s10851-026-01346-1},
   year = {2026}
}

```

The code used to generate the paper illustrations is available in the folder [./Manuscript_code](./Manuscript_code).

The code used for the comparisons between different vessel segmentation algorithms in eye fundus images is available in the folder
 [./Eye_fundus/Result_analysis](./Eye_fundus/Result_analysis).
This corresponds to the 'Experiments and results' section of the manuscript.
In this folder, three scripts are available:
1. [Script_Darkening_Drive_images.m](./Eye_fundus/code/Script_Darkening_Drive_images.m) which darkens the images.
1. [Script_vessel_detection_by_LMM.m](./Eye_fundus/code/Script_vessel_detection_by_LMM.m) to detect vessels using the LMM (Logarithmic Mathematical Morphology) method.
1. [Script_Eval_results_Drive_with_Matlab.m](./Eye_fundus/code/Script_Eval_results_Drive_with_Matlab.m) to compare the results of vessel segmentation between four methods.

# External code

The function [CircleFit_TaubinSVD.m](./Manuscript_code/Function_sources/CircleFit_TaubinSVD.m) was written by Nicolas Chernov.
It can be downloaded from the following link https://people.cas.uab.edu/~mosya/cl/MATLABcircle.html

# DRIVE database (DRIVE Digital Retinal Images for Vessel Extraction)

A copy of the [DRIVE database](https://www.kaggle.com/datasets/andrewmvd/drive-digital-retinal-images-for-vessel-extraction) has been included in the folder 
[./Eye_fundus/Input/im/DRIVE](./Eye_fundus/Input/im/DRIVE).
The [groundtruth]((./Eye_fundus/Input/im/DRIVE/test/1st_manual)) of the test set can be found with [this link](https://github.com/wfdubowen/Retina-Unet/tree/master/DRIVE/test).

The DRIVE database was initially released in conjunction with the following paper.

Staal, J., Abramoff, M.D., Niemeijer, M., Viergever, M.A., van Ginneken, B.:
Ridge-based vessel segmentation in color images of the retina. IEEE Trans. Med.
Imag. 23(4), 501–509 (2004) https://doi.org/10.1109/TMI.2004.825627
