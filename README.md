# generate_3d_data
# This repository has the code for converting the RTdicom structures into regular Nifti Files

First step is to make sure that we have a folder per patient.
This patient folder must contain 2 folders: RTstruct and CT.
In the original format given by the doctro this is not the case; you can do this either manually,
or use the script called move_folder_ct.py.

We have to change in this script the directory including all the patients.


Then we need to run the script called stage_data.m to generate the labels from the RT files. This will create folders with the name of the organs, and will save png files for every slice.


Finally we need to run the script gt_volume.py in order to convert the png files into nifti, and then merge all the labels into one single file.
Additionally, it will convert the Dicom CT into nifti.

Optionally we can run the script create_clean_dataset.py that will get only the .nii.gz files created and copy them to a new folder.
