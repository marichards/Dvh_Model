function [ngam,bio_flux,solution] = hackATPM(model)

% Use alternate NGAM determination method

% Change model objective
bio_idx = find(model.c);
model = changeObjective(model,{model.rxns{bio_idx},'rxn00062'},[0 1]);
model = changeRxnBounds(model,'rxn00062',-inf,'l');
model = changeRxnBounds(model,'rxn00062',inf,'u');

% Grab indices
[~,h_idx] = intersect(model.mets,'cpd00067[c]');
[~,atp_idx] = intersect(model.mets,'cpd00002[c]');
[~,adp_idx] = intersect(model.mets,'cpd00008[c]');
[~,h2o_idx] = intersect(model.mets,'cpd00001[c]');
[~,p_idx] = intersect(model.mets,'cpd00009[c]');

% Remove from biomass
model.S(atp_idx,bio_idx) = 0;
model.S(adp_idx,bio_idx) = 0;
model.S(p_idx,bio_idx) = 0;
model.S(h_idx,bio_idx) = 0;
model.S(h2o_idx,bio_idx) = 0;

% Change biomass bounds
model = changeRxnBounds(model,model.rxns{bio_idx},0.06,'b');

% Change CC rate to -2.9
model = changeRxnBounds(model,'EX_cpd00020(e)',-5.71,'b');
solution = optimizeCbModel(model,[],'one',false);
ngam = solution.f;
bio_flux = solution.x(bio_idx);