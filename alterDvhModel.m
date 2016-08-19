function model = alterDvhModel(model)

% This function takes in the Desulfovibrio vulgaris model with correct
% genes and alters it to add some minor fixes and updates. The model used
% by this function is stored in "fixed_genes_model.mat". 
%
% INPUT
% model: the D. vulgaris model with 744 genes, as created by JF and altered
% by MR on 2016/07/28. 
%
% OUTPUT
% model: the updated D. vulgaris model
%
% Written by Matthew Richards, 2016/08/01

%%%%%%%%%%%%%%%%%%
% 2016/08/01
%%%%%%%%%%%%%%%%%%

% Rename rxn05938 as Pyruvate Synthase
[~,idx] = intersect(model.rxns,'rxn05938');
model.rxnNames{idx} = 'Pyruvate synthase';

% Remove the Protein Biosynthesis, DNA replication, and RNA transcription
% "reactions" from the model
model = removeRxns(model,{'rxn13782','rxn13783','rxn13784'});

% Fix the capitalization of "'Ex_cpd00218'"
[~,idx] = intersect(model.rxns,'Ex_cpd00218');
model.rxns{idx} = 'EX_cpd00218(e)';

% Note that the input model is "CC" type
% Re-name the existing QMO/rxn11934B reaction as "rxn11934_CC"
% [~,idx] = intersect(model.rxns,'rxn11934B');
% model.rxns{idx} = 'rxn11934B_CC';
% model.rxnNames{idx} = 'QMO (Co-culture)';
[~,idx] = intersect(model.rxns,'rxn11934B');
model.rxns{idx} = 'rxn11934B_SR';
model.rxnNames{idx} = 'QMO (Sulfate Reducing)';

% Add the alternate version of QMO/rxn11934B as "rxn11934_F"
%model = addReaction(model,{'rxn11934B_SR','QMO (Sulfate Reducing)'},...
%    'cpd11620[c] + 2 cpd00193[c] + 4 cpd00067[c] + cpd15499[c] <=> 2 cpd00081[c] + cpd11621[c] + 2 cpd00067[e] + cpd15500[c] + 2 cpd00018[c]');
model = changeGeneAssociation(model,'rxn11934B_SR','(206273 and 206274 and 206275 and 206276 and 206277)');

% Add the other alternate version, the CC reaction
model = addReaction(model,{'rxn11934B_CC','QMO (Co-culture)'},...
    'cpd11620[c] + 2 cpd00067[c] + 2 cpd15500[c] + cpd18072[c] <=> cpd11621[c] + 2 cpd15499[c] + cpd18073[c]');
model = changeGeneAssociation(model,'rxn11934B_CC','(206273 and 206274 and 206275 and 206276 and 206277)');

% Configure the "default" reaction bounds to turn off the co-culture one
model = changeRxnBounds(model,'rxn11934B_CC',0,'b');

% Alter the exchange reactions for hydrogen, acetate, and pyruvate to 
% 'EX_....'
[~,idx] = intersect(model.rxns,'rxn14409');
model.rxns{idx} = 'EX_cpd11640(e)';
[~,idx] = intersect(model.rxns,'rxn10904');
model.rxns{idx} = 'EX_cpd00029(e)';
[~,idx] = intersect(model.rxns,'rxn10929');
model.rxns{idx} = 'EX_cpd00020(e)';

