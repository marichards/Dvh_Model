function model = setModelGAM(model,growth_condition)

% This function accepts a value for growth associate maintenance (GAM) and
% sets that value in the biomass function of the model. It also renames the
% biomass reaction to the "bio_DvH_#gam", where "#" is the supplied value
%
% INPUT
% model: the D. vulgaris model, a COBRA toolbox model structure
% growth_condition: a 2-letter abbreviation indicating the desired model
% growth condition; acceptable inputs are {'HS','LS','PS','CC'}
%
% OUTPUT
% model: the D. vulgaris model with its biomass function altered to match
% the growth-associated maintenance of the desired growth condition
%
% Written by Matthew Richards, 2016/08/01

% Grab the indices first
bio_idx = find(model.c);
[~,h_idx] = intersect(model.mets,'cpd00067[c]');
[~,atp_idx] = intersect(model.mets,'cpd00002[c]');
[~,adp_idx] = intersect(model.mets,'cpd00008[c]');
[~,h2o_idx] = intersect(model.mets,'cpd00001[c]');
[~,p_idx] = intersect(model.mets,'cpd00009[c]');

% Call different cases based on growth condition
switch growth_condition
    
    case 'HS'
        % Rename the biomass accordingly
        model.rxns{bio_idx} = 'bio_DvH_5gam';
        
        % Adjust the stoichiometric coefficients for ATP hydrolysis
        model.S(h_idx,bio_idx) = 5;       
        model.S(atp_idx,bio_idx) = -5.174831;        
        model.S(adp_idx,bio_idx) = 5;        
        model.S(h2o_idx,bio_idx) = 0.345;      
        model.S(p_idx,bio_idx) = 4.996052;
        
    case 'LS'
        % Rename the biomass accordingly
        model.rxns{bio_idx} = 'bio_DvH_85gam';
        
        % Adjust the stoichiometric coefficients for ATP hydrolysis
        model.S(h_idx,bio_idx) = 85;       
        model.S(atp_idx,bio_idx) = -85.175;        
        model.S(adp_idx,bio_idx) = 85;        
        model.S(h2o_idx,bio_idx) = -79.651527;      
        model.S(p_idx,bio_idx) = 84.996052;
        
    case 'PS'
        % Rename the biomass accordingly
        model.rxns{bio_idx} = 'bio_DvH_65gam';
        % Adjust the stoichiometric coefficients for ATP hydrolysis
        model.S(h_idx,bio_idx) = 65;       
        model.S(atp_idx,bio_idx) = -65.175;        
        model.S(adp_idx,bio_idx) = 65;        
        model.S(h2o_idx,bio_idx) = -59.651527;      
        model.S(p_idx,bio_idx) = 64.996052;
        
    case 'CC'
        % Rename the biomass accordingly
        model.rxns{bio_idx} = 'bio_DvH_115gam';
        
        % Adjust the stoichiometric coefficients for ATP hydrolysis
        model.S(h_idx,bio_idx) = 115;       
        model.S(atp_idx,bio_idx) = -115.175;        
        model.S(adp_idx,bio_idx) = 115;        
        model.S(h2o_idx,bio_idx) = -109.651527;      
        model.S(p_idx,bio_idx) = 114.996052;
end

