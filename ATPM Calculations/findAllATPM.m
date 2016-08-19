function [gam,ngam,atp_fluxes] = findAllATPM(model)


% Set all the growth rate and uptake rate vectors
growth_rates = [0.03,0.04,0.05];

cc_uptake = [0.0059,0.0069,0.0079];


% Run on the HS model
[gam,ngam,atp_fluxes] = findDvhATPM(model,'CC',growth_rates,cc_uptake,false);
    