function [gam,ngam,atp_fluxes] = findDvhATPM(model,growth_condition,growth_rates,uptake_rates,plot_flag)

% Using measured experimental growth rates and methane evolution rate,
% constrain the model to measured rates and measure ATP hydrolysis that
% results. Repeat and graph ATPM vs growth rate to calculcate ATP
% maintenance

% Check to make sure growth rates and ch4 rates are the same length
if length(growth_rates) ~= length(uptake_rates)
    error('Please ensure that there are an equal number of growth rates and methane evolution rates');
end

% Make an ATP-hydrolyzing model by removing ATP from biomass, adjusting
% bounds on NGAM, and making NGAM the objective function

% Grab the indices first
bio_idx = find(model.c);
[~,h_idx] = intersect(model.mets,'cpd00067[c]');
[~,atp_idx] = intersect(model.mets,'cpd00002[c]');
[~,adp_idx] = intersect(model.mets,'cpd00008[c]');
[~,h2o_idx] = intersect(model.mets,'cpd00001[c]');
[~,p_idx] = intersect(model.mets,'cpd00009[c]');

% Remove ATP, ADP and Phosphate and H+ from biomass
model.S(atp_idx,bio_idx) = 0;
model.S(adp_idx,bio_idx) = 0;
model.S(p_idx,bio_idx) = 0;
model.S(h_idx,bio_idx) = 0;
model.S(h2o_idx,bio_idx) = 0;
% Call different cases based on growth condition and set uptake rxn
switch growth_condition
    
    case 'HS'       
        % Set uptake reaction to H2
        up_rxn = 'EX_cpd11640(e)';       
        
    case 'LS'
        % Set uptake reaction to lactate
        up_rxn = 'EX_cpd00159(e)';
        
    case 'PS'
        % Set uptake rate to pyruvate
        up_rxn = 'EX_cpd00020(e)';
        
    case 'CC'
        % Set uptake rate to lactate
        up_rxn = 'EX_cpd00159(e)';
end

% Change the objective to the NGAM reaction and change its bounds
model = changeObjective(model,model.rxns{bio_idx},0);
model = changeObjective(model,'rxn00062',1);
model = changeRxnBounds(model,'rxn00062',inf,'u');
model = changeRxnBounds(model,'rxn00062',-inf,'l');

% Initiate the atp_flux vector
atp_fluxes = zeros(size(growth_rates));

% Iterate through the supplied list of growth rates and uptake_rates 
for i = 1:length(growth_rates)
    
    % Constrain the model by the supplied growth rate and uptake rate
    model = changeRxnBounds(model,model.rxns{bio_idx},growth_rates(i),'b');
    model = changeRxnBounds(model,up_rxn,uptake_rates(i),'b');   
    
    % Simulate the model
    solution = optimizeCbModel(model,[],'one');%,false);

    % Pull out the flux of ATP and add to vector of ATP fluxes
    atp_fluxes(i) = solution.f;
end

% Pull out the slope and intercept of the atp fluxes vs growth rates
p = polyfit(growth_rates,atp_fluxes,1);

gam = p(1);
ngam = p(2);

% Check for plot flag
if nargin < 5
    plot_flag = false;
end

% If plot flag is true, plot the atp fluxes against growth rate
if plot_flag
    figure(2)    
    plot(growth_rates,atp_fluxes,'r.','MarkerSize',20);
    hold on
    calc = linspace(0,0.14,20)*gam+ngam;
    plot(linspace(0,0.14,20),calc,'b-','LineWidth',2)
    ylabel('ATP Flux ($$\frac{mmol}{gDCW \cdot h}$$)'...
    ,'Interpreter','latex','FontSize',14)
    xlabel('Growth Rate (h^{-1})','FontSize',14)
    legend('Predicted ATP Flux','Linear Model','Location','Northwest')
    hold off
end


