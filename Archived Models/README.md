# Archived Models

This directory contains outdated versions of iJF744 and the script used to update the most outdated to the current version. Specifically, the contents are as follows:

1. `alterDvhModel.m` : this script is used to update the iJF744 reconstruction to the most current version. As such, the script is updated as the model is altered and these updates are labeled with dates to signify when the changes took place. This script can alter any iJF744 model, but is designed to use the `fixed_genes_model.mat` file by default. 

2. `fixed_genes_model.mat` : this is our oldest archived version of iJF744 and marks the starting point of our Github-based approach to model update and organization. All updates to the model from this version forward are chronicled in the `alterDvhModel.m` script. 

3. Date-Stamped models: All models with format `YYYY_MM_DD_model.mat`, which are date-stamped to keep track of model changes with time. By keeping these models, our goal is to facilitate easy simulation of different model versions if this action is desired. These models are subject to increase in number, as a new "snapshot" should be stored here whenever the model is updated to the new, current version. 
