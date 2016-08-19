function [solution,model] = maxGrowthOnPS(model)

% This function takes in the Desulfovibrio vulgaris model and simulates
% growth on HS media
%
% INPUT
% model: the D. vulgaris model, a COBRA toolbox model structure
%
% OUTPUT
% solution: a flux balance analysis solution to the D. vulgaris model
% model: the D. vulgaris model configured to grow on HS media
% 
% Written by Matthew Richards 2016/08/01

% Change media conditions to match HS media
% Lactate
model = changeRxnBounds(model,'EX_cpd00159(e)',0,'b');
% Sulfate
model = changeRxnBounds(model,'EX_cpd00048(e)',-1000,'l');
model = changeRxnBounds(model,'EX_cpd00048(e)',0,'u');
% Hydrogen
model = changeRxnBounds(model,'EX_cpd11640(e)',0,'b');
% Acetate
model = changeRxnBounds(model,'EX_cpd00029(e)',0,'l');
model = changeRxnBounds(model,'EX_cpd00029(e)',1000,'u');
% H2S
model = changeRxnBounds(model,'EX_cpd00239(e)',0,'l');
model = changeRxnBounds(model,'EX_cpd00239(e)',1000,'u');
% Cysteine
model = changeRxnBounds(model,'EX_cpd00084(e)',0,'l');
model = changeRxnBounds(model,'EX_cpd00084(e)',1000,'u');
% Pyruvate
model = changeRxnBounds(model,'EX_cpd00020(e)',-5.712,'b');

% Set bounds on the QMO reactions to activate fermentative version
model = changeRxnBounds(model,'rxn11934B_CC',0,'b');
model = changeRxnBounds(model,'rxn11934B_SR',-1000,'l');
model = changeRxnBounds(model,'rxn11934B_SR',1000,'u');

% Set bounds on NGAM and QRC
model = changeRxnBounds(model,'rxn00062',2,'b');
model = changeRxnBounds(model,'rxn14412',-1000,'l');
model = changeRxnBounds(model,'rxn14412',0,'u');

% Set bounds on rxn14404, rxn14407, rxn14410 and 14419
model = changeRxnBounds(model,'rxn14404',0,'l');
model = changeRxnBounds(model,'rxn14404',1000,'u');
model = changeRxnBounds(model,'rxn14407',-1000,'l');
model = changeRxnBounds(model,'rxn14407',1000,'u');
model = changeRxnBounds(model,'rxn14410',-1000,'l');
model = changeRxnBounds(model,'rxn14410',1000,'u');
model = changeRxnBounds(model,'rxn14419',-1000,'l');
model = changeRxnBounds(model,'rxn14419',1000,'u');

% Alter biomass to the proper GAM value, which is 65
model = setModelGAM(model,'PS');

% Simulate growth while minimizing the sum of fluxes and not allowing loops
% **Note that setting allowLoops to "false" causes this function to run
% much slower, about 2-4 times as slowly
solution = optimizeCbModel(model,[],'one',false);

% Retrieve key reaction indices
if solution.f > 0 
[~,bio_idx] = intersect(model.rxns,'bio_DvH_65gam');
[~,h2s_idx] = intersect(model.rxns,'EX_cpd00239(e)');
[~,so4_idx] = intersect(model.rxns,'EX_cpd00048(e)');
[~,ldh_idx] = intersect(model.rxns,'rxn08793A');
[~,ac_idx] = intersect(model.rxns,'EX_cpd00029(e)');
[~,for_idx] = intersect(model.rxns,'EX_cpd00047(e)');
[~,lac_idx] = intersect(model.rxns,'EX_cpd00159(e)');
[~,h2_idx] = intersect(model.rxns,'EX_cpd11640(e)');
[~,pyr_idx] = intersect(model.rxns,'EX_cpd00020(e)');

% Print fluxes for key reactions
fprintf('\n\nBiomass flux: %f\n\n',solution.x(bio_idx))
fprintf('H2S flux: %f\n',solution.x(h2s_idx))
fprintf('SO4 flux: %f\n',solution.x(so4_idx))
fprintf('Acetate flux: %f\n',solution.x(ac_idx))
fprintf('Formate flux: %f\n',solution.x(for_idx))
fprintf('Lactate flux: %f\n',solution.x(lac_idx))
fprintf('Hydrogen flux: %f\n',solution.x(h2_idx))
fprintf('Pyruvate flux: %f\n\n',solution.x(pyr_idx))

% This is somewhat separate
fprintf('Flux through Lactate Dehydrogenase: %f\n',solution.x(ldh_idx))

end