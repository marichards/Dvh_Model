function [growth_rates,conditions,ratios] = testAlternateRxns(model)

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

% Create places to store fluxes, conditions, key ratios, plus an index
growth_rates = zeros(20,1);
conditions = cell(20,1);
ratios = zeros(20,1);
idx = 1;

% Find the different ratio indices
[~,so4_idx] = intersect(model.rxns,'EX_cpd00048(e)');
[~,h2_idx] = intersect(model.rxns,'EX_cpd11640(e)');
[~,lac_idx] = intersect(model.rxns,'EX_cpd00159(e)');
[~,pyr_idx] = intersect(model.rxns,'EX_cpd00020(e)');
[~,ac_idx] = intersect(model.rxns,'EX_cpd00029(e)');

% Specify growth/uptake rates
cc_growth_rates = [0.03,0.04,0.05,0.06];
cc_uptake = [5.9,6.9,7.9,8.9];

hs_growth_rates = [0.03,0.04,0.05,0.06];
hs_uptake = [31.836,35.114,38.393,41.672];

ps_growth_rates = [0.03,0.04,0.05,0.06];
ps_uptake = [4.256,4.742,5.227,5.712];

ls_growth_rates = [0.03,0.04,0.05];
ls_uptake = [8.4,9.733,11.0667];

% Run the 8 LS Simulations, print, and store them
% Print out the lactate to sulfate ratio
[solution,ls_model] = maxGrowthOnLS(model,false,false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_WT';
ratios(idx) = solution.x(lac_idx)/solution.x(so4_idx);
idx = idx + 1;

ldh_only = alterLDH(ls_model);
[gam,ngam] = findDvhATPM(ldh_only,'LS',[ls_growth_rates,0.06],[ls_uptake,12.4],false);
ldh_only = changeDvhATPM(ldh_only,gam,ngam);
solution = optimizeCbModel(ldh_only,[],'one',false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_LDH';
ratios(idx) = solution.x(lac_idx)/solution.x(so4_idx);
idx = idx + 1;

hdr_only = alterHDR(ls_model);
[gam,ngam] = findDvhATPM(hdr_only,'LS',[ls_growth_rates,0.06],[ls_uptake,12.4],false);
hdr_only = changeDvhATPM(hdr_only,gam,ngam);
solution = optimizeCbModel(hdr_only,[],'one',false);
growth_rates(idx) = solution.f; 
conditions{idx} = 'LS_HDR';
ratios(idx) = solution.x(lac_idx)/solution.x(so4_idx);
idx = idx + 1;

qmo_only = alterQMO(ls_model);
[gam,ngam] = findDvhATPM(qmo_only,'LS',ls_growth_rates,ls_uptake,false);
qmo_only = changeDvhATPM(qmo_only,gam,ngam);
solution = optimizeCbModel(qmo_only,[],'one',false);
growth_rates(idx) = solution.f;
ratios(idx) = solution.x(lac_idx)/solution.x(so4_idx);
conditions{idx} = 'LS_QMO';
idx = idx + 1;

hdr_ldh = alterHDR(alterLDH(ls_model));
[gam,ngam] = findDvhATPM(hdr_ldh,'LS',[ls_growth_rates,0.06],[ls_uptake,12.4],false);
hdr_ldh = changeDvhATPM(hdr_ldh,gam,ngam);
solution = optimizeCbModel(hdr_ldh,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(lac_idx)/solution.x(so4_idx);
conditions{idx} = 'LS_HDR_LDH';
idx = idx + 1;

qmo_ldh = alterQMO(alterLDH(ls_model));
[gam,ngam] = findDvhATPM(qmo_ldh,'LS',ls_growth_rates,ls_uptake,false);
qmo_ldh = changeDvhATPM(qmo_ldh,gam,ngam);
solution = optimizeCbModel(qmo_ldh,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(lac_idx)/solution.x(so4_idx);
conditions{idx} = 'LS_QMO_LDH';
idx = idx + 1;

qmo_hdr = alterQMO(alterHDR(ls_model));
[gam,ngam] = findDvhATPM(qmo_hdr,'LS',ls_growth_rates,ls_uptake,false);
qmo_hdr = changeDvhATPM(qmo_hdr,gam,ngam);
solution = optimizeCbModel(qmo_hdr,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(lac_idx)/solution.x(so4_idx);
conditions{idx} = 'LS_QMO_HDR';
idx = idx + 1;

qmo_hdr_ldh = alterQMO(alterHDR(alterLDH(ls_model)));
[gam,ngam] = findDvhATPM(qmo_hdr_ldh,'LS',[ls_growth_rates,0.06],[ls_uptake,12.4],false);
qmo_hdr_ldh = changeDvhATPM(qmo_hdr_ldh,gam,ngam);
solution = optimizeCbModel(qmo_hdr_ldh,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(lac_idx)/solution.x(so4_idx);
conditions{idx} = 'LS_QMO_HDR_LDH';
idx = idx + 1;

% Run the 4 CC Simulations, print, and store them
% Print out lactate to acetate ratio
[solution,cc_model] = maxGrowthOnCC(model,false,false);
growth_rates(idx) = solution.f; 
ratios(idx) = -solution.x(lac_idx)/solution.x(ac_idx);
conditions{idx} = 'CC_WT';
idx = idx + 1;

ldh_only = alterLDH(cc_model);
[gam,ngam] = findDvhATPM(ldh_only,'CC',cc_growth_rates,cc_uptake,false);
ldh_only = changeDvhATPM(ldh_only,gam,ngam);
solution = optimizeCbModel(ldh_only,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = -solution.x(lac_idx)/solution.x(ac_idx);
conditions{idx} = 'CC_LDH';
idx = idx + 1;

hdr_only = alterHDR(cc_model);
[gam,ngam] = findDvhATPM(hdr_only,'CC',cc_growth_rates,cc_uptake,false);
hdr_only = changeDvhATPM(hdr_only,gam,ngam);
solution = optimizeCbModel(hdr_only,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = -solution.x(lac_idx)/solution.x(ac_idx);
conditions{idx} = 'CC_HDR';
idx = idx + 1;

hdr_ldh = alterHDR(alterLDH(cc_model));
[gam,ngam] = findDvhATPM(hdr_ldh,'CC',cc_growth_rates,cc_uptake,false);
hdr_ldh = changeDvhATPM(hdr_ldh,gam,ngam);
solution = optimizeCbModel(hdr_ldh,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = -solution.x(lac_idx)/solution.x(ac_idx);
conditions{idx} = 'CC_HDR_LDH';
idx = idx + 1;

% Run the 4 HS Simulations, print, and store them
% Print out hydrogen to sulfate ratio
[solution,hs_model] = maxGrowthOnHS(model,false,false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(h2_idx)/solution.x(so4_idx);
conditions{idx} = 'HS_WT';
idx = idx + 1;

hdr_only = alterHDR(hs_model);
[gam,ngam] = findDvhATPM(hdr_only,'HS',hs_growth_rates,hs_uptake,false);
hdr_only = changeDvhATPM(hdr_only,gam,ngam);
solution = optimizeCbModel(hdr_only,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(h2_idx)/solution.x(so4_idx);
conditions{idx} = 'HS_HDR';
idx = idx + 1;

qmo_only = alterQMO(hs_model);
[gam,ngam] = findDvhATPM(qmo_only,'HS',hs_growth_rates,hs_uptake,false);
qmo_only = changeDvhATPM(qmo_only,gam,ngam);
solution = optimizeCbModel(qmo_only,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(h2_idx)/solution.x(so4_idx);
conditions{idx} = 'HS_QMO';
idx = idx + 1;

qmo_hdr = alterQMO(alterHDR(hs_model));
[gam,ngam] = findDvhATPM(qmo_hdr,'HS',hs_growth_rates,hs_uptake,false);
qmo_hdr = changeDvhATPM(qmo_hdr,gam,ngam);
solution = optimizeCbModel(qmo_hdr,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(h2_idx)/solution.x(so4_idx);
conditions{idx} = 'HS_QMO_HDR';
idx = idx + 1;

% Run the 4 PS Simulations, print, and store them
% Print out Pyruvate to sulfate ratio
[solution,ps_model] = maxGrowthOnPS(model,false,false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(pyr_idx)/solution.x(so4_idx);
conditions{idx} = 'PS_WT';
idx = idx + 1;

hdr_only = alterHDR(ps_model);
[gam,ngam] = findDvhATPM(hdr_only,'PS',ps_growth_rates,ps_uptake,false);
hdr_only = changeDvhATPM(hdr_only,gam,ngam);
solution = optimizeCbModel(hdr_only,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(pyr_idx)/solution.x(so4_idx);
conditions{idx} = 'PS_HDR';
idx = idx + 1;

qmo_only = alterQMO(ps_model);
[gam,ngam] = findDvhATPM(qmo_only,'PS',ps_growth_rates,ps_uptake,false);
qmo_only = changeDvhATPM(qmo_only,gam,ngam);
solution = optimizeCbModel(qmo_only,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(pyr_idx)/solution.x(so4_idx);
conditions{idx} = 'PS_QMO';
idx = idx + 1;

qmo_hdr = alterQMO(alterHDR(ps_model));
[gam,ngam] = findDvhATPM(qmo_hdr,'PS',ps_growth_rates,ps_uptake,false);
qmo_hdr = changeDvhATPM(qmo_hdr,gam,ngam);
solution = optimizeCbModel(qmo_hdr,[],'one',false);
growth_rates(idx) = solution.f; 
ratios(idx) = solution.x(pyr_idx)/solution.x(so4_idx);
conditions{idx} = 'PS_QMO_HDR';

% Print the final results
fprintf('\n\nCondition\t\tGrowth_Rate\t\tKey Ratio\n')
for i = 1:length(growth_rates)
    fprintf('%s\t\t%0.3f\t\t%0.3f\n',conditions{i},growth_rates(i),ratios(i))
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