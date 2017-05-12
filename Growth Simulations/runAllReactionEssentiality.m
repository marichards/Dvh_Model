function [hs_ratio,ps_ratio,ls_ratio,cc_ratio] = runAllReactionEssentiality(model)

% Create the 4 different growth conditions
[~,hs_model] = maxGrowthOnHS(model,false,false);
[~,ps_model] = maxGrowthOnPS(model,false,false);
[~,ls_model] = maxGrowthOnLS(model,false,false);
[~,cc_model] = maxGrowthOnCC(model,false,false);

% Run single reaction essentiality on all of them
hs_ratio = singleRxnDeletion(hs_model);
ps_ratio = singleRxnDeletion(ps_model);
ls_ratio = singleRxnDeletion(ls_model);
cc_ratio = singleRxnDeletion(cc_model);

% Write to an Excel workbook
xlswrite('rxnEssentiality.xlsx',model.rxns,'Loops_allowed','A2:A1015')
xlswrite('rxnEssentiality.xlsx',hs_ratio,'Results','B2:B1015')
xlswrite('rxnEssentiality.xlsx',ls_ratio,'Results','C2:C1015')
xlswrite('rxnEssentiality.xlsx',ps_ratio,'Results','D2:D1015')
xlswrite('rxnEssentiality.xlsx',cc_ratio,'Results','E2:E1015')





