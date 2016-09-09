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
        model.rxns{bio_idx} = 'bio_DvH_2gam';
        
        % Adjust the stoichiometric coefficients for ATP hydrolysis
        model.S(h_idx,bio_idx) = 1.6275;       
        model.S(atp_idx,bio_idx) = -1.6275;        
        model.S(adp_idx,bio_idx) = 1.6275;        
        model.S(h2o_idx,bio_idx) = -1.6275;      
        model.S(p_idx,bio_idx) = 1.6275;
        
    case 'LS'
        % Rename the biomass accordingly
        model.rxns{bio_idx} = 'bio_DvH_125gam';
        
        % Adjust the stoichiometric coefficients for ATP hydrolysis
        model.S(h_idx,bio_idx) = 125.19;       
        model.S(atp_idx,bio_idx) = -125.19;        
        model.S(adp_idx,bio_idx) = 125.19;        
        model.S(h2o_idx,bio_idx) = -125.19;      
        model.S(p_idx,bio_idx) = 125.19;
        
    case 'PS'
        % Rename the biomass accordingly
        model.rxns{bio_idx} = 'bio_DvH_33gam';
        % Adjust the stoichiometric coefficients for ATP hydrolysis
        model.S(h_idx,bio_idx) = 33.49;       
        model.S(atp_idx,bio_idx) = -33.49;        
        model.S(adp_idx,bio_idx) = 33.49;        
        model.S(h2o_idx,bio_idx) = -33.49;      
        model.S(p_idx,bio_idx) = 33.49;
        
    case 'CC'
        % Rename the biomass accordingly
        model.rxns{bio_idx} = 'bio_DvH_89gam';
        
        % Adjust the stoichiometric coefficients for ATP hydrolysis
        model.S(h_idx,bio_idx) = 88.9125;       
        model.S(atp_idx,bio_idx) = -88.9125;        
        model.S(adp_idx,bio_idx) = 88.9125;        
        model.S(h2o_idx,bio_idx) = -88.9125;      
        model.S(p_idx,bio_idx) = 88.9125;
end

