# Flux Variability (FVA)

This directory contains mostly experimental scripts aimed at quantifying and displaying the flux variability in the iJF744 models. Given our choice to limit flux loops in the model simulations, running FVA on iJF744 models presents a challenge in both time and in model covergence; that is, some models are unable to find a solution in a reasonable amount of time, if at all. Thus, these scripts are intended to help facilitate that process and hopefully shed light on the behavior of *Desulfovibrio vulgaris* under different growth conditions, particularly in regards to its flexibility. 

The data are broadly grouped as follows:

1. Running FVA on the models: the `runDvhFVA.m` script aims to run FVA on the most central reactions to the model. We chose to create this script because, with our loop restrictions, running FVA on the whole model at once is less feasible. The script runs through our specified list of reactions and, for each reaction, prints out its predicted maximum/minimum fluxes that achieve at least 93% of the maximum achievable biomass production (this value can be altered by altering the script). It also returns these fluxes to the user.

2. Data from FVA simulations: a few records of FVA simulations that store the data for later use. In particular, these are as follows:

- `table 2_11012016.xlsx` : Excel spreadsheets that catalog our results from running FVA scripts, including data that appear in the manuscript. The FVA sheets are the `FVA_analysis` and `FVA_QMO` sheets; other sheets appear in the workbook but are not relevant to FVA.
- `ps_FVA_95.mat` : flux data saved in Matlab format that pertains to running FVA on PS media with at least 95% of max biomass production rate
- `ls_FVA_95.mat` : flux data saved in Matlab format that pertains to running FVA on LS media with at least 95% of max biomass production rate

3. Plotting scripts: scripts used to plot FVA results. These are of 2 types, namely 1) Heatmaps showing flux differences and 2) Bar plots showing flux ranges. The specific scripts are as follows:

- `createFVAHeatMap.m` : given FVA data in the Excel workbook `table 2_11012016.xlsx`, creates a heatmap showing the varibility of different fluxes across different growth conditions
- `plotFVARanges.m` : a Matlab script that creates a barplot of max/min fluxes from an FVA simulation. The bar plot is created such that each bar starts at the minimum value and ends at the maximum value; thus, the size of the bar corresponds to flux variability, not to maximum/minimum values themselves.
- `plotFVARanges.R` : an R script that does the same as the previous script, but on a different platform. This can be seen as mostly experimental in comparison with the corresponding Matlab script, but could be used to generate the same sorts of plots. 
- `testFVAPlots.m` : a script that uses the `ps_FVA_95.mat` data and the `plotFVARanges.m` script to plot the FVA ranges for PS media

