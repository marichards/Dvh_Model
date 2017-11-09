# Growth Simulations

This directory contains growth simulations for the 4 basic media conditions used to grow *Desulfovibrio vulgaris*, as well as a collection of related information. The files are described in more detail below

## Growth Scripts

These are the main scripts, which should generally be run to simulate maximum growth under one of the 4 different media. The scripts themselves are:

* `maxGrowthOnHS.m`
* `maxGrowthOnPS.m`
* `maxGrowthOnLS.m`
* `maxGrowthOnCC.m`

Each of these scripts can return both an FBA solution and a model configured to grow on the appropriate media. Additionally, flags to the functions determine whether they will print output and/or produce a `.svg` figure displaying the central fluxes. For a demonstration of how to run these scripts, please see the `README.md` in the root directory of the repository.

## Flux Figures

These 4 `.svg` figures show the central fluxes resulting from simulating maximum growth under the ascribed growth conditions. They are created using the included Perl script (`SVG_flux_adjust_test4.pl`) and can be remade using the growth scripts. The 4 aforementioned figures are:

* `HS_solution.svg`
* `PS_solution.svg`
* `LS_solution.svg`
* `CC_solution.svg`

## Alternate Reactions

As described in the manuscript (in revision), several reactions in the reconstruction were hypothesized to have multiple possible stoichiometries. In the contained script (`testAlternateRxns.m`), we simulated growth on all 4 media with the hypothesized reaction changes and collected the results in `alternate_rxn_results.xlsx`. These results supported the stoichiometries that appear in iJF744 rather than the alternate stoichiometries. 

## Reaction Essentiality

A key question regarding the models was which reactions were essential for growth under each media condition. In order to answer that question from an *in silico* standpoint, we created 2 scripts:

1. `runAllReactionEssentiality.m` : base reaction essentiality testing, using every reaction in the model and allowing flux loops
2. `runNoLoopEssentiality.m` : specialized reaction essentiality testing, using only key reactions and not allowing flux loops. Due to the much more finicky and complicated nature of this method, it was less feasible to test every reaction in the model

Our results from testing reaction essentiality with no loops are found in the `rxnEssentiality.xlsx` spreadsheet.

## *In silico* Media

The full *in silico* media for a given growth condition consists of all exchange reactions with negative lower bounds; that is, those reactions that allow a metabolite to be taken up into the model. For convenience, we collected these reactions for each of the 4 growth media and stored them in `full_insilico_media.xlsx` as a reference. 

## `setModelGAM.m`

A function used within the growth simulations to change a model's maintenance parameters. It takes in the model and the media condition, then changes the values in accordance with those found using scripts in the `ATPM Calculations` directory. 

## `compareFluxDistributions.m`

A script for taking two flux distributions and finding major differences. Useful for evaluating what has changed when comparing two separate simulations. 
