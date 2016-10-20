function [solution,model] = maxGrowthOnLS(model,plot_flag,print_flag)

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

% Check for print flag and set default = true
if nargin < 3
    print_flag = 1;
end

% Change media conditions to match HS media
% Lactate
model = changeRxnBounds(model,'EX_cpd00159(e)',-12.4,'b');
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
model = changeRxnBounds(model,'EX_cpd00020(e)',0,'b');
% Pyrophosphate
model = changeRxnBounds(model,'EX_cpd00012(e)',0,'b');

% Set bounds on the QMO reactions to activate fermentative version
model = changeRxnBounds(model,'rxn11934B_CC',0,'b');
model = changeRxnBounds(model,'rxn11934B_SR',-1000,'l');
model = changeRxnBounds(model,'rxn11934B_SR',1000,'u');

% Set bounds on NGAM and QRC
model = changeRxnBounds(model,'rxn00062',5.7197,'b');
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

% Alter biomass to the proper GAM value, which is 125
model = setModelGAM(model,'LS');

% Simulate growth while minimizing the sum of fluxes and not allowing loops
% **Note that setting allowLoops to "false" causes this function to run
% much slower, about 2-4 times as slowly
solution = optimizeCbModel(model,[],'one',false);

% Retrieve key reaction indices
if solution.f > 0
    [~,bio_idx] = intersect(model.rxns,'bio_DvH_125gam');
    [~,h2s_idx] = intersect(model.rxns,'EX_cpd00239(e)');
    [~,so4_idx] = intersect(model.rxns,'EX_cpd00048(e)');
    [~,ldh_idx] = intersect(model.rxns,'rxn08793A');
    [~,ac_idx] = intersect(model.rxns,'EX_cpd00029(e)');
    [~,for_idx] = intersect(model.rxns,'EX_cpd00047(e)');
    [~,lac_idx] = intersect(model.rxns,'EX_cpd00159(e)');
    [~,h2_idx] = intersect(model.rxns,'EX_cpd11640(e)');
    [~,pyr_idx] = intersect(model.rxns,'EX_cpd00020(e)');
    
    if print_flag
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
    
    % Plot the solution
    if nargin < 2
        plot_flag = 1;
    end
    
    if plot_flag
        plotSRFlux(model,solution,0.5);
    end
    
end
end

function plotSRFlux(model,solution,threshhold)

% Create a list of reactions for plotting out
% Reactions I dropped (weren't in model):
% 'EX_cpd00026[c]','bio_DvH','rxn08793B','rxn11934A','rxn14411','rxn14418A'

graph={'EX_cpd00047(e)','EX_cpd00159(e)','rxn14404','rxn00157',...
    'rxn00173','rxn00225','rxn05488','rxn05602','rxn05938',...
    'rxn08793A','EX_cpd00209(e)','rxn14405','rxn08971', 'rxn14407',...
    'rxn14408','EX_cpd11640(e)','rxn14410','rxn14412','rxn14414',...
    'rxn14417A','rxn14403', 'rxn14415','EX_cpd00239(e)', 'EX_cpd00048(e)',...
    'rxn05651A', 'rxn00379', 'rxn14419', 'rxn14413A', 'rxn14416',...
    'rxn14418','EX_cpd00011(e)','rxn10042', 'rxn00371A','rxn14420',...
    'rxn00175', 'rxn11934B_SR'};

fid=fopen('./test_out.txt', 'wt');

% Intersect it instead of straight-up looping
[rxns,idx] = intersect(model.rxns,graph,'stable');

for i=1:length(graph) %cycle through the list of reactions
    
    if (abs(solution.x(idx(i)))>=threshhold); %if particular reaction (i) has |flux| > 0.5 then  exists in the model
        
        fprintf(fid, '%s \t %s  \t %f\t %f \t %f \n', rxns{i},...
            model.rxnNames{idx(i)}, solution.x(idx(i)),...
            model.lb(idx(i)), model.ub(idx(i)));
    end
end
%system(['open ' solutionname])
perl('./SVG_flux_adjust_test4.pl','drawing_moreW25A_new.svg', 'test_out.txt', 'LS_solution.svg');
end