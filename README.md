# iJF744: A Genome Scale Metabolic Reconstruction of *Desulfovibrio vulgaris*

*Desulfovibrio vulgaris* is a bacterium with remarkable flexible metabolism. It can grow on multiple different substrates on its own, or in co-cultures with methanogenic archaea. This repository contains the metabolic reconstruction of *D. vulgaris*, including scripts for simulating 4 different models, each growing under distinct conditions. More specifically, the contents of the repository are described below:

## iJF744.xml

The SBML formatted file of the reconstruction, which can be used on numerous different platforms. In this default reconstruction file, the organism is configured to grow on hydrogen sulfate (HS) media. This is the same file found in the Biomodels database (MODEL1706150001) and in the manuscript (currently in revision). 

## 2016_09_29_model.mat

The latest version of the iJF744 model in MATLAB format, configured to grow on HS media. As a metabolic reconstruction is a malleable entity, we anticipate that the model will continue to change with time. Thus, we intend to perpetually keep this snapshot of the latest model that can quickly be loaded and used for simulations. 

## Growth Simulations

A collection of scripts that simulate growth of *D. vugarlis* on 4 different media conditions, including:

* Hydrogen sulfate (HS) media, involving sulfate respiration
* Lactate sulfate (LS) media, involving sulfate respiration
* Pyruvate sulfate (PS) media, involving sulfate resperation
* Co-culture (CC) media, involing lactate fermentation in syntrophy with *Methanococcus maripaludis*

Each script alters the model to grow under the specified condition,conducts the growth simulation, and returns the flux solution and the altered model. Additionally, each script prints out major metabolite uptake and production fluxes, including the predicted rate of cell growth, and can optionally produce a .svg image showing the major fluxes in the simulation.

## Archived Models

As described above, the iJF744 reconstruction is a living entity and has been updated over time. This directory houses some older versions of the model, which may be used if errors are discovered with a newer model or if they are desired for the sake of comparisons. They also serve as a record of changes made to the model. 

## Flux Variability

Contains scripts and plots used to explore flux variability in iJF744. The intention of these scripts was to gain insight into flux variability for a core set of reactions under different growth conditions. 

## ATPM Calculations

Calculating growth-associated and non growth-associated ATP maintenance is an important process for fitting a model to experimental data. The scripts in this directory were used to partially automate this process, calculating the maintenance parameters for each growth condition given the appropriate experimental data. 

## Input_Output_Guides

A collection of plain text files that detail which reactions are most central  and which fluxes should be constrained under each growth condition. The material in these files guide the constraints applied by the scripts in the `Growth Simulations` directory. 

# Model simulation tutorial

For most straightforward simulation, we recommend using the scripts in the `Growth Simulations` directory. Like any other constraint-based model, the iJF744 models can be simulated using the tools from the Cobra Toolbox in MATLAB as well; however, our scripts simplify this process for iJF744 by quickly setting the proper flux constraints for a given growth condition. 

The following short tutorial demonstrates how to simulate iJF744 on both HS media and CC media:

## Simulation of iJF744 on different media

**1. Load the latest model**

```
% This assumes you are in the root directory of the repository
load('2016_09_29_model.mat')
```

**2. Initialize the Cobra Toolbox**

```
% This is a standard step to initialize the solver
initCobraToolbox
```

**3a. Run the HS Growth Simulation Script - solution only**

Either navigate to the Growth Simulations directory OR add that directory to your path. 

```
% Here, we set the flags to return only the solution, with no flux plot
solution = maxGrowthOnHS(model, false, true)
```

Note that we could have returned the model here as well, but there is no reason to do so because the model we loaded is already configured to grow on HS media. 

**3b. Run the CC Growth Simulation Script - return all output**

First, navigate to the Growth Simulation directory (the perl scripts for making flux plots are in this directory), then run the script to return everything:

```
% Here, the plot and print flags are both set to 'true' and we return both the solution and the model
[solution, cc_model] = maxGrowthOnCC(model, true, true)
```

Unlike the previous simulation, we returned the model, which differs from the one we started with in that it is configured to grow under syntrophic (CC media) conditions. 
