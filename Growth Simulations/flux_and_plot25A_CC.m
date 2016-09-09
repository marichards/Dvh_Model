function [solution]=flux_and_plot25A_CC(model, threshhold, plot)

%varargout{1}
%solution=inputname(2)
modelname=inputname(1);
solutionname=strcat('testing_', modelname,'.svg');

%solution2=solution;
solution=optimizeCbModel(model, [], 0 , false);

%save solution;

if (solution.stat==1)
    
    graph={'EX_cpd00047(e)','EX_cpd00159(e)','rxn14404','rxn00157',...
        'rxn00173','rxn00225','rxn05488','rxn05602','rxn05938',...
        'rxn08793A','EX_cpd00209(e)','rxn14405','rxn08971', 'rxn14407',...
        'rxn14408','EX_cpd11640(e)','rxn14410','rxn14412','rxn14414',...
        'rxn14417A','rxn14403', 'rxn14415','EX_cpd00239(e)', 'EX_cpd00048(e)',...
        'rxn05651A', 'rxn00379', 'rxn14419', 'rxn14413A', 'rxn14416',...
        'rxn14418','EX_cpd00011(e)','rxn10042', 'rxn00371A','rxn14420',...
        'rxn00175', 'rxn11934B_CC'};
    
    fid=fopen('./test_out.txt', 'wt');
    
    % Intersect it instead of straight-up looping
    [rxns,idx] = intersect(model.rxns,graph,'stable');
    
    %    list={};
    for i=1:length(graph) %cycle through the list of reactions
%     %rxn=graph{i};
%     
%     for j=1:length(model.rxns)
        %             rxn=model.rxns{j};
        %             lb=model.lb(j);
        %             ub=model.ub(j);
        
        %this is being done since qmo has two forms for it now.  QMO and
        %QMOa (with confurcation).
        %             huh='rxn11934B_CC';
        %
        %             if strcmp(huh, rxn)
        %
        %                 rxn='rxn11934A';
        %
        %             end
        
        %             test=strcmp(rxn,graph{i});
        
        %             if (test==1);
        
        if (abs(solution.x(idx(i)))>=threshhold); %if particular reaction (i) has |flux| > 0.5 then  exists in the model
            
            %                     fprintf('%s \t %s  \t %f\t %f \t %f \n', rxn, model.rxnNames{j}, solution.x(j), lb, ub);
            fprintf(fid, '%s \t %s  \t %f\t %f \t %f \n', rxns{i},...
                model.rxnNames{idx(i)}, solution.x(idx(i)),...
                model.lb(idx(i)), model.ub(idx(i)));
            
        end
        %             end
    end
%     end
    %out = evalc(['disp(solution)'])
    
    if (plot==1);  %remove this is new addition does not work
        
        perl('./SVG_flux_adjust_test4.pl','drawing_moreW25A_CC.svg', 'test_out.txt', solutionname);
        %system(['open //Applications/Inkscape.app/ -f' output '-echo']);
        %system(['open ' solutionname]);
        
    end %remove this is new addition does not work
else
    error('This did not work');
    
end
end