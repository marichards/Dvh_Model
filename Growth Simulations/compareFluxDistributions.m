function [rxns,flux1,flux2] = compareFluxDistributions(model,solution1,solution2,threshold)

% Given a COBRA model and 2 different flux distributions, compare the major
% differences in fluxes between the two models and print output in a
% nicely-formatted way.
%
% INPUT
% model: a COBRA toolbox model structure
% solution1: a flux distribution calculated using "model"
% solution2: a flux distribution calculated using "model" and different
% from solution1
%
% Written by Matthew Richards 10/3/2016

% Define a threshold of relative flux difference to investigate
if nargin < 4
    threshold = 1;
end

% Create a vector of relative differences
diff = zeros(length(solution2.x),1);
for i = 1:length(solution2.x)
    diff(i) = abs((solution2.x(i) - solution1.x(i))/...
        max(abs(solution2.x(i)),abs(solution1.x(i))));
    
end

% Find fluxes that have differences greater than the threshold
changed_idx = find(diff>threshold);

rxns = model.rxns(changed_idx);
flux1 = solution1.x(changed_idx);
flux2 = solution2.x(changed_idx);

% Print them out
fprintf('\n%d Major Flux Differences of %d%%\n\n',length(rxns),threshold*100)
fprintf('Reaction\tFlux 1\tFlux 2\n')
for i = 1:length(rxns)
    fprintf('%s\t%0.2f\t%0.2f\n',rxns{i},flux1(i),flux2(i))
end



