# ATP Maintenance Calculations

Herein are contained scripts used to determine and change the ATP maintenance parameters in the iJF744 reconstruction such that all 4 models accurately reproduce experimental growth rates. The specific contents are as follows;

1. `findDvhATPM.m` : a function that calculates the ATP maintenance parameters given a model, a given growth condition ('HS', 'PS', 'LS', or 'CC'), experimental growth rates, and experimental uptake rates. An optional plot flag produces a graph showing the plot of ATP fluxes against growth rates. 

2. `findAllATPM.m` : a function that uses `findDvhATPM.m` on all 4 growth conditions to determine the maintenance parameters for all 4. The only input required here is the model itself

3. `changeDvhATPM.m` : a function that, given a model and values for growth-associated and non growth-associated maintenance, changes the parameters in the model to match those values

4. `Revised_Maintenance_calc....xlsx` : two files that contain the experimental parameters used to find the maintenance values for the various iJF744 models
