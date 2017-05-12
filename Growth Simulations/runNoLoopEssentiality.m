function results = runNoLoopEssentiality(model)

% Create reaction subset
rxns = {'rxn05488';
'rxn00225';
'rxn00175';
'rxn10042';	
'EX_cpd00011(e)';
'rxn14418';
'rxn14404';
'rxn14403';
'rxn14410';
'rxn00371A';
'EX_cpd00047(e)';
'rxn14414';
'rxn14417A';
'rxn14413A';
'EX_cpd00239(e)';
'rxn14415';
'rxn14408';
'rxn14407';
'rxn05602';
'rxn08793A';
'rxn00157';
'rxn05938';
'rxn00173';
'rxn11934B_SR';
'rxn11934B_CC';
'rxn14412';
'rxn14416';
'rxn00379';
'EX_cpd00048(e)';
'rxn05651A';
'rxn14419'};

% Create generic base models and solutions
fprintf('Creating HS Model\n')
[hs_wt,hs_model] = maxGrowthOnHS(model,false,false);
fprintf('Creating PS Model\n')
[ps_wt,ps_model] = maxGrowthOnPS(model,false,false);
fprintf('Creating LS Model\n')
[ls_wt,ls_model] = maxGrowthOnLS(model,false,false);
fprintf('Creating CC Model\n')
[cc_wt,cc_model] = maxGrowthOnCC(model,false,false);

% Create a matrix to store solutions in (HS,PS,LS,CC)
results = zeros(length(rxns),4);

% Create a wait bar
my_wait = waitbar(0,'HS_model in Progress...');

% Run HS
for i = 1:length(rxns)    
    % Turn off reaction and test for growth
    test = changeRxnBounds(hs_model,rxns{i},0,'b');
    
    % Put a timer on that restricts it to 20 seconds
    solution = NaN;       
    i
    try
        t0 = clock;
        while(etime(clock,t0) < 20)
        solution = optimizeCbModel(test,[],'one',false); 
        break
        end
    catch
        warning('Problem with %s on HS; assigning NaN',rxns{i})
        solution = NaN;
    end
    % Find rxn flux for result 
    if isstruct(solution)
    results(i,1) = solution.f/hs_wt.f;    
    else
        results(i,1) = solution/hs_wt.f;
    end
    % Update wait bar
    waitbar(i/length(rxns));    
end

% Close wait bar
close(my_wait)

% Create a wait bar
my_wait = waitbar(0,'PS_model in Progress...');

% Run PS
for i = 1:length(rxns)    
    % Turn off reaction and test for growth
    test = changeRxnBounds(ps_model,rxns{i},0,'b');
    % Put a timer on that restricts it to 20 seconds
    solution = NaN;  
    i
    try
        t0 = clock;
        while(etime(clock,t0) < 20)
        solution = optimizeCbModel(test,[],'one',false); 
        break     
        end
    catch
        warning('Problem with %s on PS; assigning NaN',rxns{i})
        solution = NaN;
    end
    % Find rxn flux for result 
    if isstruct(solution)
    results(i,2) = solution.f/ps_wt.f;    
    else
        results(i,2) = solution/ps_wt.f;
    end   
    % Update wait bar
    waitbar(i/length(rxns));    
end
% Close wait bar
close(my_wait)

% Create a wait bar
my_wait = waitbar(0,'LS_model in Progress...');

% Run LS
for i = 1:length(rxns)    
    % Turn off reaction and test for growth
    test = changeRxnBounds(ls_model,rxns{i},0,'b');
    % Put a timer on that restricts it to 20 seconds
    solution = NaN;       
    i
    try
        t0 = clock;
        while(etime(clock,t0) < 20)
        solution = optimizeCbModel(test,[],'one',false); 
        break
        end
    catch
        warning('Problem with %s on LS; assigning NaN',rxns{i})
        solution = NaN;
    end
    % Find rxn flux for result 
    if isstruct(solution)
    results(i,3) = solution.f/ls_wt.f;    
    else
        results(i,3) = solution/ls_wt.f;
    end  
    % Update wait bar
    waitbar(i/length(rxns)); 
end
% Close wait bar
close(my_wait)

% Create a wait bar
my_wait = waitbar(0,'CC_model in Progress...');

% Run CC
for i = 1:length(rxns)    
    % Turn off reaction and test for growth
    test = changeRxnBounds(cc_model,rxns{i},0,'b');
    % Put a timer on that restricts it to 20 seconds
    solution = NaN;     
    i
    try
        t0 = clock;
        while(etime(clock,t0) < 20)
        solution = optimizeCbModel(test,[],'one',false); 
        break
        end     
    catch
        warning('Problem with %s on CC; assigning NaN',rxns{i})
        solution = NaN;
    end
    % Find rxn flux for result 
    if isstruct(solution)
    results(i,4) = solution.f/cc_wt.f;    
    else
        results(i,4) = solution/cc_wt.f;
    end    
    % Update wait bar
    waitbar(i/length(rxns));    
end
% Close wait bar
close(my_wait)

% Write to an Excel workbook
xlswrite('rxnEssentiality.xlsx',rxns,'No_Loops','A2:A32')
xlswrite('rxnEssentiality.xlsx',results(:,1),'No_Loops','B2:B32')
xlswrite('rxnEssentiality.xlsx',results(:,2),'No_Loops','C2:C32')
xlswrite('rxnEssentiality.xlsx',results(:,3),'No_Loops','D2:D32')
xlswrite('rxnEssentiality.xlsx',results(:,4),'No_Loops','E2:E32')

    