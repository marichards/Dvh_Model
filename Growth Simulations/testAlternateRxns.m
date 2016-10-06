function [growth_rates,conditions] = testAlternateRxns(model)

% Using the D. vulgaris model, test alternate stoichiometries for electron
% carriers in the QMO, Hdr-Flx, and Ldh reactions
%
% INPUT
% model: the D. vulgaris model, a COBRA toolbox model structure
%
% OUTPUT
% 
%
% Written by Matthew Richards, 10/05/2016

% Create places to store fluxes and growth conditions, plus an index
growth_rates = zeros(20,1);
conditions = cell(20,1);
idx = 1;

% Create the different varieties
qmo_hdr_ldh = alterQMO(alterHDR(alterLDH(model)));
qmo_hdr = alterQMO(alterHDR(model));
qmo_ldh = alterQMO(alterLDH(model));
hdr_ldh = alterHDR(alterLDH(model));
qmo_only = alterQMO(model);
hdr_only = alterHDR(model);
ldh_only = alterLDH(model);

% Run the 8 LS Simulations, print, and store them
solution = maxGrowthOnLS(model,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_WT';
idx = idx + 1;

solution = maxGrowthOnLS(ldh_only,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_LDH';
idx = idx + 1;

solution = maxGrowthOnLS(hdr_only,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_HDR';
idx = idx + 1;

solution = maxGrowthOnLS(qmo_only,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_QMO';
idx = idx + 1;

solution = maxGrowthOnLS(hdr_ldh,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_HDR_LDH';
idx = idx + 1;

solution = maxGrowthOnLS(qmo_ldh,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_QMO_LDH';
idx = idx + 1;

solution = maxGrowthOnLS(qmo_hdr,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_QMO_HDR';
idx = idx + 1;

solution = maxGrowthOnLS(qmo_hdr_ldh,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_QMO_HDR_LDH';
idx = idx + 1;

% Run the 4 CC Simulations, print, and store them
solution = maxGrowthOnCC(model,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'CC_WT';
idx = idx + 1;

solution = maxGrowthOnCC(ldh_only,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'CC_LDH';
idx = idx + 1;

solution = maxGrowthOnCC(hdr_only,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'CC_HDR';
idx = idx + 1;

solution = maxGrowthOnCC(hdr_ldh,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'CC_HDR_LDH';
idx = idx + 1;

% Run the 4 HS Simulations, print, and store them
solution = maxGrowthOnHS(model,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'HS_WT';
idx = idx + 1;

solution = maxGrowthOnHS(hdr_only,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'HS_HDR';
idx = idx + 1;

solution = maxGrowthOnHS(qmo_only,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'HS_QMO';
idx = idx + 1;

solution = maxGrowthOnHS(qmo_hdr,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'HS_QMO_HDR';
idx = idx + 1;

% Run the 4 PS Simulations, print, and store them
solution = maxGrowthOnPS(model,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'PS_WT';
idx = idx + 1;

solution = maxGrowthOnPS(hdr_only,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'PS_HDR';
idx = idx + 1;

solution = maxGrowthOnPS(qmo_only,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'PS_QMO';
idx = idx + 1;

solution = maxGrowthOnPS(qmo_hdr,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'PS_QMO_HDR';

% Print the final results
fprintf('\n\nCondition\t\tGrowth_Rate\n')
for i = 1:length(growth_rates)
    fprintf('%s\t\t%0.3f\n',conditions{i},growth_rates(i))
end

end

function model = alterQMO(model)
% QMO variation: substitute MQH2 -> MQ for 1/2 Fdred + 1/2 MQH2 -> 
% 1/2 Fdox + 1/2 MQ
% Note: Do this for only rxn11934B_SR
model = addReaction(model,'rxn11934B_SR',...
    'cpd00193[c] + 2 cpd00067[c] + cpd15499[c] <=> cpd00081[c] + 2 cpd00067[e] + cpd15500[c] + cpd00018[c]');
end

function model = alterHDR(model)
% Hdr-Flx variation: substitute 3 H+ + NADH + 2 DsrCox -> NAD + 2 DsrCred
% for 2 NAD + DsrCred -> 2 NADH + DsrCox
% This is reaction 11417A
model = addReaction(model,'rxn14417A',...
    'cpd11620[c] + 3 cpd00067[c] + cpd00004[c] + 2 cpd18073[c] -> cpd11621[c] + cpd00003[c] + 2 cpd18072[c]');
end

function model = alterLDH(model)
% Ldh variation: substitute MQ -> MQH2 for DsrCox -> DsrCred
% Note: This is rxn08793A
model = addReaction(model,'rxn08793A',...
    'cpd00159[c] + cpd15500[c] -> cpd00020[c] + cpd15499[c]');
end