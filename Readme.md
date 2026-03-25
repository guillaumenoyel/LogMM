Guillaume NOYEL

# Logarithmic Mathematical Morphology: theory and applications

This is the manuscript's code.

Please cite it as follows:
```bibtex
@misc{noyel2025logarithmicmathematicalmorphologytheory,
      title={Logarithmic Mathematical Morphology: theory and applications}, 
      author={Guillaume Noyel},
      year={2025},
      eprint={2309.02007},
      archivePrefix={arXiv},
      primaryClass={eess.IV},
      url={https://arxiv.org/abs/2309.02007}, 
}
```

The code used to generate the manuscript illustrations is available in the folder [./Manuscript_code](./Manuscript_code).

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
