function findAllATPM(model)


% Set all the growth rate and uptake rate vectors
% I fudged these!
cc_growth_rates = [0.03,0.04,0.05,0.06];
cc_uptake = [5.9,6.9,7.9,8.9];

hs_growth_rates = [0.03,0.04,0.05,0.06];
hs_uptake = [31.836,35.114,38.393,41.672];

ps_growth_rates = [0.03,0.04,0.05,0.06];
ps_uptake = [4.256,4.742,5.227,5.712];

ls_growth_rates = [0.03,0.04,0.05,0.060001];
ls_uptake = [8.4,9.733,11.0667,12.4];


% Create the correct model
[~,cc_model] = maxGrowthOnCC(model,false);
[~,hs_model] = maxGrowthOnHS(model,false);
[~,ls_model] = maxGrowthOnLS(model,false);
[~,ps_model] = maxGrowthOnPS(model,false);

% Run on the HS model

[cc_gam,cc_ngam,cc_atp_fluxes] = findDvhATPM(cc_model,'CC',cc_growth_rates,cc_uptake,false);
[hs_gam,hs_ngam,hs_atp_fluxes] = findDvhATPM(hs_model,'HS',hs_growth_rates,hs_uptake,false);
[ps_gam,ps_ngam,ps_atp_fluxes] = findDvhATPM(ps_model,'PS',ps_growth_rates,ps_uptake,false);
[ls_gam,ls_ngam,ls_atp_fluxes] = findDvhATPM(ls_model,'LS',ls_growth_rates,ls_uptake,false);


% Print them out for convenience
fprintf('\n\nATP Maintenance Parameters\n\n')

disp({'Media','GAM','NGAM'})
disp({'CC',cc_gam,cc_ngam})
disp({'HS',hs_gam,hs_ngam})
disp({'PS',ps_gam,ps_ngam})
disp({'LS',ls_gam,ls_ngam})

% Create plots of ATP fluxes for each

figure(1)
hold on
plot(cc_growth_rates,cc_atp_fluxes,'b*')
plot(hs_growth_rates,hs_atp_fluxes,'r*')
plot(ps_growth_rates,ps_atp_fluxes,'g*')
plot(ls_growth_rates,ls_atp_fluxes,'k*')

xlabel('Growth rate (1/h)')
ylabel('ATP Flux (mmol/gdw/h)')
title('ATP Maintenance Plot')
legend('CC Media','HS Media','PS Media','LS Media')
hold off